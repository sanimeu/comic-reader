# libarchive via dart:ffi: integration plan

Status: **PLAN ONLY. No Dart FFI code exists yet.** Nothing here is tested on Windows or Android.
Native-engine behaviour (ZIP / 7z / RAR5) was verified on Linux through ctypes (see tools/archive_spike).

## 1. Why hand-written bindings (not ffigen)
We need about 20 functions. Hand-written `lookupFunction` bindings avoid the ffigen + LLVM/libclang
toolchain on Windows and keep the surface auditable. Revisit ffigen only if the surface grows.

## 2. C functions to bind (libarchive 3.x)
Lifecycle: `archive_read_new`, `archive_read_close`, `archive_read_free`
Formats/filters: `archive_read_support_format_zip`, `_7zip`, `_rar`, `_rar5`, `archive_read_support_filter_all`
 (explicit per-format registration, not `support_format_all`, so unwanted formats are not enabled)
Open: `archive_read_open_filename_w` (Windows, wide path, handles non-ASCII), `archive_read_open_filename` (UTF-8 path on Android when a real path exists), `archive_read_open_fd` (Android SAF descriptor)
Iterate: `archive_read_next_header`, `archive_read_data_skip`
Entry: `archive_entry_pathname_utf8`, `archive_entry_size`, `archive_entry_size_is_set`, `archive_entry_filetype`
Data: `archive_read_data` (into a pre-sized native buffer)
Errors: `archive_errno`, `archive_error_string`
Return codes handled: ARCHIVE_OK 0, EOF 1, RETRY -10, WARN -20, FAILED -25, FATAL -30.
Also `close(fd)` from the C runtime for descriptors we detach on Android.

## 3. Module layout (to be created in Phase 3 spike)
```
lib/data/sources/libarchive/
  libarchive_bindings.dart     // DynamicLibrary load + typedefs + lookups (the only file that touches Pointer)
  archive_reader.dart          // safe wrapper: open, index(), readEntry(name) -> Uint8List, close()
  archive_worker.dart          // long-lived Isolate owning one reader; SendPort protocol
  archive_comic_source.dart    // implements ComicSource for cbz/zip/cbr/cb7
```

## 4. Threading and memory rules
- libarchive handles are **not thread-safe** and pointers cannot cross isolates. Each open comic gets **one long-lived worker isolate**
  that owns its `archive*`. UI talks to it through a SendPort; results return as `TransferableTypedData` (no copy storms).
- Every native allocation (path strings, buffers) is freed in `finally`. `archive_read_free` is always called, including on error paths.
- Entry read: allocate `size` bytes natively (reject above a configurable cap, default 64 MB, with a user-facing message), loop `archive_read_data`
  until EOF, copy to `Uint8List`, free. Never decode here; decoding happens downstream in the page pipeline with downsampling.
- Entry size unknown (`size_is_set` false): stream into a growing buffer with the same cap.

## 5. Opening strategy per platform
- **Windows:** `archive_read_open_filename_w` with a UTF-16 path. Block size 64 KB to start (tune later).
- **Android:** if SAF gives a real filesystem path, use `archive_read_open_filename`. Otherwise Kotlin opens the document with
  `ContentResolver.openFileDescriptor`, calls `detachFd()`, passes the int to Dart; Dart uses `archive_read_open_fd` and closes it with `close()`.
  Fallback if the descriptor is not seekable: copy into a bounded temp cache file, open that, delete on close. To be device-tested.

## 6. Reading pages efficiently
- **Indexing pass:** iterate headers once, `archive_read_data_skip` each entry, collect (pathname, size). Filter to jpg/jpeg/png/webp, naturally sort.
  For **solid** RAR/7z, skipping can still require decompressing; measure indexing time on large solid files. Cache the index in SQLite (`page_count`).
- **Random access:** libarchive is forward-only. A reader keeps its position; if the target entry is ahead, continue forward; if behind, reopen and rescan.
  ZIP and non-solid 7z skip cheaply (seekable); solid archives pay decompression cost (spike: 4 ms ZIP vs 56 ms solid 7z last-page on a tiny set; grows with size).
- If archive order differs from natural page order, keep a small read-ahead map keyed by entry so sequential reading stays forward-only.
- Reader (Phase 4) requests pages sequentially with prefetch, which is the cheap path for solid archives.

## 7. Native library packaging
**Windows:** build libarchive with zlib, bzip2 and liblzma (7z needs LZMA) as a DLL (vcpkg `libarchive[bzip2,lzma,zlib]:x64-windows` or CMake). Place DLLs
beside the exe via `windows/CMakeLists.txt` `install(FILES ...)`. Load with `DynamicLibrary.open('archive.dll')`.
**Android:** build with the NDK for arm64-v8a, armeabi-v7a, x86_64 (CMake in `android/app/src/main/cpp`, `externalNativeBuild`), output
`libarchive.so` into jniLibs. Load with `DynamicLibrary.open('libarchive.so')`. 16 KB page-size alignment must be checked for current Play requirements.
**Licences:** libarchive BSD-2 (includes its own RAR decoder, no UnRAR licence involved), zlib, bzip2 (BSD-style), xz/liblzma (public domain). Ship notices in the app.
Decision between vcpkg and direct CMake is made in the spike, based on which one builds cleanly for both targets.

## 8. Test plan (nothing below is done)
| Test | Where | Status |
|---|---|---|
| Load library, `archive_version_string` returns | Windows `flutter test`; Android integration_test | NOT RUN |
| ZIP/CBZ, solid + non-solid 7z, RAR5 fixtures: list, read, byte-compare (tools/archive_spike fixtures) | Windows + Android | NOT RUN |
| Unicode names, large entries, tall images, WEBP pages | both | NOT RUN |
| Corrupt/truncated/empty/garbage: clean `ComicOpenException`, no crash/hang | both | NOT RUN |
| Worker isolate: open, read, close 1,000 times, memory flat | both | NOT RUN |
| 2 GB archive index time and peak memory | Windows first | NOT RUN |

## 9. PENDING: RAR4 (older CBR). Explicit open task
Most older CBR files are RAR4 (`Rar!\x1a\x07\x00`), RAR5 uses `Rar!\x1a\x07\x01\x00`. The Linux spike covered **RAR5 only**.
1. Obtain RAR4 fixtures: from your own CBR files, or created with WinRAR / `rar a -ma4`. Cover: stored, compressed (LZSS), PPMd, solid, filters, unicode names, multi-file.
2. Run them through the Linux spike (add to `archive_spike.py`), then through the Dart FFI reader on Windows and Android.
3. Gate: **CBR will not be described as supported until both RAR4 and RAR5 fixture sets pass on both platforms.**
4. If libarchive fails on common RAR4 cases, options are (a) bundle the official UnRAR decompression library (its licence allows decompression use but forbids recreating the RAR compression algorithm, so we must review it), (b) offer a clear "unsupported RAR variant" message with a suggestion to convert to CBZ. Decide only with test evidence.
Also pending: encrypted archives and multi-volume RAR (planned behaviour: detect and show a clear unsupported message).
