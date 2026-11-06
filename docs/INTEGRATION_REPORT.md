# Integration report: V2 scaffold + six new Dart files

**Verification status: nothing in this drop was compiled or run.** No Flutter/Dart SDK was available
(download hosts blocked). Only a static check was done: every import resolves to a real file, brackets balance,
all imported packages are declared in pubspec.yaml, and `lib/` contains no network code.
Your first `flutter analyze` and `flutter test` are the real verification.

## Already implemented in V2
Design tokens, GlassPanel (blur / low / reader chrome never blurs), AmbientBackground, glass quality provider,
natural sort, SQLite schema, original ComicSource interface, libarchive FFI plan, archive spike (Python), setup scripts,
docs, Inter fonts, 10 tests (3 + 7). `main.dart` was only a Design Preview. `features/` and `shared/widgets/` were empty.

## Where the six supplied files went (all copied byte-for-byte)
| File | Destination | Action |
|---|---|---|
| models.dart | lib/domain/ | new |
| library_query.dart | lib/domain/ | new (relative imports of models/natural_sort force this folder) |
| reading_stats.dart | lib/domain/ | new |
| duplicates.dart | lib/domain/ | new |
| layout_class.dart | lib/core/layout/ | new |
| comic_source.dart | lib/domain/ | **replaced** the V2 file (v2 contract, see ARCHITECTURE_NOTES D6) |

## Conflicts
- One real conflict: `comic_source.dart`. `PageRef` lost optional width/height; `readPage()` became `pageSize()` + `loadPage()` returning sealed `PageContent`. Nothing referenced the old API, so nothing broke.
- Watch-items for Phase 3 (not conflicts): schema `format` `'folder'`/`'image'` vs enum `imageFolder`/`singleImage`; schema has no chapter counts (derive from comics per series); `series.is_completed` vs status derived from progress.

## Added by this integration
- `lib/features/dashboard/`: shell (compact / medium / expanded), sidebar, glass bottom nav, right panel, Home, Library (search, filters, sort, grid/list, filter sheet), Collections, History, Favourites, Settings, Riverpod providers, sample data.
- `lib/shared/widgets/`: generated cover, accent progress bar, glass chip, empty state.
- `lib/core/format/relative_time.dart`.
- `lib/features/design_preview/design_preview_screen.dart`: the V2 preview, moved verbatim out of main.dart (plus a back button when pushed). Reachable from Settings.
- `main.dart`: home is now the dashboard; `ComicReaderApp` name kept.
- Tests: 37 new + 10 existing = 47 by source count. The only existing test edited is the last one in `glass_rules_test.dart` (it pumps `DesignPreviewScreen` directly because the dashboard is now home).
- Docs: README, CHECKLIST, ARCHITECTURE_NOTES (D6-D9), WINDOWS_SETUP (test count, what to inspect).
- pubspec.yaml: **unchanged** (no new dependencies).

## Deliberately not done
Archive engine / FFI, PDF, folder picker and scanning, database, reader, persistence of settings or favourites,
collection editing, duplicate-detection UI. Buttons that would need them say so instead of pretending.

## Honest caveats
- Layouts were written without ever seeing them render. Overflow or spacing problems are possible; report any red/yellow stripes.
- Widget tests assume text renders in the test environment the way it does on device; font metrics in tests can differ.
- Sample titles are fictional; covers are generated gradients.
