import 'dart:io';

import 'package:comic_reader/data/db/app_database.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as s3;

/// Proves the Drift database matches lib/core/db/schema.sql by building a REFERENCE database
/// from that very file and comparing structure (tables, columns, nullability, defaults,
/// primary keys, foreign keys with ON DELETE actions, UNIQUE constraints, explicit indexes).
///
/// Known, intentional, invisible differences that are NOT compared:
///  * Drift writes `INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT` for id columns; schema.sql says
///    `INTEGER PRIMARY KEY`. Same rowid alias; AUTOINCREMENT only guarantees ids are never reused.
///  * NOT NULL on primary-key columns (PRAGMA reports it differently for the two spellings).
///  * CHECK constraints are verified by behaviour in app_database_test.dart.

typedef _Query = Future<List<Map<String, Object?>>> Function(String sql);

Object? _normDefault(Object? v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return double.tryParse(s) ??
      s; // 0 and 0.0 compare equal; 'unknown' stays a string
}

String _normType(Object? v) {
  final t = (v as String).trim().toUpperCase();
  return t == 'BOOLEAN' ? 'INTEGER' : t;
}

String _normSql(Object? v) =>
    (v as String).replaceAll(RegExp(r'\s+'), ' ').trim().toLowerCase();

Future<Map<String, Map<String, Object?>>> _describe(_Query q) async {
  final tableNames =
      (await q("SELECT name FROM sqlite_master WHERE type = 'table'"))
          .map((r) => r['name'] as String)
          .where((n) => !n.startsWith('sqlite_'))
          .toList()
        ..sort();

  final out = <String, Map<String, Object?>>{};
  for (final t in tableNames) {
    final cols = await q('PRAGMA table_info("$t")');
    final columns = [
      for (final c in cols)
        {
          'name': c['name'],
          'type': _normType(c['type']),
          'pk': c['pk'],
          // NOT NULL on PK columns is spelled differently by Drift; skip it there.
          'notnull': (c['pk'] as int) > 0 ? null : c['notnull'],
          'default': _normDefault(c['dflt_value']),
        },
    ];

    final fks = [
      for (final f in await q('PRAGMA foreign_key_list("$t")'))
        '${f['from']} -> ${f['table']}(${f['to']}) ON DELETE ${f['on_delete']} ON UPDATE ${f['on_update']}',
    ]..sort();

    final uniques = <String>[];
    final explicitIndexes = <String>[];
    for (final idx in await q('PRAGMA index_list("$t")')) {
      final name = idx['name'] as String;
      final origin = idx['origin'] as String;
      if (origin == 'u') {
        final cols = [
          for (final c in await q('PRAGMA index_info("$name")')) c['name'],
        ];
        uniques.add(cols.join(','));
      } else if (origin == 'c') {
        final sql = (await q(
          "SELECT sql FROM sqlite_master WHERE type = 'index' AND name = '$name'",
        )).single['sql'];
        explicitIndexes.add('$name :: ${_normSql(sql)}');
      }
    }
    uniques.sort();
    explicitIndexes.sort();

    out[t] = {
      'columns': columns,
      'foreignKeys': fks,
      'unique': uniques,
      'indexes': explicitIndexes,
    };
  }
  return out;
}

void main() {
  late Map<String, Map<String, Object?>> reference;
  late Map<String, Map<String, Object?>> actual;
  late AppDatabase db;

  setUpAll(() async {
    final sql = File('lib/core/db/schema.sql').readAsStringSync();
    final ref = s3.sqlite3.openInMemory();
    try {
      ref.execute(sql);
      reference = await _describe(
        (q) async => [
          for (final r in ref.select(q)) Map<String, Object?>.from(r),
        ],
      );
    } finally {
      ref.close();
    }

    db = AppDatabase(NativeDatabase.memory());
    actual = await _describe(
      (q) async => (await db.customSelect(q).get()).map((r) => r.data).toList(),
    );
  });

  tearDownAll(() => db.close());

  test('same set of tables as schema.sql', () {
    expect(reference, isNotEmpty);
    expect(actual.keys.toList(), reference.keys.toList());
  });

  test(
    'every table matches schema.sql: columns, defaults, keys, UNIQUE, foreign keys, indexes',
    () {
      for (final table in reference.keys) {
        final want = reference[table]!;
        final got = actual[table]!;
        expect(
          got['columns'],
          want['columns'],
          reason:
              '$table: columns (name, type, pk, nullability, default, ORDER)',
        );
        expect(
          got['foreignKeys'],
          want['foreignKeys'],
          reason: '$table: foreign keys / ON DELETE actions',
        );
        expect(
          got['unique'],
          want['unique'],
          reason: '$table: UNIQUE constraints',
        );
        expect(
          got['indexes'],
          want['indexes'],
          reason: '$table: explicit indexes',
        );
      }
    },
  );

  test(
    'schema.sql has exactly the indexes created by kSchemaIndexStatements',
    () {
      final fromFile = RegExp(r'CREATE INDEX [^;]+', caseSensitive: false)
          .allMatches(File('lib/core/db/schema.sql').readAsStringSync())
          .map((m) => _normSql(m.group(0)))
          .toSet();
      final fromCode = kSchemaIndexStatements.map(_normSql).toSet();
      expect(fromCode, fromFile);
    },
  );
}
