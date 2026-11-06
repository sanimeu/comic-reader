import 'dart:typed_data';

enum ComicFormat { cbz, zip, cbr, cb7, pdf, imageFolder, singleImage }

class PageRef {
  const PageRef(this.index, this.name);
  final int index;
  final String
  name; // entry path inside archive, file name, or "Page N" for PDF
}

/// Page dimensions WITHOUT decoding/rendering the page.
/// Images: read from the header (JPEG SOF, PNG IHDR, WEBP VP8/VP8L/VP8X).
/// PDF: page box converted to points (1/72 inch), rotation applied.
/// The reader uses this to lay out a continuous scroll before pages load.
class PageSize {
  const PageSize(this.width, this.height);
  final double width;
  final double height;
  double get aspectRatio => height == 0 ? 1 : width / height;
}

/// What the reader needs to produce pixels for a page.
/// [targetWidthPx] is the display width in physical pixels. PDF pages are rendered
/// at exactly this width; image sources ignore it (the decoder downsamples with
/// ResizeImage / codec target size).
class PageRequest {
  const PageRequest({required this.targetWidthPx});
  final int targetWidthPx;
}

/// Result of [ComicSource.loadPage]. Exhaustive via `switch`.
sealed class PageContent {
  const PageContent();
}

/// Compressed image bytes (jpg/png/webp) from an archive, folder or file.
/// The page pipeline decodes them with downsampling.
class EncodedImagePage extends PageContent {
  const EncodedImagePage(this.bytes);
  final Uint8List bytes;
}

/// Already-rendered pixels, used for PDF pages. [rgba] is width*height*4 bytes,
/// premultiplied-alpha RGBA8888, rendered by the PDF engine at the requested width.
class RasterPage extends PageContent {
  const RasterPage({
    required this.rgba,
    required this.width,
    required this.height,
  });
  final Uint8List rgba;
  final int width;
  final int height;
}

class ComicOpenException implements Exception {
  ComicOpenException(this.userMessage, {this.cause});
  final String userMessage; // safe to show in the UI
  final Object? cause;
  @override
  String toString() => 'ComicOpenException($userMessage, cause: $cause)';
}

/// One implementation per format; the reader never knows which one it holds.
/// Contract:
///  - open() indexes entries only; it never extracts the whole archive to disk.
///  - [pages] is naturally sorted and filtered to jpg/jpeg/png/webp (PDF: one per page).
///  - [pageSize] is cheap and does not decode or render.
///  - [loadPage] returns [EncodedImagePage] for image-based sources and [RasterPage]
///    for PDF, so one reader pipeline handles both with a `switch`.
///  - Corrupt input throws [ComicOpenException] with a human-readable message.
abstract class ComicSource {
  ComicFormat get format;
  List<PageRef> get pages;
  int get pageCount => pages.length;
  Future<PageSize> pageSize(int index);
  Future<PageContent> loadPage(int index, PageRequest request);
  Future<void> close();
}
