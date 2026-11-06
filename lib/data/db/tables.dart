import 'package:drift/drift.dart';
import 'converters.dart';

// Drift mirror of lib/core/db/schema.sql (that file stays the reference).
// Conventions:
//  * Column order, nullability, defaults, UNIQUE, CHECK and ON DELETE rules follow schema.sql.
//  * All *_at columns are plain INTEGER = epoch MILLISECONDS (schema.sql leaves the unit open).
//    Do not use Drift's dateTime(): it stores seconds by default.
//  * reading_progress.percent is a FRACTION 0.0 to 1.0 (same as LibraryItem.progress).
//  * Booleans are INTEGER 0/1 via BoolIntConverter (exposed as bool in Dart).
//  * Indexes are NOT declared here; app_database.dart creates the exact SQL from schema.sql
//    (one of them uses COLLATE NOCASE, which Drift's index annotation cannot express).
//  * Deleting rows never touches files on disk. Nothing in this layer deletes files.

@DataClassName('LibraryRootRow')
class LibraryRoots extends Table {
  @override
  String get tableName => 'library_roots';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get uri =>
      text().unique()(); // Windows: path; Android: SAF tree URI
  TextColumn get displayName => text()();
  IntColumn get autoScan =>
      integer().withDefault(const Constant(1)).map(const BoolIntConverter())();
  IntColumn get lastScanAt => integer().nullable()();
}

@DataClassName('SeriesRow')
class Series extends Table {
  @override
  String get tableName => 'series';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get author => text().nullable()();
  TextColumn get type => text()
      .withDefault(const Constant('unknown'))
      .map(const ComicTypeConverter())();
  IntColumn get isFavourite =>
      integer().withDefault(const Constant(0)).map(const BoolIntConverter())();

  /// Manual "mark as completed" flag. Series STATUS is derived from comic progress
  /// (see library_mapper.dart); a set flag only forces 100%. Never written automatically.
  IntColumn get isCompleted =>
      integer().withDefault(const Constant(0)).map(const BoolIntConverter())();
  IntColumn get coverComicId =>
      integer().nullable()(); // intentionally no FK (circular with comics)
  IntColumn get manualOverride =>
      integer().withDefault(const Constant(0)).map(const BoolIntConverter())();
  IntColumn get createdAt => integer()();

  @override
  List<String> get customConstraints => [
    "CHECK (type IN ('manga','manhwa','manhua','unknown'))",
  ];
}

@DataClassName('ComicRow')
class Comics extends Table {
  @override
  String get tableName => 'comics';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get seriesId => integer().nullable().references(
    Series,
    #id,
    onDelete: KeyAction.setNull,
  )();
  IntColumn get rootId => integer().nullable().references(
    LibraryRoots,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get uri => text().unique()();
  TextColumn get fileName => text()();
  TextColumn get format => text().map(const ComicFormatConverter())();
  IntColumn get sizeBytes => integer()();
  TextColumn get contentHash =>
      text().nullable()(); // partial hash: nominates duplicate candidates only
  RealColumn get chapterNumber => real().nullable()();
  TextColumn get chapterTitle => text().nullable()();
  IntColumn get pageCount => integer().nullable()();
  TextColumn get coverCachePath => text().nullable()();
  IntColumn get addedAt => integer()();
  IntColumn get missing =>
      integer().withDefault(const Constant(0)).map(const BoolIntConverter())();

  @override
  List<String> get customConstraints => [
    "CHECK (format IN ('cbz','zip','cbr','cb7','pdf','folder','image'))",
  ];
}

@DataClassName('ReadingProgressRow')
class ReadingProgress extends Table {
  @override
  String get tableName => 'reading_progress';

  IntColumn get comicId =>
      integer().references(Comics, #id, onDelete: KeyAction.cascade)();
  IntColumn get pageIndex => integer().withDefault(const Constant(0))();
  RealColumn get scrollOffset => real().withDefault(const Constant(0.0))();
  RealColumn get percent => real().withDefault(const Constant(0.0))();
  IntColumn get completed =>
      integer().withDefault(const Constant(0)).map(const BoolIntConverter())();
  IntColumn get lastReadAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {comicId};
}

@DataClassName('BookmarkRow')
class Bookmarks extends Table {
  @override
  String get tableName => 'bookmarks';

  IntColumn get id => integer().autoIncrement()();
  IntColumn get comicId =>
      integer().references(Comics, #id, onDelete: KeyAction.cascade)();
  IntColumn get pageIndex => integer()();
  RealColumn get scrollOffset => real().withDefault(const Constant(0.0))();
  TextColumn get note => text().nullable()();
  IntColumn get createdAt => integer()();
}

@DataClassName('CollectionRow')
class Collections extends Table {
  @override
  String get tableName => 'collections';

  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();
}

@DataClassName('CollectionSeriesRow')
class CollectionSeries extends Table {
  @override
  String get tableName => 'collection_series';

  IntColumn get collectionId =>
      integer().references(Collections, #id, onDelete: KeyAction.cascade)();
  IntColumn get seriesId =>
      integer().references(Series, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {collectionId, seriesId};
}

@DataClassName('SettingRow')
class Settings extends Table {
  @override
  String get tableName => 'settings';

  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}

@DataClassName('ReaderOverrideRow')
class ReaderOverrides extends Table {
  @override
  String get tableName => 'reader_overrides';

  IntColumn get seriesId =>
      integer().references(Series, #id, onDelete: KeyAction.cascade)();
  TextColumn get direction => text().nullable()();
  TextColumn get zoomMode => text().nullable()();
  RealColumn get brightness => real().nullable()();
  RealColumn get contrast => real().nullable()();
  RealColumn get saturation => real().nullable()();
  IntColumn get invert => integer().map(const BoolIntConverter()).nullable()();

  @override
  Set<Column> get primaryKey => {seriesId};
}
