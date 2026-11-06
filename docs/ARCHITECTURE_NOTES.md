# Technical decisions (Phase 1, extended in Phase 2)

## D1: Archive engine = libarchive through dart:ffi
- Pure-Dart `archive` handles ZIP only; there is no maintained pure-Dart RAR reader.
- libarchive reads ZIP, 7z and RAR/RAR5 behind one C API, supports streaming per entry, and verifies CRCs.
- Cost: we ship native libraries (Windows DLL; Android .so per ABI), including zlib, bzip2 and liblzma, which 7z needs.
- Spike result (native engine only, Linux, libarchive 3.7.2): ZIP, solid and non-solid 7z, RAR5 all pass; corrupt input raises cleanly.

## D2: Solid archives cost more per random page
Measured on a 12-page test set: ZIP last page 4 ms, non-solid 7z 17 ms, solid 7z 56 ms (first page 10 ms).
Solid cost grows with archive size. Therefore:
- Keep one open reader per comic and read **sequentially** with prefetch for solid RAR/7z.
- Seeking backwards or jumping far in a large solid archive reopens and scans; cap this with a progress indicator.
- If a solid archive's cost is too high, fall back to per-chapter temp extraction in app cache (deleted on close), never into the user's library.

## D3: Storage abstraction
Android SAF yields content URIs. A `StorageProvider` interface hides this; archives needing a seekable file
may be copied into a bounded temp cache. To be designed and device-tested in Phase 3/6.

## D4: Glass performance rules
- readerChrome never blurs. Blur max about 3 layers; cards in scrolling lists pass blurOverride:false.
- Low quality swaps blur for a more opaque fill. Default auto-chosen from Android memory class / low-RAM flag.

## D5: Image adjustments
One 5x4 ColorFilter matrix (brightness, contrast, saturation, invert composed) at paint time. No pixel copies.

## D6: ComicSource v2 (replaces the V2 interface)
- `readPage(index) -> bytes` is replaced by `pageSize(index)` (header-only dimensions, no decode) and `loadPage(index, PageRequest)` returning a sealed `PageContent`:
  `EncodedImagePage` (archive/folder/image) or `RasterPage` (PDF, rendered at the requested pixel width).
- `PageRef` no longer carries width/height; sizes come from `pageSize` so the reader can lay out a continuous scroll before pages load.
- Nothing implemented the old interface, so nothing broke. `archive_comic_source.dart` (docs/FFI_PLAN.md) will implement the new one, with header parsing for JPEG/PNG/WEBP sizes.

## D7: Responsive classes by width, not platform
compact < 700 (bottom glass nav), medium 700-1099 (floating sidebar), expanded >= 1100 (sidebar + right panel). Windows and Android share one code path.
Blur budget (D4): sidebar + one content panel + right panel at most; cards in lists never blur.

## D8: Domain layer is pure Dart
`models.dart`, `library_query.dart`, `reading_stats.dart`, `duplicates.dart`, `natural_sort.dart` import no Flutter, so they are unit-testable without a device.
The dashboard reads them through Riverpod `Notifier` providers (`features/dashboard/providers.dart`), currently seeded with sample data.

## D9: Duplicates are never decided by the partial hash
A partial hash (size + sampled blocks) only nominates candidates. `confirmDuplicates` compares full bytes through a platform `ByteStreamOpener`.
The UI must call unconfirmed groups "possible duplicates".

## Known limits
- Fixture coverage is small. RAR4, encrypted, multi-volume and WEBP-in-archive are untested.
- Linux results do not prove Windows or Android builds work.
- Phase 2 Dart (dashboard + domain tests) has never been compiled or run by the author.
- DB mapping to do in Phase 3: schema `format` values `folder`/`image` vs enum `imageFolder`/`singleImage`; `series.is_completed` vs status derived from progress; chapter counts derived from comics per series.
