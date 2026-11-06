import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';
import 'connection.dart';

/// Lazily opens the database the first time something reads this provider.
/// Nothing in the dashboard reads it yet, so no database file is created at app start
/// and the existing widget tests never touch SQLite.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase(openAppConnection());
  ref.onDispose(db.close);
  return db;
});
