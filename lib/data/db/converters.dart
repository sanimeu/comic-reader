import 'package:drift/drift.dart';
import '../../domain/comic_source.dart' show ComicFormat;
import '../../domain/models.dart' show ComicType;

/// Maps between domain enums and the exact TEXT values allowed by schema.sql.
///
/// IMPORTANT: Drift's built-in `textEnum` would store the enum NAMES
/// ('imageFolder', 'singleImage'), which violate the schema's CHECK constraint
/// (`'folder'`, `'image'`). These explicit mappings keep the database values
/// identical to schema.sql. Both switches are exhaustive: adding a new enum
/// value fails to compile until its database value is chosen here.

String comicFormatToDb(ComicFormat format) => switch (format) {
  ComicFormat.cbz => 'cbz',
  ComicFormat.zip => 'zip',
  ComicFormat.cbr => 'cbr',
  ComicFormat.cb7 => 'cb7',
  ComicFormat.pdf => 'pdf',
  ComicFormat.imageFolder => 'folder',
  ComicFormat.singleImage => 'image',
};

ComicFormat comicFormatFromDb(String value) => switch (value) {
  'cbz' => ComicFormat.cbz,
  'zip' => ComicFormat.zip,
  'cbr' => ComicFormat.cbr,
  'cb7' => ComicFormat.cb7,
  'pdf' => ComicFormat.pdf,
  'folder' => ComicFormat.imageFolder,
  'image' => ComicFormat.singleImage,
  _ => throw ArgumentError.value(
    value,
    'comics.format',
    'Unknown format value',
  ),
};

String comicTypeToDb(ComicType type) => switch (type) {
  ComicType.manga => 'manga',
  ComicType.manhwa => 'manhwa',
  ComicType.manhua => 'manhua',
  ComicType.unknown => 'unknown',
};

ComicType comicTypeFromDb(String value) => switch (value) {
  'manga' => ComicType.manga,
  'manhwa' => ComicType.manhwa,
  'manhua' => ComicType.manhua,
  'unknown' => ComicType.unknown,
  _ => throw ArgumentError.value(value, 'series.type', 'Unknown type value'),
};

class ComicFormatConverter extends TypeConverter<ComicFormat, String> {
  const ComicFormatConverter();
  @override
  ComicFormat fromSql(String fromDb) => comicFormatFromDb(fromDb);
  @override
  String toSql(ComicFormat value) => comicFormatToDb(value);
}

class ComicTypeConverter extends TypeConverter<ComicType, String> {
  const ComicTypeConverter();
  @override
  ComicType fromSql(String fromDb) => comicTypeFromDb(fromDb);
  @override
  String toSql(ComicType value) => comicTypeToDb(value);
}

/// schema.sql stores booleans as plain `INTEGER` 0/1 (no CHECK, no BOOLEAN type).
/// A converter keeps the generated SQL identical while exposing `bool` in Dart.
class BoolIntConverter extends TypeConverter<bool, int> {
  const BoolIntConverter();
  @override
  bool fromSql(int fromDb) => fromDb != 0;
  @override
  int toSql(bool value) => value ? 1 : 0;
}
