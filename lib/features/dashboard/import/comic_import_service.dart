import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdfrx/pdfrx.dart';

import '../../../data/db/app_database.dart';
import '../../../domain/natural_sort.dart';
import '../../../domain/comic_source.dart' show ComicFormat;

class ComicImportResult {
  const ComicImportResult({required this.imported, required this.skipped});

  final int imported;
  final int skipped;
}

/// Imports CBZ/ZIP/PDF chapters into SQLite and caches image-archive covers.
/// The original archives are never moved, renamed, or deleted.
class ComicImportService {
  ComicImportService(this.db);

  final AppDatabase db;

  static const supportedExtensions = {'.cbz', '.zip', '.pdf'};
  static const detectedButNotReadableExtensions = {'.cbr', '.cb7'};
  static const _pageExtensions = {'.jpg', '.jpeg', '.png', '.webp'};
  static const _chapterPattern =
      r'(?:^|[^a-z])(?:chapter|ch|vol(?:ume)?)\s*[-_. ]*0*(\d+(?:\.\d+)?)\b';

  Future<ComicImportResult> scanFolder(String folderPath) async {
    final directory = Directory(folderPath);
    if (!await directory.exists()) {
      throw Exception('Selected folder does not exist.');
    }

    final paths = <String>[];
    await for (final entity in directory.list(
      recursive: true,
      followLinks: false,
    )) {
      if (entity is File &&
          supportedExtensions.contains(
            p.extension(entity.path).toLowerCase(),
          )) {
        paths.add(entity.path);
      }
    }
    paths.sort(naturalCompare);
    return importFiles(paths, rootPath: folderPath);
  }

  Future<ComicImportResult> importFiles(
    List<String> filePaths, {
    String? rootPath,
  }) async {
    final files = <File>[];
    for (final filePath in filePaths) {
      final file = File(filePath);
      if (supportedExtensions.contains(p.extension(filePath).toLowerCase()) &&
          await file.exists()) {
        files.add(file);
      }
    }
    if (files.isEmpty) {
      return const ComicImportResult(imported: 0, skipped: 0);
    }

    // Cache files are stored in app support, not beside the user's comic files.
    final supportDirectory = await getApplicationSupportDirectory();
    final coverDirectory = Directory(
      p.join(supportDirectory.path, 'comic_covers'),
    );
    await coverDirectory.create(recursive: true);

    return db.transaction(() async {
      int? rootId;
      if (rootPath != null) {
        final normalizedRoot = p.normalize(p.absolute(rootPath));
        await db
            .into(db.libraryRoots)
            .insertOnConflictUpdate(
              LibraryRootsCompanion.insert(
                uri: normalizedRoot,
                displayName: p.basename(normalizedRoot),
                lastScanAt: Value(DateTime.now().millisecondsSinceEpoch),
              ),
            );
        final root = await (db.select(
          db.libraryRoots,
        )..where((row) => row.uri.equals(normalizedRoot))).getSingle();
        rootId = root.id;
      }

      final existingComics = await db.select(db.comics).get();
      final knownUris = existingComics.map((comic) => comic.uri).toSet();
      final existingSeries = await db.select(db.series).get();
      final seriesIds = <String, int>{
        for (final series in existingSeries)
          series.title.toLowerCase(): series.id,
      };

      var imported = 0;
      var skipped = 0;
      for (final file in files) {
        final uri = p.normalize(p.absolute(file.path));
        if (!knownUris.add(uri)) {
          skipped++;
          continue;
        }

        final stat = await file.stat();
        final fileName = p.basename(file.path);
        final extension = p.extension(file.path).toLowerCase();
        final seriesTitle = p.basename(p.dirname(file.path));
        final seriesKey = seriesTitle.toLowerCase();

        // PDFs are indexed by the PDFium-backed engine without rasterizing every
        // page. Image archives retain their existing first-page cover extraction.
        int pageCount = 0;
        String? coverPath;
        try {
          if (extension == '.pdf') {
            final document = await PdfDocument.openFile(uri);
            try {
              pageCount = document.pages.length;
            } finally {
              await document.dispose();
            }
          } else {
            final bytes = await file.readAsBytes();
            final archive = ZipDecoder().decodeBytes(bytes, verify: true);
            final pages =
                archive.files
                    .where(
                      (entry) =>
                          entry.isFile &&
                          _pageExtensions.contains(
                            p.extension(entry.name).toLowerCase(),
                          ),
                    )
                    .toList()
                  ..sort((a, b) => naturalCompare(a.name, b.name));
            if (pages.isEmpty) {
              skipped++;
              continue;
            }
            final coverBytes = pages.first.readBytes();
            if (coverBytes == null || coverBytes.isEmpty) {
              skipped++;
              continue;
            }
            pageCount = pages.length;
            final coverExtension = p.extension(pages.first.name).toLowerCase();
            coverPath = p.join(
              coverDirectory.path,
              '${_stableHash(uri)}$coverExtension',
            );
            await File(coverPath).writeAsBytes(coverBytes, flush: true);
          }
        } catch (_) {
          skipped++;
          continue;
        }
        if (pageCount < 1) {
          skipped++;
          continue;
        }

        final chapterTitle = p.basenameWithoutExtension(fileName);
        final chapterNumber = _parseChapterNumber(chapterTitle);

        var seriesId = seriesIds[seriesKey];
        if (seriesId == null) {
          seriesId = await db
              .into(db.series)
              .insert(
                SeriesCompanion.insert(
                  title: seriesTitle,
                  createdAt: DateTime.now().millisecondsSinceEpoch,
                ),
              );
          seriesIds[seriesKey] = seriesId;
        }

        await db
            .into(db.comics)
            .insert(
              ComicsCompanion.insert(
                seriesId: Value(seriesId),
                rootId: Value(rootId),
                uri: uri,
                fileName: fileName,
                format: switch (extension) {
                  '.cbz' => ComicFormat.cbz,
                  '.pdf' => ComicFormat.pdf,
                  _ => ComicFormat.zip,
                },
                sizeBytes: stat.size,
                chapterNumber: Value(chapterNumber),
                chapterTitle: Value(chapterTitle),
                pageCount: Value(pageCount),
                coverCachePath: Value(coverPath),
                addedAt: DateTime.now().millisecondsSinceEpoch,
              ),
            );
        imported++;
      }

      return ComicImportResult(imported: imported, skipped: skipped);
    });
  }

  static double? _parseChapterNumber(String title) {
    final match = RegExp(
      _chapterPattern,
      caseSensitive: false,
    ).firstMatch(title);
    return match == null ? null : double.tryParse(match.group(1)!);
  }

  /// Stable FNV-1a 64-bit hash for a compact cache filename.
  static String _stableHash(String value) {
    var hash = 0xcbf29ce484222325;
    for (final byte in utf8.encode(value)) {
      hash ^= byte;
      hash = (hash * 0x100000001b3) & 0xffffffffffffffff;
    }
    return hash.toRadixString(16).padLeft(16, '0');
  }
}
