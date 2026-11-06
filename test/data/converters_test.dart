import 'package:comic_reader/data/db/converters.dart';
import 'package:comic_reader/domain/comic_source.dart';
import 'package:comic_reader/domain/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'format: folder/image database values map to imageFolder/singleImage',
    () {
      expect(comicFormatFromDb('folder'), ComicFormat.imageFolder);
      expect(comicFormatFromDb('image'), ComicFormat.singleImage);
      expect(comicFormatToDb(ComicFormat.imageFolder), 'folder');
      expect(comicFormatToDb(ComicFormat.singleImage), 'image');
    },
  );

  test(
    'format: every enum value round-trips and uses a value allowed by schema.sql',
    () {
      const allowed = {'cbz', 'zip', 'cbr', 'cb7', 'pdf', 'folder', 'image'};
      final seen = <String>{};
      for (final f in ComicFormat.values) {
        final db = comicFormatToDb(f);
        expect(allowed, contains(db), reason: '$f');
        expect(comicFormatFromDb(db), f, reason: '$f');
        seen.add(db);
      }
      // No two enum values share a database value, and every allowed value is reachable.
      expect(seen, allowed);
    },
  );

  test(
    'format: enum NAMES and unknown strings are rejected (they would violate the CHECK)',
    () {
      expect(() => comicFormatFromDb('imageFolder'), throwsArgumentError);
      expect(() => comicFormatFromDb('singleImage'), throwsArgumentError);
      expect(() => comicFormatFromDb('CBZ'), throwsArgumentError);
      expect(() => comicFormatFromDb(''), throwsArgumentError);
    },
  );

  test('type: every enum value round-trips to the schema CHECK values', () {
    const allowed = {'manga', 'manhwa', 'manhua', 'unknown'};
    final seen = <String>{};
    for (final t in ComicType.values) {
      final db = comicTypeToDb(t);
      expect(comicTypeFromDb(db), t);
      seen.add(db);
    }
    expect(seen, allowed);
    expect(() => comicTypeFromDb('other'), throwsArgumentError);
  });

  test('converter classes delegate to the same mappings', () {
    const fc = ComicFormatConverter();
    expect(fc.toSql(ComicFormat.imageFolder), 'folder');
    expect(fc.fromSql('image'), ComicFormat.singleImage);
    const tc = ComicTypeConverter();
    expect(tc.toSql(ComicType.manhwa), 'manhwa');
    expect(tc.fromSql('unknown'), ComicType.unknown);
  });

  test('bool converter stores 0/1 and reads any non-zero as true', () {
    const c = BoolIntConverter();
    expect(c.toSql(true), 1);
    expect(c.toSql(false), 0);
    expect(c.fromSql(0), isFalse);
    expect(c.fromSql(1), isTrue);
    expect(c.fromSql(2), isTrue);
  });
}
