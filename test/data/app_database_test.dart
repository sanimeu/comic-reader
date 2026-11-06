import 'dart:io';

import 'package:comic_reader/data/db/app_database.dart';
import 'package:comic_reader/data/db/library_mapper.dart';
import 'package:comic_reader/domain/comic_source.dart';
import 'package:comic_reader/domain/models.dart';
import 'package:drift/drift.dart' show Value, Variable;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

const int _t = 1700000000000; // an arbitrary epoch-millisecond timestamp

AppDatabase _memoryDb() => AppDatabase(NativeDatabase.memory());

Future<int> _series(
  AppDatabase db, {
  String title = 'Series',
  String? author,
  ComicType type = ComicType.manga,
  bool completed = false,
  bool favourite = false,
}) => db
    .into(db.series)
    .insert(
      SeriesCompanion.insert(
        title: title,
        createdAt: _t,
        author: Value(author),
        type: Value(type),
        isCompleted: Value(completed),
        isFavourite: Value(favourite),
      ),
    );

Future<int> _comic(
  AppDatabase db, {
  required String uri,
  int? seriesId,
  int? rootId,
  ComicFormat format = ComicFormat.cbz,
  double? number,
}) => db
    .into(db.comics)
    .insert(
      ComicsCompanion.insert(
        uri: uri,
        fileName: uri.split('/').last,
        format: format,
        sizeBytes: 123,
        addedAt: _t,
        seriesId: Value(seriesId),
        rootId: Value(rootId),
        chapterNumber: Value(number),
      ),
    );

Future<void> _progress(
  AppDatabase db,
  int comicId, {
  double percent = 0,
  bool completed = false,
  int page = 0,
  int read = _t,
}) => db
    .into(db.readingProgress)
    .insert(
      ReadingProgressCompanion.insert(
        comicId: Value(comicId),
        lastReadAt: read,
        updatedAt: read,
        percent: Value(percent),
        completed: Value(completed),
        pageIndex: Value(page),
      ),
    );

/// Matches an error whose text mentions [text] (e.g. 'FOREIGN KEY', 'UNIQUE', 'CHECK').
Matcher _failsWith(String text) => throwsA(
  predicate<Object>(
    (e) => e.toString().toUpperCase().contains(text.toUpperCase()),
    'an error mentioning "$text"',
  ),
);

Future<List<Map<String, Object?>>> _rows(
  AppDatabase db,
  String sql, [
  List<Variable> vars = const [],
]) async => (await db.customSelect(sql, variables: vars).get())
    .map((r) => r.data)
    .toList();

Future<int> _count(AppDatabase db, String table) async =>
    (await db.customSelect('SELECT COUNT(*) AS n FROM $table').getSingle())
        .read<int>('n');

void main() {
  late AppDatabase db;
  setUp(() => db = _memoryDb());
  tearDown(() => db.close());

  group('creation', () {
    test('creates all nine tables and the six schema indexes', () async {
      final tables =
          (await _rows(
                db,
                "SELECT name FROM sqlite_master WHERE type = 'table'",
              ))
              .map((r) => r['name'] as String)
              .where((n) => !n.startsWith('sqlite_'))
              .toSet();
      expect(tables, {
        'library_roots',
        'series',
        'comics',
        'reading_progress',
        'bookmarks',
        'collections',
        'collection_series',
        'settings',
        'reader_overrides',
      });

      final indexes = (await _rows(
        db,
        "SELECT name FROM sqlite_master WHERE type = 'index' AND name LIKE 'idx_%'",
      )).map((r) => r['name'] as String).toSet();
      expect(indexes, {
        'idx_series_title',
        'idx_comics_series',
        'idx_comics_hash',
        'idx_comics_added',
        'idx_progress_last_read',
        'idx_bookmarks_comic',
      });
    });

    test('schema version is stored as user_version 1', () async {
      final r = await db.customSelect('PRAGMA user_version').getSingle();
      expect(r.read<int>('user_version'), 1);
    });

    test('SQLite foreign keys are enabled on the connection', () async {
      final r = await db.customSelect('PRAGMA foreign_keys').getSingle();
      expect(r.read<int>('foreign_keys'), 1);
    });
  });

  group('insert and retrieve', () {
    test(
      'defaults match schema.sql when only required columns are given',
      () async {
        final sid = await db
            .into(db.series)
            .insert(SeriesCompanion.insert(title: 'T', createdAt: _t));
        final s = await (db.select(
          db.series,
        )..where((t) => t.id.equals(sid))).getSingle();
        expect(s.title, 'T');
        expect(s.author, isNull);
        expect(s.type, ComicType.unknown);
        expect(s.isFavourite, isFalse);
        expect(s.isCompleted, isFalse);
        expect(s.manualOverride, isFalse);
        expect(s.coverComicId, isNull);
        expect(s.createdAt, _t);

        final rid = await db
            .into(db.libraryRoots)
            .insert(
              LibraryRootsCompanion.insert(
                uri: r'C:\Comics',
                displayName: 'Comics',
              ),
            );
        final root = await (db.select(
          db.libraryRoots,
        )..where((t) => t.id.equals(rid))).getSingle();
        expect(root.autoScan, isTrue);
        expect(root.lastScanAt, isNull);

        final cid = await _comic(db, uri: 'a/1.cbz');
        final c = await (db.select(
          db.comics,
        )..where((t) => t.id.equals(cid))).getSingle();
        expect(c.missing, isFalse);
        expect(c.seriesId, isNull);
        expect(c.pageCount, isNull);

        await _progress(db, cid);
        final p = await (db.select(
          db.readingProgress,
        )..where((t) => t.comicId.equals(cid))).getSingle();
        expect(p.pageIndex, 0);
        expect(p.scrollOffset, 0.0);
        expect(p.percent, 0.0);
        expect(p.completed, isFalse);
      },
    );

    test('series, comic and progress round-trip with all fields', () async {
      final rid = await db
          .into(db.libraryRoots)
          .insert(
            LibraryRootsCompanion.insert(
              uri: '/storage/comics',
              displayName: 'Comics',
              autoScan: const Value(false),
            ),
          );
      final sid = await _series(
        db,
        title: 'Night Shift',
        author: 'Kim',
        type: ComicType.manhwa,
        favourite: true,
        completed: true,
      );
      final cid = await db
          .into(db.comics)
          .insert(
            ComicsCompanion.insert(
              uri: '/storage/comics/night/ch12.cbz',
              fileName: 'ch12.cbz',
              format: ComicFormat.cbz,
              sizeBytes: 9000000000, // > 32-bit
              addedAt: _t,
              seriesId: Value(sid),
              rootId: Value(rid),
              contentHash: const Value('abc123'),
              chapterNumber: const Value(12.5),
              chapterTitle: const Value('Half chapter'),
              pageCount: const Value(30),
              coverCachePath: const Value('covers/12.jpg'),
              missing: const Value(true),
            ),
          );
      await db
          .into(db.readingProgress)
          .insert(
            ReadingProgressCompanion.insert(
              comicId: Value(cid),
              pageIndex: const Value(7),
              scrollOffset: const Value(123.5),
              percent: const Value(0.25),
              completed: const Value(false),
              lastReadAt: _t + 1,
              updatedAt: _t + 2,
            ),
          );

      final root = await (db.select(
        db.libraryRoots,
      )..where((t) => t.id.equals(rid))).getSingle();
      expect(root.autoScan, isFalse);

      final s = await (db.select(
        db.series,
      )..where((t) => t.id.equals(sid))).getSingle();
      expect(
        [s.title, s.author, s.type, s.isFavourite, s.isCompleted],
        ['Night Shift', 'Kim', ComicType.manhwa, true, true],
      );

      final c = await (db.select(
        db.comics,
      )..where((t) => t.id.equals(cid))).getSingle();
      expect(c.seriesId, sid);
      expect(c.rootId, rid);
      expect(c.sizeBytes, 9000000000);
      expect(c.contentHash, 'abc123');
      expect(c.chapterNumber, 12.5);
      expect(c.chapterTitle, 'Half chapter');
      expect(c.pageCount, 30);
      expect(c.coverCachePath, 'covers/12.jpg');
      expect(c.missing, isTrue);

      final p = await (db.select(
        db.readingProgress,
      )..where((t) => t.comicId.equals(cid))).getSingle();
      expect(
        [p.pageIndex, p.scrollOffset, p.percent, p.lastReadAt, p.updatedAt],
        [7, 123.5, 0.25, _t + 1, _t + 2],
      );
    });

    test(
      'formats: folder/image are stored as schema values and read back as the domain enums',
      () async {
        const allowed = {'cbz', 'zip', 'cbr', 'cb7', 'pdf', 'folder', 'image'};
        final ids = <ComicFormat, int>{};
        for (final f in ComicFormat.values) {
          ids[f] = await _comic(db, uri: 'u/${f.name}', format: f);
        }
        // Read back through Drift: domain enums.
        for (final entry in ids.entries) {
          final c = await (db.select(
            db.comics,
          )..where((t) => t.id.equals(entry.value))).getSingle();
          expect(c.format, entry.key);
        }
        // Read the RAW stored text: exactly the schema values, never the enum names.
        final raw = (await _rows(
          db,
          'SELECT format FROM comics',
        )).map((r) => r['format'] as String).toSet();
        expect(raw, allowed);
        final folderRaw = await _rows(
          db,
          'SELECT format FROM comics WHERE id = ?',
          [Variable.withInt(ids[ComicFormat.imageFolder]!)],
        );
        expect(folderRaw.single['format'], 'folder');
        final imageRaw = await _rows(
          db,
          'SELECT format FROM comics WHERE id = ?',
          [Variable.withInt(ids[ComicFormat.singleImage]!)],
        );
        expect(imageRaw.single['format'], 'image');
      },
    );

    test(
      'bookmarks, collections, collection membership, settings and reader overrides round-trip',
      () async {
        final sid = await _series(db);
        final cid = await _comic(db, uri: 'a/1.cbz', seriesId: sid);

        final bid = await db
            .into(db.bookmarks)
            .insert(
              BookmarksCompanion.insert(
                comicId: cid,
                pageIndex: 5,
                createdAt: _t,
                note: const Value('great panel'),
              ),
            );
        final b = await (db.select(
          db.bookmarks,
        )..where((t) => t.id.equals(bid))).getSingle();
        expect(
          [b.comicId, b.pageIndex, b.scrollOffset, b.note],
          [cid, 5, 0.0, 'great panel'],
        );

        final colId = await db
            .into(db.collections)
            .insert(
              CollectionsCompanion.insert(name: 'Weekend', createdAt: _t),
            );
        await db
            .into(db.collectionSeries)
            .insert(
              CollectionSeriesCompanion.insert(
                collectionId: colId,
                seriesId: sid,
              ),
            );
        final members = await db.select(db.collectionSeries).get();
        expect(members.single.collectionId, colId);
        expect(members.single.seriesId, sid);
        final col = await (db.select(
          db.collections,
        )..where((t) => t.id.equals(colId))).getSingle();
        expect(col.sortOrder, 0);

        await db
            .into(db.settings)
            .insert(
              SettingsCompanion.insert(key: 'glass_quality', value: 'low'),
            );
        final setting = await db.select(db.settings).getSingle();
        expect([setting.key, setting.value], ['glass_quality', 'low']);

        await db
            .into(db.readerOverrides)
            .insert(
              ReaderOverridesCompanion.insert(
                seriesId: Value(sid),
                direction: const Value('rtl'),
                brightness: const Value(0.2),
                invert: const Value(true),
              ),
            );
        final o = await db.select(db.readerOverrides).getSingle();
        expect(
          [
            o.direction,
            o.zoomMode,
            o.brightness,
            o.contrast,
            o.saturation,
            o.invert,
          ],
          ['rtl', null, 0.2, null, null, true],
        );
      },
    );
  });

  group('constraints', () {
    test('comics.uri is UNIQUE', () async {
      await _comic(db, uri: 'same/path.cbz');
      await expectLater(_comic(db, uri: 'same/path.cbz'), _failsWith('UNIQUE'));
    });

    test('library_roots.uri is UNIQUE', () async {
      await db
          .into(db.libraryRoots)
          .insert(LibraryRootsCompanion.insert(uri: 'r', displayName: 'a'));
      await expectLater(
        db
            .into(db.libraryRoots)
            .insert(LibraryRootsCompanion.insert(uri: 'r', displayName: 'b')),
        _failsWith('UNIQUE'),
      );
    });

    test(
      'CHECK rejects domain enum NAMES and unknown values for comics.format and series.type',
      () async {
        await expectLater(
          db.customStatement(
            "INSERT INTO comics (uri, file_name, format, size_bytes, added_at) VALUES ('x', 'x', 'imageFolder', 1, 1)",
          ),
          _failsWith('CHECK'),
        );
        await expectLater(
          db.customStatement(
            "INSERT INTO comics (uri, file_name, format, size_bytes, added_at) VALUES ('y', 'y', 'rar', 1, 1)",
          ),
          _failsWith('CHECK'),
        );
        await expectLater(
          db.customStatement(
            "INSERT INTO series (title, type, created_at) VALUES ('s', 'comic', 1)",
          ),
          _failsWith('CHECK'),
        );
      },
    );

    test('foreign keys reject rows that point at nothing', () async {
      await expectLater(
        _comic(db, uri: 'a', seriesId: 999),
        _failsWith('FOREIGN KEY'),
      );
      await expectLater(
        _comic(db, uri: 'b', rootId: 999),
        _failsWith('FOREIGN KEY'),
      );
      await expectLater(_progress(db, 999), _failsWith('FOREIGN KEY'));
      await expectLater(
        db
            .into(db.bookmarks)
            .insert(
              BookmarksCompanion.insert(
                comicId: 999,
                pageIndex: 0,
                createdAt: _t,
              ),
            ),
        _failsWith('FOREIGN KEY'),
      );
      await expectLater(
        db
            .into(db.collectionSeries)
            .insert(
              CollectionSeriesCompanion.insert(collectionId: 1, seriesId: 1),
            ),
        _failsWith('FOREIGN KEY'),
      );
      await expectLater(
        db
            .into(db.readerOverrides)
            .insert(
              ReaderOverridesCompanion.insert(seriesId: const Value(999)),
            ),
        _failsWith('FOREIGN KEY'),
      );
    });

    test(
      'deleting a series sets comics.series_id to NULL; the comic and its progress survive',
      () async {
        final sid = await _series(db);
        final cid = await _comic(db, uri: 'a/1.cbz', seriesId: sid);
        await _progress(db, cid, percent: 0.5, page: 3);

        await (db.delete(db.series)..where((t) => t.id.equals(sid))).go();

        final c = await (db.select(
          db.comics,
        )..where((t) => t.id.equals(cid))).getSingle();
        expect(c.seriesId, isNull);
        expect(await _count(db, 'reading_progress'), 1);
      },
    );

    test(
      'deleting a library root sets comics.root_id to NULL and keeps the comic',
      () async {
        final rid = await db
            .into(db.libraryRoots)
            .insert(LibraryRootsCompanion.insert(uri: 'r', displayName: 'r'));
        final cid = await _comic(db, uri: 'r/1.cbz', rootId: rid);
        await (db.delete(db.libraryRoots)..where((t) => t.id.equals(rid))).go();
        final c = await (db.select(
          db.comics,
        )..where((t) => t.id.equals(cid))).getSingle();
        expect(c.rootId, isNull);
      },
    );

    test(
      'deleting a comic cascades to its progress and bookmarks only',
      () async {
        final sid = await _series(db);
        final keep = await _comic(db, uri: 'keep.cbz', seriesId: sid);
        final gone = await _comic(db, uri: 'gone.cbz', seriesId: sid);
        for (final id in [keep, gone]) {
          await _progress(db, id);
          await db
              .into(db.bookmarks)
              .insert(
                BookmarksCompanion.insert(
                  comicId: id,
                  pageIndex: 1,
                  createdAt: _t,
                ),
              );
        }
        await (db.delete(db.comics)..where((t) => t.id.equals(gone))).go();

        expect(await _count(db, 'reading_progress'), 1);
        expect(await _count(db, 'bookmarks'), 1);
        expect(await _count(db, 'comics'), 1);
        expect(await _count(db, 'series'), 1);
      },
    );

    test(
      'deleting a series cascades to collection membership and reader overrides, not the collection',
      () async {
        final sid = await _series(db);
        final colId = await db
            .into(db.collections)
            .insert(CollectionsCompanion.insert(name: 'C', createdAt: _t));
        await db
            .into(db.collectionSeries)
            .insert(
              CollectionSeriesCompanion.insert(
                collectionId: colId,
                seriesId: sid,
              ),
            );
        await db
            .into(db.readerOverrides)
            .insert(ReaderOverridesCompanion.insert(seriesId: Value(sid)));

        await (db.delete(db.series)..where((t) => t.id.equals(sid))).go();

        expect(await _count(db, 'collection_series'), 0);
        expect(await _count(db, 'reader_overrides'), 0);
        expect(await _count(db, 'collections'), 1);
      },
    );

    test(
      'deleting a collection removes membership rows but never the series',
      () async {
        final sid = await _series(db);
        final colId = await db
            .into(db.collections)
            .insert(CollectionsCompanion.insert(name: 'C', createdAt: _t));
        await db
            .into(db.collectionSeries)
            .insert(
              CollectionSeriesCompanion.insert(
                collectionId: colId,
                seriesId: sid,
              ),
            );
        await (db.delete(
          db.collections,
        )..where((t) => t.id.equals(colId))).go();
        expect(await _count(db, 'collection_series'), 0);
        expect(await _count(db, 'series'), 1);
      },
    );
  });

  group('file safety', () {
    test(
      'deleting every database row leaves the real comic files and folders on disk',
      () async {
        final dir = await Directory.systemTemp.createTemp(
          'comic_reader_files_test',
        );
        addTearDown(() async {
          try {
            await dir.delete(recursive: true);
          } catch (_) {}
        });
        final bytes = [1, 2, 3, 4, 5, 6, 7, 8];
        final file = File('${dir.path}${Platform.pathSeparator}vol1.cbz');
        await file.writeAsBytes(bytes);
        final pageDir = await Directory(
          '${dir.path}${Platform.pathSeparator}folder_comic',
        ).create();
        final page = File('${pageDir.path}${Platform.pathSeparator}001.jpg');
        await page.writeAsBytes([9, 9, 9]);

        final rid = await db
            .into(db.libraryRoots)
            .insert(
              LibraryRootsCompanion.insert(uri: dir.path, displayName: 'tmp'),
            );
        final sid = await _series(db);
        final c1 = await _comic(db, uri: file.path, seriesId: sid, rootId: rid);
        final c2 = await _comic(
          db,
          uri: pageDir.path,
          seriesId: sid,
          rootId: rid,
          format: ComicFormat.imageFolder,
        );
        await _progress(db, c1);
        await db
            .into(db.bookmarks)
            .insert(
              BookmarksCompanion.insert(
                comicId: c2,
                pageIndex: 0,
                createdAt: _t,
              ),
            );

        // Targeted deletes first...
        await (db.delete(db.comics)..where((t) => t.id.equals(c1))).go();
        await (db.delete(db.series)..where((t) => t.id.equals(sid))).go();
        await (db.delete(db.libraryRoots)..where((t) => t.id.equals(rid))).go();
        // ...then wipe every table.
        for (final table in db.allTables) {
          await db.delete(table).go();
        }
        for (final name in [
          'library_roots',
          'series',
          'comics',
          'reading_progress',
          'bookmarks',
        ]) {
          expect(await _count(db, name), 0, reason: name);
        }

        expect(await file.exists(), isTrue);
        expect(await file.readAsBytes(), bytes);
        expect(await pageDir.exists(), isTrue);
        expect(await page.exists(), isTrue);
      },
    );

    test(
      'the database layer contains no file-system or file-deletion code (connection.dart excepted)',
      () {
        final forbidden = RegExp(
          r"dart:io|\bFile\(|\bDirectory\(|deleteSync|\.delete\(recursive",
        );
        final sources = Directory('lib/data/db')
            .listSync()
            .whereType<File>()
            .where(
              (f) =>
                  f.path.endsWith('.dart') &&
                  !f.path.endsWith('.g.dart') &&
                  !f.path.endsWith('connection.dart'),
            )
            .toList();
        expect(sources, isNotEmpty);
        for (final f in sources) {
          final text = f.readAsStringSync();
          expect(
            forbidden.hasMatch(text),
            isFalse,
            reason: '${f.path} must not touch the file system',
          );
        }
      },
    );
  });

  group('persistence', () {
    test(
      'a file-backed database keeps its rows after close and reopen, with foreign keys still on',
      () async {
        final dir = await Directory.systemTemp.createTemp(
          'comic_reader_db_test',
        );
        addTearDown(() async {
          try {
            await dir.delete(recursive: true);
          } catch (_) {}
        });
        final dbFile = File(
          '${dir.path}${Platform.pathSeparator}comic_reader.sqlite',
        );

        final first = AppDatabase(NativeDatabase(dbFile));
        final sid = await _series(first, title: 'Persisted', author: 'Kim');
        await _comic(
          first,
          uri: 'a/1.cbz',
          seriesId: sid,
          format: ComicFormat.imageFolder,
        );
        await first.close();

        final second = AppDatabase(NativeDatabase(dbFile));
        addTearDown(second.close);
        final s = await second.select(second.series).getSingle();
        expect(s.title, 'Persisted');
        final c = await second.select(second.comics).getSingle();
        expect(c.format, ComicFormat.imageFolder);
        final fk = await second.customSelect('PRAGMA foreign_keys').getSingle();
        expect(fk.read<int>('foreign_keys'), 1);
        await expectLater(
          _comic(second, uri: 'b', seriesId: 999),
          _failsWith('FOREIGN KEY'),
        );
      },
    );
  });

  group('loadLibraryItems (database rows -> existing LibraryItem model)', () {
    test(
      'derives chapter counts, progress, status, current chapter and last read from the rows',
      () async {
        final alpha = await _series(
          db,
          title: 'Alpha',
          author: 'Kim',
          favourite: true,
          type: ComicType.manhwa,
        );
        final a1 = await _comic(
          db,
          uri: 'alpha/1.cbz',
          seriesId: alpha,
          number: 1,
        );
        final a2 = await _comic(
          db,
          uri: 'alpha/2.cbz',
          seriesId: alpha,
          number: 2,
        );
        await _comic(db, uri: 'alpha/3.cbz', seriesId: alpha, number: 3);
        await _progress(db, a1, completed: true, read: 1000);
        await _progress(db, a2, percent: 0.5, page: 4, read: 2000);

        final empty = await _series(db, title: 'Empty');
        final done = await _series(db, title: 'Done', completed: true);
        await _comic(db, uri: 'done/1.cbz', seriesId: done, number: 1);
        await _comic(db, uri: 'done/2.cbz', seriesId: done, number: 2);
        final anon = await _series(db, title: 'Anon'); // null author
        await _comic(
          db,
          uri: 'standalone.cbz',
        ); // no series: not part of the series-level view

        final items = await db.loadLibraryItems();
        expect(items.length, 4);
        LibraryItem by(String title) =>
            items.firstWhere((i) => i.title == title);

        final a = by('Alpha');
        expect(a.id, alpha.toString());
        expect(a.author, 'Kim');
        expect(a.type, ComicType.manhwa);
        expect(a.isFavourite, isTrue);
        expect(a.totalChapters, 3); // derived from comics, not stored
        expect(a.progress, closeTo(0.5, 1e-9)); // (1 + 0.5 + 0) / 3
        expect(a.status, ReadStatus.reading);
        expect(a.currentChapter, 2);
        expect(a.chaptersRead, 1);
        expect(a.lastReadAt, DateTime.fromMillisecondsSinceEpoch(2000));
        expect(a.addedAt, DateTime.fromMillisecondsSinceEpoch(_t));
        expect(a.isSample, isFalse);

        final e = by('Empty');
        expect(e.id, empty.toString());
        expect(e.totalChapters, 0);
        expect(e.status, ReadStatus.unread);
        expect(e.lastReadAt, isNull);

        final d = by('Done');
        expect(d.totalChapters, 2);
        expect(d.status, ReadStatus.completed); // is_completed flag overrides
        expect(d.chaptersRead, 2);

        final n = by('Anon');
        expect(n.id, anon.toString());
        expect(n.author, kUnknownAuthor);
        expect(n.status, ReadStatus.unread);
      },
    );

    test(
      'chapter counts and progress follow the comics: removing a comic changes both',
      () async {
        final sid = await _series(db, title: 'S');
        final c1 = await _comic(db, uri: 's/1.cbz', seriesId: sid, number: 1);
        final c2 = await _comic(db, uri: 's/2.cbz', seriesId: sid, number: 2);
        await _progress(db, c1, completed: true);

        var item = (await db.loadLibraryItems()).single;
        expect(item.totalChapters, 2);
        expect(item.progress, closeTo(0.5, 1e-9));

        await (db.delete(db.comics)..where((t) => t.id.equals(c2))).go();
        item = (await db.loadLibraryItems()).single;
        expect(item.totalChapters, 1);
        expect(item.progress, 1.0);
        expect(item.status, ReadStatus.completed);
      },
    );

    test('an empty database gives an empty library', () async {
      expect(await db.loadLibraryItems(), isEmpty);
    });
  });
}
