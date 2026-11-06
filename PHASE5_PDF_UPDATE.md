# PDF support update

## Added
- PDF is accepted in the file picker and recursive library-folder scan.
- PDF import opens each file with the PDFium-backed `pdfrx` engine, validates it, records its page count and stores it as `ComicFormat.pdf`.
- PDFs open in `PdfViewer.file`, which handles PDF page rendering, scrolling and zoom without extracting every page into image files.
- PDFium initialization is performed once at application startup.
- CBZ/ZIP import and the existing image reader remain in place.

## Still not included
- CBR/RAR and CB7/7z support.
- PDF reading position is not yet synchronized to the app's SQLite reading-progress table; PDF navigation is managed by the embedded PDF viewer.
- PDF cover thumbnails are not generated during import.

## Dependency/toolchain
- Added `pdfrx: ^1.1.35` (Dart 3.7+; Windows and Android supported by the package).
- Updated the project's minimum SDK declaration to Dart 3.7 / Flutter 3.29.
- On Windows, `pdfrx` native builds require Developer Mode to be enabled.

## Verification
- Source changes and ZIP archive integrity checked.
- Flutter/Dart SDK are not installed in the editing environment, so `flutter pub get`, `flutter analyze`, `flutter test`, and platform builds could not be run here. Run those commands on a machine with Flutter 3.29+ before release.
