"""
Phase 1 feasibility spike: can libarchive (the engine we plan to bind via dart:ffi)
list and randomly read pages from CBZ/ZIP, CB7 (7z, solid + non-solid) and CBR (RAR5)?

This validates the NATIVE ENGINE ONLY, via ctypes against the same libarchive C API
the Dart FFI binding will call. It does NOT validate the Dart binding, Windows or Android.
Usage: python3 archive_spike.py <fixtures_dir>
"""
import sys, os, re, time, hashlib, shutil, tempfile
import libarchive

IMG = re.compile(r'\.(jpe?g|png|webp)$', re.I)

def natural_key(s):
    return [int(t) if t.isdigit() else t.lower() for t in re.split(r'(\d+)', s)]

def list_entries(path):
    out = []
    with libarchive.file_reader(path) as a:
        for e in a:
            if e.isfile:
                out.append((e.pathname, e.size))  # size is None for RAR hard links
    return out

def read_one(path, name):
    with libarchive.file_reader(path) as a:
        for e in a:
            if e.pathname == name:
                return b''.join(e.get_blocks())
    raise KeyError(name)

results = []
def check(label, ok, note=''):
    results.append((label, ok, note))
    print(f"[{'PASS' if ok else 'FAIL'}] {label} {note}")

def main(fx):
    pages_dir = os.path.join(fx, 'pages')
    originals = {f: open(os.path.join(pages_dir, f), 'rb').read() for f in os.listdir(pages_dir)}

    for fname in ['t_zip.zip', 't_nonsolid.7z', 't_solid.7z']:
        p = os.path.join(fx, fname)
        ents = list_entries(p)
        pages = sorted([n for n, _ in ents if IMG.search(n)], key=natural_key)
        check(f'{fname}: lists + natural-sorts image pages',
              len(pages) == 12 and pages[:3] == ['page1.jpg', 'page2.png', 'page3.jpg'] and pages[-1] == 'page12.png',
              f'({len(pages)} pages)')
        ok = True
        for n in pages:
            if read_one(p, n) != originals[n]:
                ok = False
        check(f'{fname}: every page byte-identical to original', ok)
        t0 = time.perf_counter(); read_one(p, pages[0]); t_first = time.perf_counter() - t0
        t0 = time.perf_counter(); read_one(p, pages[-1]); t_last = time.perf_counter() - t0
        print(f'    random access: first={t_first*1000:.1f} ms  last={t_last*1000:.1f} ms')

    # RAR5 fixtures (real files produced by WinRAR, from the libarchive test suite)
    for fname, expect_n in [('test_read_format_rar5_stored.rar', 1),
                            ('test_read_format_rar5_compressed.rar', 1),
                            ('test_read_format_rar5_solid.rar', 6),
                            ('test_read_format_rar5_unicode.rar', 2)]:
        p = os.path.join(fx, fname)
        try:
            ents = list_entries(p)
            ok = len(ents) >= expect_n
            data_ok = True
            for n, size in ents:
                d = read_one(p, n)          # libarchive verifies the RAR CRC while reading
                if size is not None and len(d) != size: data_ok = False  # hard-link entries report no size
            check(f'{fname}: list + full read with CRC verification', ok and data_ok, f'({len(ents)} entries)')
        except Exception as ex:
            check(f'{fname}: list + full read', False, repr(ex))

    # Corruption handling: must raise, never hang or crash the process
    src = os.path.join(fx, 't_zip.zip')
    raw = open(src, 'rb').read()
    tmp = tempfile.mkdtemp()
    cases = {
        'truncated_half': raw[:len(raw)//2],
        'garbage_header': b'\x00' * 64 + raw[64:],
        'random_noise': os.urandom(4096),
        'empty_file': b'',
    }
    for label, blob in cases.items():
        p = os.path.join(tmp, label + '.cbz')
        open(p, 'wb').write(blob)
        try:
            ents = list_entries(p)
            good = 0
            for n, _ in ents:
                try: read_one(p, n); good += 1
                except Exception: pass
            check(f'corrupt/{label}: handled without crash', True, f'(listed {len(ents)}, readable {good})')
        except Exception as ex:
            check(f'corrupt/{label}: handled without crash', True, f'(clean error: {type(ex).__name__})')
    shutil.rmtree(tmp)

    fails = [r for r in results if not r[1]]
    print(f'\n{len(results)-len(fails)}/{len(results)} checks passed')
    sys.exit(1 if fails else 0)

if __name__ == '__main__':
    main(sys.argv[1])
