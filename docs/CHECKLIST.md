# Feature checklist (three separate tracks)

Legend: ✅ done · ⬜ not done · ➖ not applicable yet
- **Written** = code exists.  
- **Unit-tested** = an automated test was actually executed and passed.  
- **Device-tested** = verified by running on a real Windows machine / Android device.

Nothing below is marked tested unless it was run. Dart code has **not been compiled** by me
(no Flutter SDK in my sandbox); the first `flutter analyze` on your machine is the real compile check.

## Phase 1: Architecture and feasibility

| Item | Written | Unit-tested | Device-tested | Notes |
|---|---|---|---|---|
| libarchive engine: ZIP/CBZ list + page read | ✅ | ✅ | ⬜ | Python/ctypes on Linux, byte-identical pages |
| libarchive engine: 7z/CB7 (solid + non-solid) | ✅ | ✅ | ⬜ | same |
| libarchive engine: RAR5/CBR (stored, compressed, solid, unicode names) | ✅ | ✅ | ⬜ | 4 real fixtures from libarchive test suite |
| libarchive engine: corrupt / truncated / empty input fails cleanly | ✅ | ✅ | ⬜ | no crash, no hang |
| **RAR4 (older CBR): PENDING TASK** | ⬜ | ⬜ | ⬜ | **Untested on every platform. CBR is not claimed as supported until RAR4 and RAR5 both pass on Windows and Android. See docs/FFI_PLAN.md section 9.** |
| RAR/7z encrypted, multi-volume | ⬜ | ⬜ | ⬜ | untested; plan: show clear unsupported message |
| WEBP pages inside archives | ⬜ | ⬜ | ⬜ | spike used JPG/PNG only |
| Dart FFI binding to libarchive | ⬜ (plan written: docs/FFI_PLAN.md) | ⬜ | ⬜ | no code yet |
| libarchive DLL build for Windows | ⬜ | ⬜ | ⬜ | next step |
| libarchive .so build for Android (arm64-v8a, armeabi-v7a, x86_64) | ⬜ | ⬜ | ⬜ | next step |
| PDF via pdfrx | ⬜ | ⬜ | ⬜ | Phase 3 |
| Design tokens (colours, radii, glass, motion, type) | ✅ | ➖ | ⬜ | |
| GlassPanel (blur / low / readerChrome never blurs) | ✅ | ⬜ | ⬜ | needs your eyes on real hardware |
| Glass Quality auto default (Android channel) + manual override | ✅ | ⬜ | ⬜ | override not yet persisted (Phase 2) |
| Natural sort | ✅ | ⬜ (test written, not run) | ➖ | |
| Glass rules widget tests (blur on High, none on Low, reader chrome never blurs, radii, accent) | ✅ | ⬜ (written, not run) | ➖ | last test now pumps DesignPreviewScreen directly |
| Project compiles: `flutter analyze` clean | ➖ | ⬜ | ⬜ | **you run this; I have not compiled any Dart** |
| Design Preview on Windows / Android | ✅ | ➖ | ⬜ | now reachable from Settings > Design preview |
| Dependency probe (all candidate packages build on Windows + Android) | ✅ (script) | ➖ | ⬜ | script untested; run tools/dep_probe/run_probe.ps1 |
| PowerShell setup + Android snippet scripts | ✅ | ⬜ | ⬜ | untested, written without a Windows machine |
| SQLite schema | ✅ | ⬜ | ➖ | not yet applied to a DB |

## Phase 2: Domain layer and responsive dashboard (this drop)

"Unit-tested" stays ⬜ everywhere below: tests are written, but no Flutter SDK was available to run them.

| Item | Written | Unit-tested | Device-tested | Notes |
|---|---|---|---|---|
| Library model (LibraryItem, enums, CollectionInfo) | ✅ | ⬜ (written, not run) | ➖ | supplied file, unchanged |
| Search + filters + sort (`applyQuery`) | ✅ | ⬜ (written, not run) | ➖ | supplied file, unchanged |
| Reading stats (`computeStats`) | ✅ | ⬜ (written, not run) | ➖ | supplied file, unchanged |
| Duplicate detection contract (candidates, then byte-compare confirm) | ✅ | ⬜ (written, not run) | ➖ | supplied file, unchanged; platform `ByteStreamOpener` not written |
| ComicSource v2 contract (`pageSize`, `loadPage`, sealed `PageContent`) | ✅ | ➖ | ➖ | replaces V2 interface; no implementation yet |
| Layout classes (compact < 700, medium < 1100, expanded) | ✅ | ⬜ (written, not run) | ⬜ | by width, not platform |
| Dashboard shell: bottom nav / sidebar / right panel | ✅ | ⬜ (widget tests written, not run) | ⬜ | needs your eyes on Windows + Android |
| Home (hero, continue reading, stats, recently added) | ✅ | ⬜ | ⬜ | sample data |
| Library (search, type/status/favourite filters, sort, grid/list, filter sheet on compact) | ✅ | ⬜ | ⬜ | sample data |
| Collections / History / Favourites pages | ✅ | ⬜ | ⬜ | collections are view-only; no create/edit yet |
| Settings (glass quality toggle, offline note, design preview link) | ✅ | ⬜ | ⬜ | glass quality choice not persisted yet |
| Favourite toggle (in memory) | ✅ | ⬜ | ⬜ | not persisted; no database yet |
| Generated covers + "Sample data" badge | ✅ | ➖ | ⬜ | real covers need Phase 3 |
| Reader / Resume / opening a comic | ⬜ | ⬜ | ⬜ | buttons show an honest "not built yet" message |
| Add folder / scan / import | ⬜ | ⬜ | ⬜ | Phase 3 |
| Database repository (drift) replacing sample data | ⬜ | ⬜ | ⬜ | Phase 3; must map `folder`/`image` <-> `imageFolder`/`singleImage` |

## Later phases (all ⬜ / ⬜ / ⬜ until built)
Folder scan, series grouping, collection editing, duplicate detection UI, storage page,
reader (vertical, horizontal, LTR/RTL, zoom, input config, page-flip), auto next chapter,
image adjustments, progress, bookmarks, Windows features (drag-drop, shortcuts, fullscreen),
Android features (SAF, immersive), settings persistence, release builds.
