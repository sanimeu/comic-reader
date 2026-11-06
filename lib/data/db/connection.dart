import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

/// Database file name (drift_flutter appends `.sqlite`).
const String kDatabaseName = 'comic_reader';

/// Opens the production database on Windows and Android.
///
/// The file lives in the platform's application SUPPORT directory (app-private data,
/// not the user-visible Documents folder; drift_flutter defaults to Documents):
///   Windows: the application support directory\comic_reader.sqlite (via path_provider)
///   Android: `app internal files dir`/comic_reader.sqlite
/// drift_flutter opens it on a background isolate and handles Android's temp-directory quirk.
/// SQLite itself is bundled by package:sqlite3 3.x (build hooks); do NOT add sqlite3_flutter_libs.
QueryExecutor openAppConnection() => driftDatabase(
  name: kDatabaseName,
  native: const DriftNativeOptions(
    databaseDirectory: getApplicationSupportDirectory,
  ),
);
