# Comic Reader (Flutter / Windows + Android)

This repository continues the existing dashboard and Drift-backed library implementation.

## Current implementation status

- Reader settings: horizontal page mode / continuous vertical list, 0/90/180/270-degree rotation, fit-screen / fit-width, persisted in the existing SQLite `settings` table.
- Reader: restores page and vertical scroll offset, supports keyboard navigation, page slider, zoom via `InteractiveViewer`, lazy list construction in vertical mode, and image decode width limits.
- Comic archive reading/import supports CBZ and ZIP image archives with natural page ordering. Corrupt archives and archives without supported image pages produce readable errors.
- PDF import and reading are implemented with the PDFium-backed `pdfrx` viewer. PDF files are validated and page-count indexed on import; rendering remains inside the PDF engine.
- CBR and CB7 are not implemented; they still require a RAR/7z backend. Automatic background folder watching and Windows release packaging remain outstanding.

## Build and verification

Run from this directory with Flutter 3.29+ and Dart 3.7+:

```powershell
flutter pub get
flutter analyze
flutter test
flutter run -d windows
flutter build windows --release
```

The editing environment used for this continuation does not have the Flutter or Dart SDK installed, so dependency resolution, analyzer, tests, and Windows compilation could not be executed here. Run the commands above on a Flutter-equipped Windows machine before release.

See `docs/WINDOWS_SETUP.md` for Windows prerequisites and `docs/ARCHITECTURE_NOTES.md` for existing design decisions.


## PDF reading

PDF files can be imported alongside CBZ/ZIP chapters and opened in the built-in PDFium-backed reader (pdfrx). PDF pages are rendered on demand by the PDF engine rather than extracted as images during import. The PDF reader provides its own scrolling, zoom, text selection, and navigation controls. PDF reading progress is not yet synchronized with the app’s SQLite progress tracker; CBZ/ZIP progress continues to use the app tracker. Windows builds using pdfrx require Windows Developer Mode to be enabled for native build symlinks.

## Releases and website

- Push a tag like `v0.1.0` to build a Windows `.zip` and an Android `.apk` and attach them to a GitHub Release (`.github/workflows/build.yml`).
- The landing page in `site/` is deployed to GitHub Pages (`.github/workflows/pages.yml`). In the repo, go to Settings → Pages → Source: **GitHub Actions**.
- The Android folder is not stored in the repo; the workflow generates it with `flutter create` and installs the MainActivity from `platform_snippets/`.
