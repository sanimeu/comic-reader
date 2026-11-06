import 'package:drift/drift.dart';
import '../../domain/comic_source.dart';
import '../../domain/models.dart';
import 'converters.dart';
import 'library_mapper.dart';
import 'tables.dart';

part 'app_database.g.dart'; // generated: dart run build_runner build --delete-conflicting-outputs

/// Exact copies of the CREATE INDEX statements in lib/core/db/schema.sql.
/// test/data/schema_conformance_test.dart checks they still match that file.
const List<String> kSchemaIndexStatements = [
  'CREATE INDEX idx_series_title ON series(title COLLATE NOCASE)',
  'CREATE INDEX idx_comics_series ON comics(series_id, chapter_number)',
  'CREATE INDEX idx_comics_hash ON comics(content_hash)',
  'CREATE INDEX idx_comics_added ON comics(added_at)',
  'CREATE INDEX idx_progress_last_read ON reading_progress(last_read_at)',
  'CREATE INDEX idx_bookmarks_comic ON bookmarks(comic_id)',
];

/// Local-first library database (SQLite via Drift).
///
/// The executor is injected: production uses `openAppConnection()` (connection.dart);
/// tests pass `NativeDatabase.memory()` or a temp file.
///
/// File safety: this class only reads and writes ROWS. It never opens, moves or deletes
/// comic files; removing a row from the library leaves the file on disk untouched.
@DriftDatabase(
  tables: [
    LibraryRoots,
    Series,
    Comics,
    ReadingProgress,
    Bookmarks,
    Collections,
    CollectionSeries,
    Settings,
    ReaderOverrides,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  /// Bump when the schema changes and add the step to [migration].onUpgrade
  /// (see docs/DATABASE.md, "Migrations").
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      for (final sql in kSchemaIndexStatements) {
        await customStatement(sql);
      }
    },
    // SQLite ignores FOREIGN KEY clauses unless this is switched on for EVERY connection.
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );

  /// Loads the database-backed series model consumed by the dashboard providers.
  /// Comics without a series are not part of the series-level library view.
  Future<List<LibraryItem>> loadLibraryItems() async {
    final seriesRows = await select(series).get();
    final comicRows = await select(comics).get();
    final progressRows = await select(readingProgress).get();

    final progressByComic = {for (final p in progressRows) p.comicId: p};
    final chaptersBySeries = <int, List<ChapterSnapshot>>{};
    for (final c in comicRows) {
      final sid = c.seriesId;
      if (sid == null) continue;
      final p = progressByComic[c.id];
      chaptersBySeries
          .putIfAbsent(sid, () => <ChapterSnapshot>[])
          .add(
            ChapterSnapshot(
              id: c.id,
              fileName: c.fileName,
              chapterNumber: c.chapterNumber,
              coverCachePath: c.coverCachePath,
              progress: p == null
                  ? null
                  : ChapterProgressSnapshot(
                      percent: p.percent,
                      completed: p.completed,
                      pageIndex: p.pageIndex,
                      lastReadAtMs: p.lastReadAt,
                    ),
            ),
          );
    }

    return [
      for (final s in seriesRows)
        buildLibraryItem(
          seriesId: s.id,
          title: s.title,
          author: s.author,
          type: s.type,
          isFavourite: s.isFavourite,
          isCompleted: s.isCompleted,
          createdAtMs: s.createdAt,
          chapters: chaptersBySeries[s.id] ?? const <ChapterSnapshot>[],
        ),
    ];
  }
}
