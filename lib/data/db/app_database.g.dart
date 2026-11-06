// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $LibraryRootsTable extends LibraryRoots
    with TableInfo<$LibraryRootsTable, LibraryRootRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LibraryRootsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _uriMeta = const VerificationMeta('uri');
  @override
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
    'uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<bool, int> autoScan =
      GeneratedColumn<int>(
        'auto_scan',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(1),
      ).withConverter<bool>($LibraryRootsTable.$converterautoScan);
  static const VerificationMeta _lastScanAtMeta = const VerificationMeta(
    'lastScanAt',
  );
  @override
  late final GeneratedColumn<int> lastScanAt = GeneratedColumn<int>(
    'last_scan_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    uri,
    displayName,
    autoScan,
    lastScanAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'library_roots';
  @override
  VerificationContext validateIntegrity(
    Insertable<LibraryRootRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('uri')) {
      context.handle(
        _uriMeta,
        uri.isAcceptableOrUnknown(data['uri']!, _uriMeta),
      );
    } else if (isInserting) {
      context.missing(_uriMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('last_scan_at')) {
      context.handle(
        _lastScanAtMeta,
        lastScanAt.isAcceptableOrUnknown(
          data['last_scan_at']!,
          _lastScanAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LibraryRootRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LibraryRootRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      uri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uri'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      autoScan: $LibraryRootsTable.$converterautoScan.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}auto_scan'],
        )!,
      ),
      lastScanAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_scan_at'],
      ),
    );
  }

  @override
  $LibraryRootsTable createAlias(String alias) {
    return $LibraryRootsTable(attachedDatabase, alias);
  }

  static TypeConverter<bool, int> $converterautoScan = const BoolIntConverter();
}

class LibraryRootRow extends DataClass implements Insertable<LibraryRootRow> {
  final int id;
  final String uri;
  final String displayName;
  final bool autoScan;
  final int? lastScanAt;
  const LibraryRootRow({
    required this.id,
    required this.uri,
    required this.displayName,
    required this.autoScan,
    this.lastScanAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['uri'] = Variable<String>(uri);
    map['display_name'] = Variable<String>(displayName);
    {
      map['auto_scan'] = Variable<int>(
        $LibraryRootsTable.$converterautoScan.toSql(autoScan),
      );
    }
    if (!nullToAbsent || lastScanAt != null) {
      map['last_scan_at'] = Variable<int>(lastScanAt);
    }
    return map;
  }

  LibraryRootsCompanion toCompanion(bool nullToAbsent) {
    return LibraryRootsCompanion(
      id: Value(id),
      uri: Value(uri),
      displayName: Value(displayName),
      autoScan: Value(autoScan),
      lastScanAt: lastScanAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastScanAt),
    );
  }

  factory LibraryRootRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LibraryRootRow(
      id: serializer.fromJson<int>(json['id']),
      uri: serializer.fromJson<String>(json['uri']),
      displayName: serializer.fromJson<String>(json['displayName']),
      autoScan: serializer.fromJson<bool>(json['autoScan']),
      lastScanAt: serializer.fromJson<int?>(json['lastScanAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'uri': serializer.toJson<String>(uri),
      'displayName': serializer.toJson<String>(displayName),
      'autoScan': serializer.toJson<bool>(autoScan),
      'lastScanAt': serializer.toJson<int?>(lastScanAt),
    };
  }

  LibraryRootRow copyWith({
    int? id,
    String? uri,
    String? displayName,
    bool? autoScan,
    Value<int?> lastScanAt = const Value.absent(),
  }) => LibraryRootRow(
    id: id ?? this.id,
    uri: uri ?? this.uri,
    displayName: displayName ?? this.displayName,
    autoScan: autoScan ?? this.autoScan,
    lastScanAt: lastScanAt.present ? lastScanAt.value : this.lastScanAt,
  );
  LibraryRootRow copyWithCompanion(LibraryRootsCompanion data) {
    return LibraryRootRow(
      id: data.id.present ? data.id.value : this.id,
      uri: data.uri.present ? data.uri.value : this.uri,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      autoScan: data.autoScan.present ? data.autoScan.value : this.autoScan,
      lastScanAt: data.lastScanAt.present
          ? data.lastScanAt.value
          : this.lastScanAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LibraryRootRow(')
          ..write('id: $id, ')
          ..write('uri: $uri, ')
          ..write('displayName: $displayName, ')
          ..write('autoScan: $autoScan, ')
          ..write('lastScanAt: $lastScanAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, uri, displayName, autoScan, lastScanAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LibraryRootRow &&
          other.id == this.id &&
          other.uri == this.uri &&
          other.displayName == this.displayName &&
          other.autoScan == this.autoScan &&
          other.lastScanAt == this.lastScanAt);
}

class LibraryRootsCompanion extends UpdateCompanion<LibraryRootRow> {
  final Value<int> id;
  final Value<String> uri;
  final Value<String> displayName;
  final Value<bool> autoScan;
  final Value<int?> lastScanAt;
  const LibraryRootsCompanion({
    this.id = const Value.absent(),
    this.uri = const Value.absent(),
    this.displayName = const Value.absent(),
    this.autoScan = const Value.absent(),
    this.lastScanAt = const Value.absent(),
  });
  LibraryRootsCompanion.insert({
    this.id = const Value.absent(),
    required String uri,
    required String displayName,
    this.autoScan = const Value.absent(),
    this.lastScanAt = const Value.absent(),
  }) : uri = Value(uri),
       displayName = Value(displayName);
  static Insertable<LibraryRootRow> custom({
    Expression<int>? id,
    Expression<String>? uri,
    Expression<String>? displayName,
    Expression<int>? autoScan,
    Expression<int>? lastScanAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (uri != null) 'uri': uri,
      if (displayName != null) 'display_name': displayName,
      if (autoScan != null) 'auto_scan': autoScan,
      if (lastScanAt != null) 'last_scan_at': lastScanAt,
    });
  }

  LibraryRootsCompanion copyWith({
    Value<int>? id,
    Value<String>? uri,
    Value<String>? displayName,
    Value<bool>? autoScan,
    Value<int?>? lastScanAt,
  }) {
    return LibraryRootsCompanion(
      id: id ?? this.id,
      uri: uri ?? this.uri,
      displayName: displayName ?? this.displayName,
      autoScan: autoScan ?? this.autoScan,
      lastScanAt: lastScanAt ?? this.lastScanAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (uri.present) {
      map['uri'] = Variable<String>(uri.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (autoScan.present) {
      map['auto_scan'] = Variable<int>(
        $LibraryRootsTable.$converterautoScan.toSql(autoScan.value),
      );
    }
    if (lastScanAt.present) {
      map['last_scan_at'] = Variable<int>(lastScanAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LibraryRootsCompanion(')
          ..write('id: $id, ')
          ..write('uri: $uri, ')
          ..write('displayName: $displayName, ')
          ..write('autoScan: $autoScan, ')
          ..write('lastScanAt: $lastScanAt')
          ..write(')'))
        .toString();
  }
}

class $SeriesTable extends Series with TableInfo<$SeriesTable, SeriesRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SeriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
    'author',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ComicType, String> type =
      GeneratedColumn<String>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('unknown'),
      ).withConverter<ComicType>($SeriesTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<bool, int> isFavourite =
      GeneratedColumn<int>(
        'is_favourite',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<bool>($SeriesTable.$converterisFavourite);
  @override
  late final GeneratedColumnWithTypeConverter<bool, int> isCompleted =
      GeneratedColumn<int>(
        'is_completed',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<bool>($SeriesTable.$converterisCompleted);
  static const VerificationMeta _coverComicIdMeta = const VerificationMeta(
    'coverComicId',
  );
  @override
  late final GeneratedColumn<int> coverComicId = GeneratedColumn<int>(
    'cover_comic_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<bool, int> manualOverride =
      GeneratedColumn<int>(
        'manual_override',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<bool>($SeriesTable.$convertermanualOverride);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    author,
    type,
    isFavourite,
    isCompleted,
    coverComicId,
    manualOverride,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'series';
  @override
  VerificationContext validateIntegrity(
    Insertable<SeriesRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('author')) {
      context.handle(
        _authorMeta,
        author.isAcceptableOrUnknown(data['author']!, _authorMeta),
      );
    }
    if (data.containsKey('cover_comic_id')) {
      context.handle(
        _coverComicIdMeta,
        coverComicId.isAcceptableOrUnknown(
          data['cover_comic_id']!,
          _coverComicIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SeriesRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SeriesRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      author: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}author'],
      ),
      type: $SeriesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}type'],
        )!,
      ),
      isFavourite: $SeriesTable.$converterisFavourite.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}is_favourite'],
        )!,
      ),
      isCompleted: $SeriesTable.$converterisCompleted.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}is_completed'],
        )!,
      ),
      coverComicId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cover_comic_id'],
      ),
      manualOverride: $SeriesTable.$convertermanualOverride.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}manual_override'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SeriesTable createAlias(String alias) {
    return $SeriesTable(attachedDatabase, alias);
  }

  static TypeConverter<ComicType, String> $convertertype =
      const ComicTypeConverter();
  static TypeConverter<bool, int> $converterisFavourite =
      const BoolIntConverter();
  static TypeConverter<bool, int> $converterisCompleted =
      const BoolIntConverter();
  static TypeConverter<bool, int> $convertermanualOverride =
      const BoolIntConverter();
}

class SeriesRow extends DataClass implements Insertable<SeriesRow> {
  final int id;
  final String title;
  final String? author;
  final ComicType type;
  final bool isFavourite;

  /// Manual "mark as completed" flag. Series STATUS is derived from comic progress
  /// (see library_mapper.dart); a set flag only forces 100%. Never written automatically.
  final bool isCompleted;
  final int? coverComicId;
  final bool manualOverride;
  final int createdAt;
  const SeriesRow({
    required this.id,
    required this.title,
    this.author,
    required this.type,
    required this.isFavourite,
    required this.isCompleted,
    this.coverComicId,
    required this.manualOverride,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || author != null) {
      map['author'] = Variable<String>(author);
    }
    {
      map['type'] = Variable<String>($SeriesTable.$convertertype.toSql(type));
    }
    {
      map['is_favourite'] = Variable<int>(
        $SeriesTable.$converterisFavourite.toSql(isFavourite),
      );
    }
    {
      map['is_completed'] = Variable<int>(
        $SeriesTable.$converterisCompleted.toSql(isCompleted),
      );
    }
    if (!nullToAbsent || coverComicId != null) {
      map['cover_comic_id'] = Variable<int>(coverComicId);
    }
    {
      map['manual_override'] = Variable<int>(
        $SeriesTable.$convertermanualOverride.toSql(manualOverride),
      );
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  SeriesCompanion toCompanion(bool nullToAbsent) {
    return SeriesCompanion(
      id: Value(id),
      title: Value(title),
      author: author == null && nullToAbsent
          ? const Value.absent()
          : Value(author),
      type: Value(type),
      isFavourite: Value(isFavourite),
      isCompleted: Value(isCompleted),
      coverComicId: coverComicId == null && nullToAbsent
          ? const Value.absent()
          : Value(coverComicId),
      manualOverride: Value(manualOverride),
      createdAt: Value(createdAt),
    );
  }

  factory SeriesRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SeriesRow(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      author: serializer.fromJson<String?>(json['author']),
      type: serializer.fromJson<ComicType>(json['type']),
      isFavourite: serializer.fromJson<bool>(json['isFavourite']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      coverComicId: serializer.fromJson<int?>(json['coverComicId']),
      manualOverride: serializer.fromJson<bool>(json['manualOverride']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'author': serializer.toJson<String?>(author),
      'type': serializer.toJson<ComicType>(type),
      'isFavourite': serializer.toJson<bool>(isFavourite),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'coverComicId': serializer.toJson<int?>(coverComicId),
      'manualOverride': serializer.toJson<bool>(manualOverride),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  SeriesRow copyWith({
    int? id,
    String? title,
    Value<String?> author = const Value.absent(),
    ComicType? type,
    bool? isFavourite,
    bool? isCompleted,
    Value<int?> coverComicId = const Value.absent(),
    bool? manualOverride,
    int? createdAt,
  }) => SeriesRow(
    id: id ?? this.id,
    title: title ?? this.title,
    author: author.present ? author.value : this.author,
    type: type ?? this.type,
    isFavourite: isFavourite ?? this.isFavourite,
    isCompleted: isCompleted ?? this.isCompleted,
    coverComicId: coverComicId.present ? coverComicId.value : this.coverComicId,
    manualOverride: manualOverride ?? this.manualOverride,
    createdAt: createdAt ?? this.createdAt,
  );
  SeriesRow copyWithCompanion(SeriesCompanion data) {
    return SeriesRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      author: data.author.present ? data.author.value : this.author,
      type: data.type.present ? data.type.value : this.type,
      isFavourite: data.isFavourite.present
          ? data.isFavourite.value
          : this.isFavourite,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      coverComicId: data.coverComicId.present
          ? data.coverComicId.value
          : this.coverComicId,
      manualOverride: data.manualOverride.present
          ? data.manualOverride.value
          : this.manualOverride,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SeriesRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('type: $type, ')
          ..write('isFavourite: $isFavourite, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('coverComicId: $coverComicId, ')
          ..write('manualOverride: $manualOverride, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    title,
    author,
    type,
    isFavourite,
    isCompleted,
    coverComicId,
    manualOverride,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SeriesRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.author == this.author &&
          other.type == this.type &&
          other.isFavourite == this.isFavourite &&
          other.isCompleted == this.isCompleted &&
          other.coverComicId == this.coverComicId &&
          other.manualOverride == this.manualOverride &&
          other.createdAt == this.createdAt);
}

class SeriesCompanion extends UpdateCompanion<SeriesRow> {
  final Value<int> id;
  final Value<String> title;
  final Value<String?> author;
  final Value<ComicType> type;
  final Value<bool> isFavourite;
  final Value<bool> isCompleted;
  final Value<int?> coverComicId;
  final Value<bool> manualOverride;
  final Value<int> createdAt;
  const SeriesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.author = const Value.absent(),
    this.type = const Value.absent(),
    this.isFavourite = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.coverComicId = const Value.absent(),
    this.manualOverride = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SeriesCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    this.author = const Value.absent(),
    this.type = const Value.absent(),
    this.isFavourite = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.coverComicId = const Value.absent(),
    this.manualOverride = const Value.absent(),
    required int createdAt,
  }) : title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<SeriesRow> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? author,
    Expression<String>? type,
    Expression<int>? isFavourite,
    Expression<int>? isCompleted,
    Expression<int>? coverComicId,
    Expression<int>? manualOverride,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (author != null) 'author': author,
      if (type != null) 'type': type,
      if (isFavourite != null) 'is_favourite': isFavourite,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (coverComicId != null) 'cover_comic_id': coverComicId,
      if (manualOverride != null) 'manual_override': manualOverride,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SeriesCompanion copyWith({
    Value<int>? id,
    Value<String>? title,
    Value<String?>? author,
    Value<ComicType>? type,
    Value<bool>? isFavourite,
    Value<bool>? isCompleted,
    Value<int?>? coverComicId,
    Value<bool>? manualOverride,
    Value<int>? createdAt,
  }) {
    return SeriesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      type: type ?? this.type,
      isFavourite: isFavourite ?? this.isFavourite,
      isCompleted: isCompleted ?? this.isCompleted,
      coverComicId: coverComicId ?? this.coverComicId,
      manualOverride: manualOverride ?? this.manualOverride,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(
        $SeriesTable.$convertertype.toSql(type.value),
      );
    }
    if (isFavourite.present) {
      map['is_favourite'] = Variable<int>(
        $SeriesTable.$converterisFavourite.toSql(isFavourite.value),
      );
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<int>(
        $SeriesTable.$converterisCompleted.toSql(isCompleted.value),
      );
    }
    if (coverComicId.present) {
      map['cover_comic_id'] = Variable<int>(coverComicId.value);
    }
    if (manualOverride.present) {
      map['manual_override'] = Variable<int>(
        $SeriesTable.$convertermanualOverride.toSql(manualOverride.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SeriesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('author: $author, ')
          ..write('type: $type, ')
          ..write('isFavourite: $isFavourite, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('coverComicId: $coverComicId, ')
          ..write('manualOverride: $manualOverride, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ComicsTable extends Comics with TableInfo<$ComicsTable, ComicRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComicsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _seriesIdMeta = const VerificationMeta(
    'seriesId',
  );
  @override
  late final GeneratedColumn<int> seriesId = GeneratedColumn<int>(
    'series_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES series (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _rootIdMeta = const VerificationMeta('rootId');
  @override
  late final GeneratedColumn<int> rootId = GeneratedColumn<int>(
    'root_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES library_roots (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _uriMeta = const VerificationMeta('uri');
  @override
  late final GeneratedColumn<String> uri = GeneratedColumn<String>(
    'uri',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<ComicFormat, String> format =
      GeneratedColumn<String>(
        'format',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ComicFormat>($ComicsTable.$converterformat);
  static const VerificationMeta _sizeBytesMeta = const VerificationMeta(
    'sizeBytes',
  );
  @override
  late final GeneratedColumn<int> sizeBytes = GeneratedColumn<int>(
    'size_bytes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentHashMeta = const VerificationMeta(
    'contentHash',
  );
  @override
  late final GeneratedColumn<String> contentHash = GeneratedColumn<String>(
    'content_hash',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chapterNumberMeta = const VerificationMeta(
    'chapterNumber',
  );
  @override
  late final GeneratedColumn<double> chapterNumber = GeneratedColumn<double>(
    'chapter_number',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chapterTitleMeta = const VerificationMeta(
    'chapterTitle',
  );
  @override
  late final GeneratedColumn<String> chapterTitle = GeneratedColumn<String>(
    'chapter_title',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _pageCountMeta = const VerificationMeta(
    'pageCount',
  );
  @override
  late final GeneratedColumn<int> pageCount = GeneratedColumn<int>(
    'page_count',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverCachePathMeta = const VerificationMeta(
    'coverCachePath',
  );
  @override
  late final GeneratedColumn<String> coverCachePath = GeneratedColumn<String>(
    'cover_cache_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<int> addedAt = GeneratedColumn<int>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<bool, int> missing =
      GeneratedColumn<int>(
        'missing',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<bool>($ComicsTable.$convertermissing);
  @override
  List<GeneratedColumn> get $columns => [
    id,
    seriesId,
    rootId,
    uri,
    fileName,
    format,
    sizeBytes,
    contentHash,
    chapterNumber,
    chapterTitle,
    pageCount,
    coverCachePath,
    addedAt,
    missing,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'comics';
  @override
  VerificationContext validateIntegrity(
    Insertable<ComicRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('series_id')) {
      context.handle(
        _seriesIdMeta,
        seriesId.isAcceptableOrUnknown(data['series_id']!, _seriesIdMeta),
      );
    }
    if (data.containsKey('root_id')) {
      context.handle(
        _rootIdMeta,
        rootId.isAcceptableOrUnknown(data['root_id']!, _rootIdMeta),
      );
    }
    if (data.containsKey('uri')) {
      context.handle(
        _uriMeta,
        uri.isAcceptableOrUnknown(data['uri']!, _uriMeta),
      );
    } else if (isInserting) {
      context.missing(_uriMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('size_bytes')) {
      context.handle(
        _sizeBytesMeta,
        sizeBytes.isAcceptableOrUnknown(data['size_bytes']!, _sizeBytesMeta),
      );
    } else if (isInserting) {
      context.missing(_sizeBytesMeta);
    }
    if (data.containsKey('content_hash')) {
      context.handle(
        _contentHashMeta,
        contentHash.isAcceptableOrUnknown(
          data['content_hash']!,
          _contentHashMeta,
        ),
      );
    }
    if (data.containsKey('chapter_number')) {
      context.handle(
        _chapterNumberMeta,
        chapterNumber.isAcceptableOrUnknown(
          data['chapter_number']!,
          _chapterNumberMeta,
        ),
      );
    }
    if (data.containsKey('chapter_title')) {
      context.handle(
        _chapterTitleMeta,
        chapterTitle.isAcceptableOrUnknown(
          data['chapter_title']!,
          _chapterTitleMeta,
        ),
      );
    }
    if (data.containsKey('page_count')) {
      context.handle(
        _pageCountMeta,
        pageCount.isAcceptableOrUnknown(data['page_count']!, _pageCountMeta),
      );
    }
    if (data.containsKey('cover_cache_path')) {
      context.handle(
        _coverCachePathMeta,
        coverCachePath.isAcceptableOrUnknown(
          data['cover_cache_path']!,
          _coverCachePathMeta,
        ),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_addedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ComicRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ComicRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      seriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}series_id'],
      ),
      rootId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}root_id'],
      ),
      uri: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}uri'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      format: $ComicsTable.$converterformat.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}format'],
        )!,
      ),
      sizeBytes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}size_bytes'],
      )!,
      contentHash: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_hash'],
      ),
      chapterNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}chapter_number'],
      ),
      chapterTitle: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chapter_title'],
      ),
      pageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_count'],
      ),
      coverCachePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_cache_path'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}added_at'],
      )!,
      missing: $ComicsTable.$convertermissing.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}missing'],
        )!,
      ),
    );
  }

  @override
  $ComicsTable createAlias(String alias) {
    return $ComicsTable(attachedDatabase, alias);
  }

  static TypeConverter<ComicFormat, String> $converterformat =
      const ComicFormatConverter();
  static TypeConverter<bool, int> $convertermissing = const BoolIntConverter();
}

class ComicRow extends DataClass implements Insertable<ComicRow> {
  final int id;
  final int? seriesId;
  final int? rootId;
  final String uri;
  final String fileName;
  final ComicFormat format;
  final int sizeBytes;
  final String? contentHash;
  final double? chapterNumber;
  final String? chapterTitle;
  final int? pageCount;
  final String? coverCachePath;
  final int addedAt;
  final bool missing;
  const ComicRow({
    required this.id,
    this.seriesId,
    this.rootId,
    required this.uri,
    required this.fileName,
    required this.format,
    required this.sizeBytes,
    this.contentHash,
    this.chapterNumber,
    this.chapterTitle,
    this.pageCount,
    this.coverCachePath,
    required this.addedAt,
    required this.missing,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || seriesId != null) {
      map['series_id'] = Variable<int>(seriesId);
    }
    if (!nullToAbsent || rootId != null) {
      map['root_id'] = Variable<int>(rootId);
    }
    map['uri'] = Variable<String>(uri);
    map['file_name'] = Variable<String>(fileName);
    {
      map['format'] = Variable<String>(
        $ComicsTable.$converterformat.toSql(format),
      );
    }
    map['size_bytes'] = Variable<int>(sizeBytes);
    if (!nullToAbsent || contentHash != null) {
      map['content_hash'] = Variable<String>(contentHash);
    }
    if (!nullToAbsent || chapterNumber != null) {
      map['chapter_number'] = Variable<double>(chapterNumber);
    }
    if (!nullToAbsent || chapterTitle != null) {
      map['chapter_title'] = Variable<String>(chapterTitle);
    }
    if (!nullToAbsent || pageCount != null) {
      map['page_count'] = Variable<int>(pageCount);
    }
    if (!nullToAbsent || coverCachePath != null) {
      map['cover_cache_path'] = Variable<String>(coverCachePath);
    }
    map['added_at'] = Variable<int>(addedAt);
    {
      map['missing'] = Variable<int>(
        $ComicsTable.$convertermissing.toSql(missing),
      );
    }
    return map;
  }

  ComicsCompanion toCompanion(bool nullToAbsent) {
    return ComicsCompanion(
      id: Value(id),
      seriesId: seriesId == null && nullToAbsent
          ? const Value.absent()
          : Value(seriesId),
      rootId: rootId == null && nullToAbsent
          ? const Value.absent()
          : Value(rootId),
      uri: Value(uri),
      fileName: Value(fileName),
      format: Value(format),
      sizeBytes: Value(sizeBytes),
      contentHash: contentHash == null && nullToAbsent
          ? const Value.absent()
          : Value(contentHash),
      chapterNumber: chapterNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterNumber),
      chapterTitle: chapterTitle == null && nullToAbsent
          ? const Value.absent()
          : Value(chapterTitle),
      pageCount: pageCount == null && nullToAbsent
          ? const Value.absent()
          : Value(pageCount),
      coverCachePath: coverCachePath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverCachePath),
      addedAt: Value(addedAt),
      missing: Value(missing),
    );
  }

  factory ComicRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ComicRow(
      id: serializer.fromJson<int>(json['id']),
      seriesId: serializer.fromJson<int?>(json['seriesId']),
      rootId: serializer.fromJson<int?>(json['rootId']),
      uri: serializer.fromJson<String>(json['uri']),
      fileName: serializer.fromJson<String>(json['fileName']),
      format: serializer.fromJson<ComicFormat>(json['format']),
      sizeBytes: serializer.fromJson<int>(json['sizeBytes']),
      contentHash: serializer.fromJson<String?>(json['contentHash']),
      chapterNumber: serializer.fromJson<double?>(json['chapterNumber']),
      chapterTitle: serializer.fromJson<String?>(json['chapterTitle']),
      pageCount: serializer.fromJson<int?>(json['pageCount']),
      coverCachePath: serializer.fromJson<String?>(json['coverCachePath']),
      addedAt: serializer.fromJson<int>(json['addedAt']),
      missing: serializer.fromJson<bool>(json['missing']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'seriesId': serializer.toJson<int?>(seriesId),
      'rootId': serializer.toJson<int?>(rootId),
      'uri': serializer.toJson<String>(uri),
      'fileName': serializer.toJson<String>(fileName),
      'format': serializer.toJson<ComicFormat>(format),
      'sizeBytes': serializer.toJson<int>(sizeBytes),
      'contentHash': serializer.toJson<String?>(contentHash),
      'chapterNumber': serializer.toJson<double?>(chapterNumber),
      'chapterTitle': serializer.toJson<String?>(chapterTitle),
      'pageCount': serializer.toJson<int?>(pageCount),
      'coverCachePath': serializer.toJson<String?>(coverCachePath),
      'addedAt': serializer.toJson<int>(addedAt),
      'missing': serializer.toJson<bool>(missing),
    };
  }

  ComicRow copyWith({
    int? id,
    Value<int?> seriesId = const Value.absent(),
    Value<int?> rootId = const Value.absent(),
    String? uri,
    String? fileName,
    ComicFormat? format,
    int? sizeBytes,
    Value<String?> contentHash = const Value.absent(),
    Value<double?> chapterNumber = const Value.absent(),
    Value<String?> chapterTitle = const Value.absent(),
    Value<int?> pageCount = const Value.absent(),
    Value<String?> coverCachePath = const Value.absent(),
    int? addedAt,
    bool? missing,
  }) => ComicRow(
    id: id ?? this.id,
    seriesId: seriesId.present ? seriesId.value : this.seriesId,
    rootId: rootId.present ? rootId.value : this.rootId,
    uri: uri ?? this.uri,
    fileName: fileName ?? this.fileName,
    format: format ?? this.format,
    sizeBytes: sizeBytes ?? this.sizeBytes,
    contentHash: contentHash.present ? contentHash.value : this.contentHash,
    chapterNumber: chapterNumber.present
        ? chapterNumber.value
        : this.chapterNumber,
    chapterTitle: chapterTitle.present ? chapterTitle.value : this.chapterTitle,
    pageCount: pageCount.present ? pageCount.value : this.pageCount,
    coverCachePath: coverCachePath.present
        ? coverCachePath.value
        : this.coverCachePath,
    addedAt: addedAt ?? this.addedAt,
    missing: missing ?? this.missing,
  );
  ComicRow copyWithCompanion(ComicsCompanion data) {
    return ComicRow(
      id: data.id.present ? data.id.value : this.id,
      seriesId: data.seriesId.present ? data.seriesId.value : this.seriesId,
      rootId: data.rootId.present ? data.rootId.value : this.rootId,
      uri: data.uri.present ? data.uri.value : this.uri,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      format: data.format.present ? data.format.value : this.format,
      sizeBytes: data.sizeBytes.present ? data.sizeBytes.value : this.sizeBytes,
      contentHash: data.contentHash.present
          ? data.contentHash.value
          : this.contentHash,
      chapterNumber: data.chapterNumber.present
          ? data.chapterNumber.value
          : this.chapterNumber,
      chapterTitle: data.chapterTitle.present
          ? data.chapterTitle.value
          : this.chapterTitle,
      pageCount: data.pageCount.present ? data.pageCount.value : this.pageCount,
      coverCachePath: data.coverCachePath.present
          ? data.coverCachePath.value
          : this.coverCachePath,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
      missing: data.missing.present ? data.missing.value : this.missing,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ComicRow(')
          ..write('id: $id, ')
          ..write('seriesId: $seriesId, ')
          ..write('rootId: $rootId, ')
          ..write('uri: $uri, ')
          ..write('fileName: $fileName, ')
          ..write('format: $format, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('contentHash: $contentHash, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('chapterTitle: $chapterTitle, ')
          ..write('pageCount: $pageCount, ')
          ..write('coverCachePath: $coverCachePath, ')
          ..write('addedAt: $addedAt, ')
          ..write('missing: $missing')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    seriesId,
    rootId,
    uri,
    fileName,
    format,
    sizeBytes,
    contentHash,
    chapterNumber,
    chapterTitle,
    pageCount,
    coverCachePath,
    addedAt,
    missing,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ComicRow &&
          other.id == this.id &&
          other.seriesId == this.seriesId &&
          other.rootId == this.rootId &&
          other.uri == this.uri &&
          other.fileName == this.fileName &&
          other.format == this.format &&
          other.sizeBytes == this.sizeBytes &&
          other.contentHash == this.contentHash &&
          other.chapterNumber == this.chapterNumber &&
          other.chapterTitle == this.chapterTitle &&
          other.pageCount == this.pageCount &&
          other.coverCachePath == this.coverCachePath &&
          other.addedAt == this.addedAt &&
          other.missing == this.missing);
}

class ComicsCompanion extends UpdateCompanion<ComicRow> {
  final Value<int> id;
  final Value<int?> seriesId;
  final Value<int?> rootId;
  final Value<String> uri;
  final Value<String> fileName;
  final Value<ComicFormat> format;
  final Value<int> sizeBytes;
  final Value<String?> contentHash;
  final Value<double?> chapterNumber;
  final Value<String?> chapterTitle;
  final Value<int?> pageCount;
  final Value<String?> coverCachePath;
  final Value<int> addedAt;
  final Value<bool> missing;
  const ComicsCompanion({
    this.id = const Value.absent(),
    this.seriesId = const Value.absent(),
    this.rootId = const Value.absent(),
    this.uri = const Value.absent(),
    this.fileName = const Value.absent(),
    this.format = const Value.absent(),
    this.sizeBytes = const Value.absent(),
    this.contentHash = const Value.absent(),
    this.chapterNumber = const Value.absent(),
    this.chapterTitle = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.coverCachePath = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.missing = const Value.absent(),
  });
  ComicsCompanion.insert({
    this.id = const Value.absent(),
    this.seriesId = const Value.absent(),
    this.rootId = const Value.absent(),
    required String uri,
    required String fileName,
    required ComicFormat format,
    required int sizeBytes,
    this.contentHash = const Value.absent(),
    this.chapterNumber = const Value.absent(),
    this.chapterTitle = const Value.absent(),
    this.pageCount = const Value.absent(),
    this.coverCachePath = const Value.absent(),
    required int addedAt,
    this.missing = const Value.absent(),
  }) : uri = Value(uri),
       fileName = Value(fileName),
       format = Value(format),
       sizeBytes = Value(sizeBytes),
       addedAt = Value(addedAt);
  static Insertable<ComicRow> custom({
    Expression<int>? id,
    Expression<int>? seriesId,
    Expression<int>? rootId,
    Expression<String>? uri,
    Expression<String>? fileName,
    Expression<String>? format,
    Expression<int>? sizeBytes,
    Expression<String>? contentHash,
    Expression<double>? chapterNumber,
    Expression<String>? chapterTitle,
    Expression<int>? pageCount,
    Expression<String>? coverCachePath,
    Expression<int>? addedAt,
    Expression<int>? missing,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (seriesId != null) 'series_id': seriesId,
      if (rootId != null) 'root_id': rootId,
      if (uri != null) 'uri': uri,
      if (fileName != null) 'file_name': fileName,
      if (format != null) 'format': format,
      if (sizeBytes != null) 'size_bytes': sizeBytes,
      if (contentHash != null) 'content_hash': contentHash,
      if (chapterNumber != null) 'chapter_number': chapterNumber,
      if (chapterTitle != null) 'chapter_title': chapterTitle,
      if (pageCount != null) 'page_count': pageCount,
      if (coverCachePath != null) 'cover_cache_path': coverCachePath,
      if (addedAt != null) 'added_at': addedAt,
      if (missing != null) 'missing': missing,
    });
  }

  ComicsCompanion copyWith({
    Value<int>? id,
    Value<int?>? seriesId,
    Value<int?>? rootId,
    Value<String>? uri,
    Value<String>? fileName,
    Value<ComicFormat>? format,
    Value<int>? sizeBytes,
    Value<String?>? contentHash,
    Value<double?>? chapterNumber,
    Value<String?>? chapterTitle,
    Value<int?>? pageCount,
    Value<String?>? coverCachePath,
    Value<int>? addedAt,
    Value<bool>? missing,
  }) {
    return ComicsCompanion(
      id: id ?? this.id,
      seriesId: seriesId ?? this.seriesId,
      rootId: rootId ?? this.rootId,
      uri: uri ?? this.uri,
      fileName: fileName ?? this.fileName,
      format: format ?? this.format,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      contentHash: contentHash ?? this.contentHash,
      chapterNumber: chapterNumber ?? this.chapterNumber,
      chapterTitle: chapterTitle ?? this.chapterTitle,
      pageCount: pageCount ?? this.pageCount,
      coverCachePath: coverCachePath ?? this.coverCachePath,
      addedAt: addedAt ?? this.addedAt,
      missing: missing ?? this.missing,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (seriesId.present) {
      map['series_id'] = Variable<int>(seriesId.value);
    }
    if (rootId.present) {
      map['root_id'] = Variable<int>(rootId.value);
    }
    if (uri.present) {
      map['uri'] = Variable<String>(uri.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (format.present) {
      map['format'] = Variable<String>(
        $ComicsTable.$converterformat.toSql(format.value),
      );
    }
    if (sizeBytes.present) {
      map['size_bytes'] = Variable<int>(sizeBytes.value);
    }
    if (contentHash.present) {
      map['content_hash'] = Variable<String>(contentHash.value);
    }
    if (chapterNumber.present) {
      map['chapter_number'] = Variable<double>(chapterNumber.value);
    }
    if (chapterTitle.present) {
      map['chapter_title'] = Variable<String>(chapterTitle.value);
    }
    if (pageCount.present) {
      map['page_count'] = Variable<int>(pageCount.value);
    }
    if (coverCachePath.present) {
      map['cover_cache_path'] = Variable<String>(coverCachePath.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<int>(addedAt.value);
    }
    if (missing.present) {
      map['missing'] = Variable<int>(
        $ComicsTable.$convertermissing.toSql(missing.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComicsCompanion(')
          ..write('id: $id, ')
          ..write('seriesId: $seriesId, ')
          ..write('rootId: $rootId, ')
          ..write('uri: $uri, ')
          ..write('fileName: $fileName, ')
          ..write('format: $format, ')
          ..write('sizeBytes: $sizeBytes, ')
          ..write('contentHash: $contentHash, ')
          ..write('chapterNumber: $chapterNumber, ')
          ..write('chapterTitle: $chapterTitle, ')
          ..write('pageCount: $pageCount, ')
          ..write('coverCachePath: $coverCachePath, ')
          ..write('addedAt: $addedAt, ')
          ..write('missing: $missing')
          ..write(')'))
        .toString();
  }
}

class $ReadingProgressTable extends ReadingProgress
    with TableInfo<$ReadingProgressTable, ReadingProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadingProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _comicIdMeta = const VerificationMeta(
    'comicId',
  );
  @override
  late final GeneratedColumn<int> comicId = GeneratedColumn<int>(
    'comic_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES comics (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _pageIndexMeta = const VerificationMeta(
    'pageIndex',
  );
  @override
  late final GeneratedColumn<int> pageIndex = GeneratedColumn<int>(
    'page_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _scrollOffsetMeta = const VerificationMeta(
    'scrollOffset',
  );
  @override
  late final GeneratedColumn<double> scrollOffset = GeneratedColumn<double>(
    'scroll_offset',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _percentMeta = const VerificationMeta(
    'percent',
  );
  @override
  late final GeneratedColumn<double> percent = GeneratedColumn<double>(
    'percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  @override
  late final GeneratedColumnWithTypeConverter<bool, int> completed =
      GeneratedColumn<int>(
        'completed',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<bool>($ReadingProgressTable.$convertercompleted);
  static const VerificationMeta _lastReadAtMeta = const VerificationMeta(
    'lastReadAt',
  );
  @override
  late final GeneratedColumn<int> lastReadAt = GeneratedColumn<int>(
    'last_read_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    comicId,
    pageIndex,
    scrollOffset,
    percent,
    completed,
    lastReadAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reading_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReadingProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('comic_id')) {
      context.handle(
        _comicIdMeta,
        comicId.isAcceptableOrUnknown(data['comic_id']!, _comicIdMeta),
      );
    }
    if (data.containsKey('page_index')) {
      context.handle(
        _pageIndexMeta,
        pageIndex.isAcceptableOrUnknown(data['page_index']!, _pageIndexMeta),
      );
    }
    if (data.containsKey('scroll_offset')) {
      context.handle(
        _scrollOffsetMeta,
        scrollOffset.isAcceptableOrUnknown(
          data['scroll_offset']!,
          _scrollOffsetMeta,
        ),
      );
    }
    if (data.containsKey('percent')) {
      context.handle(
        _percentMeta,
        percent.isAcceptableOrUnknown(data['percent']!, _percentMeta),
      );
    }
    if (data.containsKey('last_read_at')) {
      context.handle(
        _lastReadAtMeta,
        lastReadAt.isAcceptableOrUnknown(
          data['last_read_at']!,
          _lastReadAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastReadAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {comicId};
  @override
  ReadingProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadingProgressRow(
      comicId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}comic_id'],
      )!,
      pageIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_index'],
      )!,
      scrollOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}scroll_offset'],
      )!,
      percent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}percent'],
      )!,
      completed: $ReadingProgressTable.$convertercompleted.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}completed'],
        )!,
      ),
      lastReadAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_read_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ReadingProgressTable createAlias(String alias) {
    return $ReadingProgressTable(attachedDatabase, alias);
  }

  static TypeConverter<bool, int> $convertercompleted =
      const BoolIntConverter();
}

class ReadingProgressRow extends DataClass
    implements Insertable<ReadingProgressRow> {
  final int comicId;
  final int pageIndex;
  final double scrollOffset;
  final double percent;
  final bool completed;
  final int lastReadAt;
  final int updatedAt;
  const ReadingProgressRow({
    required this.comicId,
    required this.pageIndex,
    required this.scrollOffset,
    required this.percent,
    required this.completed,
    required this.lastReadAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['comic_id'] = Variable<int>(comicId);
    map['page_index'] = Variable<int>(pageIndex);
    map['scroll_offset'] = Variable<double>(scrollOffset);
    map['percent'] = Variable<double>(percent);
    {
      map['completed'] = Variable<int>(
        $ReadingProgressTable.$convertercompleted.toSql(completed),
      );
    }
    map['last_read_at'] = Variable<int>(lastReadAt);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  ReadingProgressCompanion toCompanion(bool nullToAbsent) {
    return ReadingProgressCompanion(
      comicId: Value(comicId),
      pageIndex: Value(pageIndex),
      scrollOffset: Value(scrollOffset),
      percent: Value(percent),
      completed: Value(completed),
      lastReadAt: Value(lastReadAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ReadingProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadingProgressRow(
      comicId: serializer.fromJson<int>(json['comicId']),
      pageIndex: serializer.fromJson<int>(json['pageIndex']),
      scrollOffset: serializer.fromJson<double>(json['scrollOffset']),
      percent: serializer.fromJson<double>(json['percent']),
      completed: serializer.fromJson<bool>(json['completed']),
      lastReadAt: serializer.fromJson<int>(json['lastReadAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'comicId': serializer.toJson<int>(comicId),
      'pageIndex': serializer.toJson<int>(pageIndex),
      'scrollOffset': serializer.toJson<double>(scrollOffset),
      'percent': serializer.toJson<double>(percent),
      'completed': serializer.toJson<bool>(completed),
      'lastReadAt': serializer.toJson<int>(lastReadAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  ReadingProgressRow copyWith({
    int? comicId,
    int? pageIndex,
    double? scrollOffset,
    double? percent,
    bool? completed,
    int? lastReadAt,
    int? updatedAt,
  }) => ReadingProgressRow(
    comicId: comicId ?? this.comicId,
    pageIndex: pageIndex ?? this.pageIndex,
    scrollOffset: scrollOffset ?? this.scrollOffset,
    percent: percent ?? this.percent,
    completed: completed ?? this.completed,
    lastReadAt: lastReadAt ?? this.lastReadAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ReadingProgressRow copyWithCompanion(ReadingProgressCompanion data) {
    return ReadingProgressRow(
      comicId: data.comicId.present ? data.comicId.value : this.comicId,
      pageIndex: data.pageIndex.present ? data.pageIndex.value : this.pageIndex,
      scrollOffset: data.scrollOffset.present
          ? data.scrollOffset.value
          : this.scrollOffset,
      percent: data.percent.present ? data.percent.value : this.percent,
      completed: data.completed.present ? data.completed.value : this.completed,
      lastReadAt: data.lastReadAt.present
          ? data.lastReadAt.value
          : this.lastReadAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressRow(')
          ..write('comicId: $comicId, ')
          ..write('pageIndex: $pageIndex, ')
          ..write('scrollOffset: $scrollOffset, ')
          ..write('percent: $percent, ')
          ..write('completed: $completed, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    comicId,
    pageIndex,
    scrollOffset,
    percent,
    completed,
    lastReadAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadingProgressRow &&
          other.comicId == this.comicId &&
          other.pageIndex == this.pageIndex &&
          other.scrollOffset == this.scrollOffset &&
          other.percent == this.percent &&
          other.completed == this.completed &&
          other.lastReadAt == this.lastReadAt &&
          other.updatedAt == this.updatedAt);
}

class ReadingProgressCompanion extends UpdateCompanion<ReadingProgressRow> {
  final Value<int> comicId;
  final Value<int> pageIndex;
  final Value<double> scrollOffset;
  final Value<double> percent;
  final Value<bool> completed;
  final Value<int> lastReadAt;
  final Value<int> updatedAt;
  const ReadingProgressCompanion({
    this.comicId = const Value.absent(),
    this.pageIndex = const Value.absent(),
    this.scrollOffset = const Value.absent(),
    this.percent = const Value.absent(),
    this.completed = const Value.absent(),
    this.lastReadAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  ReadingProgressCompanion.insert({
    this.comicId = const Value.absent(),
    this.pageIndex = const Value.absent(),
    this.scrollOffset = const Value.absent(),
    this.percent = const Value.absent(),
    this.completed = const Value.absent(),
    required int lastReadAt,
    required int updatedAt,
  }) : lastReadAt = Value(lastReadAt),
       updatedAt = Value(updatedAt);
  static Insertable<ReadingProgressRow> custom({
    Expression<int>? comicId,
    Expression<int>? pageIndex,
    Expression<double>? scrollOffset,
    Expression<double>? percent,
    Expression<int>? completed,
    Expression<int>? lastReadAt,
    Expression<int>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (comicId != null) 'comic_id': comicId,
      if (pageIndex != null) 'page_index': pageIndex,
      if (scrollOffset != null) 'scroll_offset': scrollOffset,
      if (percent != null) 'percent': percent,
      if (completed != null) 'completed': completed,
      if (lastReadAt != null) 'last_read_at': lastReadAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  ReadingProgressCompanion copyWith({
    Value<int>? comicId,
    Value<int>? pageIndex,
    Value<double>? scrollOffset,
    Value<double>? percent,
    Value<bool>? completed,
    Value<int>? lastReadAt,
    Value<int>? updatedAt,
  }) {
    return ReadingProgressCompanion(
      comicId: comicId ?? this.comicId,
      pageIndex: pageIndex ?? this.pageIndex,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      percent: percent ?? this.percent,
      completed: completed ?? this.completed,
      lastReadAt: lastReadAt ?? this.lastReadAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (comicId.present) {
      map['comic_id'] = Variable<int>(comicId.value);
    }
    if (pageIndex.present) {
      map['page_index'] = Variable<int>(pageIndex.value);
    }
    if (scrollOffset.present) {
      map['scroll_offset'] = Variable<double>(scrollOffset.value);
    }
    if (percent.present) {
      map['percent'] = Variable<double>(percent.value);
    }
    if (completed.present) {
      map['completed'] = Variable<int>(
        $ReadingProgressTable.$convertercompleted.toSql(completed.value),
      );
    }
    if (lastReadAt.present) {
      map['last_read_at'] = Variable<int>(lastReadAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadingProgressCompanion(')
          ..write('comicId: $comicId, ')
          ..write('pageIndex: $pageIndex, ')
          ..write('scrollOffset: $scrollOffset, ')
          ..write('percent: $percent, ')
          ..write('completed: $completed, ')
          ..write('lastReadAt: $lastReadAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $BookmarksTable extends Bookmarks
    with TableInfo<$BookmarksTable, BookmarkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _comicIdMeta = const VerificationMeta(
    'comicId',
  );
  @override
  late final GeneratedColumn<int> comicId = GeneratedColumn<int>(
    'comic_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES comics (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _pageIndexMeta = const VerificationMeta(
    'pageIndex',
  );
  @override
  late final GeneratedColumn<int> pageIndex = GeneratedColumn<int>(
    'page_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scrollOffsetMeta = const VerificationMeta(
    'scrollOffset',
  );
  @override
  late final GeneratedColumn<double> scrollOffset = GeneratedColumn<double>(
    'scroll_offset',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    comicId,
    pageIndex,
    scrollOffset,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<BookmarkRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('comic_id')) {
      context.handle(
        _comicIdMeta,
        comicId.isAcceptableOrUnknown(data['comic_id']!, _comicIdMeta),
      );
    } else if (isInserting) {
      context.missing(_comicIdMeta);
    }
    if (data.containsKey('page_index')) {
      context.handle(
        _pageIndexMeta,
        pageIndex.isAcceptableOrUnknown(data['page_index']!, _pageIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_pageIndexMeta);
    }
    if (data.containsKey('scroll_offset')) {
      context.handle(
        _scrollOffsetMeta,
        scrollOffset.isAcceptableOrUnknown(
          data['scroll_offset']!,
          _scrollOffsetMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BookmarkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BookmarkRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      comicId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}comic_id'],
      )!,
      pageIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}page_index'],
      )!,
      scrollOffset: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}scroll_offset'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BookmarksTable createAlias(String alias) {
    return $BookmarksTable(attachedDatabase, alias);
  }
}

class BookmarkRow extends DataClass implements Insertable<BookmarkRow> {
  final int id;
  final int comicId;
  final int pageIndex;
  final double scrollOffset;
  final String? note;
  final int createdAt;
  const BookmarkRow({
    required this.id,
    required this.comicId,
    required this.pageIndex,
    required this.scrollOffset,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['comic_id'] = Variable<int>(comicId);
    map['page_index'] = Variable<int>(pageIndex);
    map['scroll_offset'] = Variable<double>(scrollOffset);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  BookmarksCompanion toCompanion(bool nullToAbsent) {
    return BookmarksCompanion(
      id: Value(id),
      comicId: Value(comicId),
      pageIndex: Value(pageIndex),
      scrollOffset: Value(scrollOffset),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory BookmarkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BookmarkRow(
      id: serializer.fromJson<int>(json['id']),
      comicId: serializer.fromJson<int>(json['comicId']),
      pageIndex: serializer.fromJson<int>(json['pageIndex']),
      scrollOffset: serializer.fromJson<double>(json['scrollOffset']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'comicId': serializer.toJson<int>(comicId),
      'pageIndex': serializer.toJson<int>(pageIndex),
      'scrollOffset': serializer.toJson<double>(scrollOffset),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  BookmarkRow copyWith({
    int? id,
    int? comicId,
    int? pageIndex,
    double? scrollOffset,
    Value<String?> note = const Value.absent(),
    int? createdAt,
  }) => BookmarkRow(
    id: id ?? this.id,
    comicId: comicId ?? this.comicId,
    pageIndex: pageIndex ?? this.pageIndex,
    scrollOffset: scrollOffset ?? this.scrollOffset,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  BookmarkRow copyWithCompanion(BookmarksCompanion data) {
    return BookmarkRow(
      id: data.id.present ? data.id.value : this.id,
      comicId: data.comicId.present ? data.comicId.value : this.comicId,
      pageIndex: data.pageIndex.present ? data.pageIndex.value : this.pageIndex,
      scrollOffset: data.scrollOffset.present
          ? data.scrollOffset.value
          : this.scrollOffset,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BookmarkRow(')
          ..write('id: $id, ')
          ..write('comicId: $comicId, ')
          ..write('pageIndex: $pageIndex, ')
          ..write('scrollOffset: $scrollOffset, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, comicId, pageIndex, scrollOffset, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BookmarkRow &&
          other.id == this.id &&
          other.comicId == this.comicId &&
          other.pageIndex == this.pageIndex &&
          other.scrollOffset == this.scrollOffset &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class BookmarksCompanion extends UpdateCompanion<BookmarkRow> {
  final Value<int> id;
  final Value<int> comicId;
  final Value<int> pageIndex;
  final Value<double> scrollOffset;
  final Value<String?> note;
  final Value<int> createdAt;
  const BookmarksCompanion({
    this.id = const Value.absent(),
    this.comicId = const Value.absent(),
    this.pageIndex = const Value.absent(),
    this.scrollOffset = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  BookmarksCompanion.insert({
    this.id = const Value.absent(),
    required int comicId,
    required int pageIndex,
    this.scrollOffset = const Value.absent(),
    this.note = const Value.absent(),
    required int createdAt,
  }) : comicId = Value(comicId),
       pageIndex = Value(pageIndex),
       createdAt = Value(createdAt);
  static Insertable<BookmarkRow> custom({
    Expression<int>? id,
    Expression<int>? comicId,
    Expression<int>? pageIndex,
    Expression<double>? scrollOffset,
    Expression<String>? note,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (comicId != null) 'comic_id': comicId,
      if (pageIndex != null) 'page_index': pageIndex,
      if (scrollOffset != null) 'scroll_offset': scrollOffset,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  BookmarksCompanion copyWith({
    Value<int>? id,
    Value<int>? comicId,
    Value<int>? pageIndex,
    Value<double>? scrollOffset,
    Value<String?>? note,
    Value<int>? createdAt,
  }) {
    return BookmarksCompanion(
      id: id ?? this.id,
      comicId: comicId ?? this.comicId,
      pageIndex: pageIndex ?? this.pageIndex,
      scrollOffset: scrollOffset ?? this.scrollOffset,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (comicId.present) {
      map['comic_id'] = Variable<int>(comicId.value);
    }
    if (pageIndex.present) {
      map['page_index'] = Variable<int>(pageIndex.value);
    }
    if (scrollOffset.present) {
      map['scroll_offset'] = Variable<double>(scrollOffset.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BookmarksCompanion(')
          ..write('id: $id, ')
          ..write('comicId: $comicId, ')
          ..write('pageIndex: $pageIndex, ')
          ..write('scrollOffset: $scrollOffset, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CollectionsTable extends Collections
    with TableInfo<$CollectionsTable, CollectionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, sortOrder, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collections';
  @override
  VerificationContext validateIntegrity(
    Insertable<CollectionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CollectionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollectionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CollectionsTable createAlias(String alias) {
    return $CollectionsTable(attachedDatabase, alias);
  }
}

class CollectionRow extends DataClass implements Insertable<CollectionRow> {
  final int id;
  final String name;
  final int sortOrder;
  final int createdAt;
  const CollectionRow({
    required this.id,
    required this.name,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  CollectionsCompanion toCompanion(bool nullToAbsent) {
    return CollectionsCompanion(
      id: Value(id),
      name: Value(name),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory CollectionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollectionRow(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  CollectionRow copyWith({
    int? id,
    String? name,
    int? sortOrder,
    int? createdAt,
  }) => CollectionRow(
    id: id ?? this.id,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  CollectionRow copyWithCompanion(CollectionsCompanion data) {
    return CollectionRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollectionRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, sortOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectionRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class CollectionsCompanion extends UpdateCompanion<CollectionRow> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<int> createdAt;
  const CollectionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CollectionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.sortOrder = const Value.absent(),
    required int createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<CollectionRow> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CollectionsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<int>? createdAt,
  }) {
    return CollectionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $CollectionSeriesTable extends CollectionSeries
    with TableInfo<$CollectionSeriesTable, CollectionSeriesRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CollectionSeriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _collectionIdMeta = const VerificationMeta(
    'collectionId',
  );
  @override
  late final GeneratedColumn<int> collectionId = GeneratedColumn<int>(
    'collection_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES collections (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _seriesIdMeta = const VerificationMeta(
    'seriesId',
  );
  @override
  late final GeneratedColumn<int> seriesId = GeneratedColumn<int>(
    'series_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES series (id) ON DELETE CASCADE',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [collectionId, seriesId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'collection_series';
  @override
  VerificationContext validateIntegrity(
    Insertable<CollectionSeriesRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('collection_id')) {
      context.handle(
        _collectionIdMeta,
        collectionId.isAcceptableOrUnknown(
          data['collection_id']!,
          _collectionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_collectionIdMeta);
    }
    if (data.containsKey('series_id')) {
      context.handle(
        _seriesIdMeta,
        seriesId.isAcceptableOrUnknown(data['series_id']!, _seriesIdMeta),
      );
    } else if (isInserting) {
      context.missing(_seriesIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {collectionId, seriesId};
  @override
  CollectionSeriesRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CollectionSeriesRow(
      collectionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}collection_id'],
      )!,
      seriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}series_id'],
      )!,
    );
  }

  @override
  $CollectionSeriesTable createAlias(String alias) {
    return $CollectionSeriesTable(attachedDatabase, alias);
  }
}

class CollectionSeriesRow extends DataClass
    implements Insertable<CollectionSeriesRow> {
  final int collectionId;
  final int seriesId;
  const CollectionSeriesRow({
    required this.collectionId,
    required this.seriesId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['collection_id'] = Variable<int>(collectionId);
    map['series_id'] = Variable<int>(seriesId);
    return map;
  }

  CollectionSeriesCompanion toCompanion(bool nullToAbsent) {
    return CollectionSeriesCompanion(
      collectionId: Value(collectionId),
      seriesId: Value(seriesId),
    );
  }

  factory CollectionSeriesRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CollectionSeriesRow(
      collectionId: serializer.fromJson<int>(json['collectionId']),
      seriesId: serializer.fromJson<int>(json['seriesId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'collectionId': serializer.toJson<int>(collectionId),
      'seriesId': serializer.toJson<int>(seriesId),
    };
  }

  CollectionSeriesRow copyWith({int? collectionId, int? seriesId}) =>
      CollectionSeriesRow(
        collectionId: collectionId ?? this.collectionId,
        seriesId: seriesId ?? this.seriesId,
      );
  CollectionSeriesRow copyWithCompanion(CollectionSeriesCompanion data) {
    return CollectionSeriesRow(
      collectionId: data.collectionId.present
          ? data.collectionId.value
          : this.collectionId,
      seriesId: data.seriesId.present ? data.seriesId.value : this.seriesId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CollectionSeriesRow(')
          ..write('collectionId: $collectionId, ')
          ..write('seriesId: $seriesId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(collectionId, seriesId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CollectionSeriesRow &&
          other.collectionId == this.collectionId &&
          other.seriesId == this.seriesId);
}

class CollectionSeriesCompanion extends UpdateCompanion<CollectionSeriesRow> {
  final Value<int> collectionId;
  final Value<int> seriesId;
  final Value<int> rowid;
  const CollectionSeriesCompanion({
    this.collectionId = const Value.absent(),
    this.seriesId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CollectionSeriesCompanion.insert({
    required int collectionId,
    required int seriesId,
    this.rowid = const Value.absent(),
  }) : collectionId = Value(collectionId),
       seriesId = Value(seriesId);
  static Insertable<CollectionSeriesRow> custom({
    Expression<int>? collectionId,
    Expression<int>? seriesId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (collectionId != null) 'collection_id': collectionId,
      if (seriesId != null) 'series_id': seriesId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CollectionSeriesCompanion copyWith({
    Value<int>? collectionId,
    Value<int>? seriesId,
    Value<int>? rowid,
  }) {
    return CollectionSeriesCompanion(
      collectionId: collectionId ?? this.collectionId,
      seriesId: seriesId ?? this.seriesId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (collectionId.present) {
      map['collection_id'] = Variable<int>(collectionId.value);
    }
    if (seriesId.present) {
      map['series_id'] = Variable<int>(seriesId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CollectionSeriesCompanion(')
          ..write('collectionId: $collectionId, ')
          ..write('seriesId: $seriesId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String key;
  final String value;
  const SettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory SettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingRow copyWith({String? key, String? value}) =>
      SettingRow(key: key ?? this.key, value: value ?? this.value);
  SettingRow copyWithCompanion(SettingsCompanion data) {
    return SettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<SettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReaderOverridesTable extends ReaderOverrides
    with TableInfo<$ReaderOverridesTable, ReaderOverrideRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReaderOverridesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seriesIdMeta = const VerificationMeta(
    'seriesId',
  );
  @override
  late final GeneratedColumn<int> seriesId = GeneratedColumn<int>(
    'series_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES series (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _zoomModeMeta = const VerificationMeta(
    'zoomMode',
  );
  @override
  late final GeneratedColumn<String> zoomMode = GeneratedColumn<String>(
    'zoom_mode',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _brightnessMeta = const VerificationMeta(
    'brightness',
  );
  @override
  late final GeneratedColumn<double> brightness = GeneratedColumn<double>(
    'brightness',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contrastMeta = const VerificationMeta(
    'contrast',
  );
  @override
  late final GeneratedColumn<double> contrast = GeneratedColumn<double>(
    'contrast',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _saturationMeta = const VerificationMeta(
    'saturation',
  );
  @override
  late final GeneratedColumn<double> saturation = GeneratedColumn<double>(
    'saturation',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<bool?, int> invert =
      GeneratedColumn<int>(
        'invert',
        aliasedName,
        true,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
      ).withConverter<bool?>($ReaderOverridesTable.$converterinvertn);
  @override
  List<GeneratedColumn> get $columns => [
    seriesId,
    direction,
    zoomMode,
    brightness,
    contrast,
    saturation,
    invert,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reader_overrides';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReaderOverrideRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('series_id')) {
      context.handle(
        _seriesIdMeta,
        seriesId.isAcceptableOrUnknown(data['series_id']!, _seriesIdMeta),
      );
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    }
    if (data.containsKey('zoom_mode')) {
      context.handle(
        _zoomModeMeta,
        zoomMode.isAcceptableOrUnknown(data['zoom_mode']!, _zoomModeMeta),
      );
    }
    if (data.containsKey('brightness')) {
      context.handle(
        _brightnessMeta,
        brightness.isAcceptableOrUnknown(data['brightness']!, _brightnessMeta),
      );
    }
    if (data.containsKey('contrast')) {
      context.handle(
        _contrastMeta,
        contrast.isAcceptableOrUnknown(data['contrast']!, _contrastMeta),
      );
    }
    if (data.containsKey('saturation')) {
      context.handle(
        _saturationMeta,
        saturation.isAcceptableOrUnknown(data['saturation']!, _saturationMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seriesId};
  @override
  ReaderOverrideRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReaderOverrideRow(
      seriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}series_id'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      ),
      zoomMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}zoom_mode'],
      ),
      brightness: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}brightness'],
      ),
      contrast: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}contrast'],
      ),
      saturation: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}saturation'],
      ),
      invert: $ReaderOverridesTable.$converterinvertn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}invert'],
        ),
      ),
    );
  }

  @override
  $ReaderOverridesTable createAlias(String alias) {
    return $ReaderOverridesTable(attachedDatabase, alias);
  }

  static TypeConverter<bool, int> $converterinvert = const BoolIntConverter();
  static TypeConverter<bool?, int?> $converterinvertn =
      NullAwareTypeConverter.wrap($converterinvert);
}

class ReaderOverrideRow extends DataClass
    implements Insertable<ReaderOverrideRow> {
  final int seriesId;
  final String? direction;
  final String? zoomMode;
  final double? brightness;
  final double? contrast;
  final double? saturation;
  final bool? invert;
  const ReaderOverrideRow({
    required this.seriesId,
    this.direction,
    this.zoomMode,
    this.brightness,
    this.contrast,
    this.saturation,
    this.invert,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['series_id'] = Variable<int>(seriesId);
    if (!nullToAbsent || direction != null) {
      map['direction'] = Variable<String>(direction);
    }
    if (!nullToAbsent || zoomMode != null) {
      map['zoom_mode'] = Variable<String>(zoomMode);
    }
    if (!nullToAbsent || brightness != null) {
      map['brightness'] = Variable<double>(brightness);
    }
    if (!nullToAbsent || contrast != null) {
      map['contrast'] = Variable<double>(contrast);
    }
    if (!nullToAbsent || saturation != null) {
      map['saturation'] = Variable<double>(saturation);
    }
    if (!nullToAbsent || invert != null) {
      map['invert'] = Variable<int>(
        $ReaderOverridesTable.$converterinvertn.toSql(invert),
      );
    }
    return map;
  }

  ReaderOverridesCompanion toCompanion(bool nullToAbsent) {
    return ReaderOverridesCompanion(
      seriesId: Value(seriesId),
      direction: direction == null && nullToAbsent
          ? const Value.absent()
          : Value(direction),
      zoomMode: zoomMode == null && nullToAbsent
          ? const Value.absent()
          : Value(zoomMode),
      brightness: brightness == null && nullToAbsent
          ? const Value.absent()
          : Value(brightness),
      contrast: contrast == null && nullToAbsent
          ? const Value.absent()
          : Value(contrast),
      saturation: saturation == null && nullToAbsent
          ? const Value.absent()
          : Value(saturation),
      invert: invert == null && nullToAbsent
          ? const Value.absent()
          : Value(invert),
    );
  }

  factory ReaderOverrideRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReaderOverrideRow(
      seriesId: serializer.fromJson<int>(json['seriesId']),
      direction: serializer.fromJson<String?>(json['direction']),
      zoomMode: serializer.fromJson<String?>(json['zoomMode']),
      brightness: serializer.fromJson<double?>(json['brightness']),
      contrast: serializer.fromJson<double?>(json['contrast']),
      saturation: serializer.fromJson<double?>(json['saturation']),
      invert: serializer.fromJson<bool?>(json['invert']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seriesId': serializer.toJson<int>(seriesId),
      'direction': serializer.toJson<String?>(direction),
      'zoomMode': serializer.toJson<String?>(zoomMode),
      'brightness': serializer.toJson<double?>(brightness),
      'contrast': serializer.toJson<double?>(contrast),
      'saturation': serializer.toJson<double?>(saturation),
      'invert': serializer.toJson<bool?>(invert),
    };
  }

  ReaderOverrideRow copyWith({
    int? seriesId,
    Value<String?> direction = const Value.absent(),
    Value<String?> zoomMode = const Value.absent(),
    Value<double?> brightness = const Value.absent(),
    Value<double?> contrast = const Value.absent(),
    Value<double?> saturation = const Value.absent(),
    Value<bool?> invert = const Value.absent(),
  }) => ReaderOverrideRow(
    seriesId: seriesId ?? this.seriesId,
    direction: direction.present ? direction.value : this.direction,
    zoomMode: zoomMode.present ? zoomMode.value : this.zoomMode,
    brightness: brightness.present ? brightness.value : this.brightness,
    contrast: contrast.present ? contrast.value : this.contrast,
    saturation: saturation.present ? saturation.value : this.saturation,
    invert: invert.present ? invert.value : this.invert,
  );
  ReaderOverrideRow copyWithCompanion(ReaderOverridesCompanion data) {
    return ReaderOverrideRow(
      seriesId: data.seriesId.present ? data.seriesId.value : this.seriesId,
      direction: data.direction.present ? data.direction.value : this.direction,
      zoomMode: data.zoomMode.present ? data.zoomMode.value : this.zoomMode,
      brightness: data.brightness.present
          ? data.brightness.value
          : this.brightness,
      contrast: data.contrast.present ? data.contrast.value : this.contrast,
      saturation: data.saturation.present
          ? data.saturation.value
          : this.saturation,
      invert: data.invert.present ? data.invert.value : this.invert,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReaderOverrideRow(')
          ..write('seriesId: $seriesId, ')
          ..write('direction: $direction, ')
          ..write('zoomMode: $zoomMode, ')
          ..write('brightness: $brightness, ')
          ..write('contrast: $contrast, ')
          ..write('saturation: $saturation, ')
          ..write('invert: $invert')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    seriesId,
    direction,
    zoomMode,
    brightness,
    contrast,
    saturation,
    invert,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReaderOverrideRow &&
          other.seriesId == this.seriesId &&
          other.direction == this.direction &&
          other.zoomMode == this.zoomMode &&
          other.brightness == this.brightness &&
          other.contrast == this.contrast &&
          other.saturation == this.saturation &&
          other.invert == this.invert);
}

class ReaderOverridesCompanion extends UpdateCompanion<ReaderOverrideRow> {
  final Value<int> seriesId;
  final Value<String?> direction;
  final Value<String?> zoomMode;
  final Value<double?> brightness;
  final Value<double?> contrast;
  final Value<double?> saturation;
  final Value<bool?> invert;
  const ReaderOverridesCompanion({
    this.seriesId = const Value.absent(),
    this.direction = const Value.absent(),
    this.zoomMode = const Value.absent(),
    this.brightness = const Value.absent(),
    this.contrast = const Value.absent(),
    this.saturation = const Value.absent(),
    this.invert = const Value.absent(),
  });
  ReaderOverridesCompanion.insert({
    this.seriesId = const Value.absent(),
    this.direction = const Value.absent(),
    this.zoomMode = const Value.absent(),
    this.brightness = const Value.absent(),
    this.contrast = const Value.absent(),
    this.saturation = const Value.absent(),
    this.invert = const Value.absent(),
  });
  static Insertable<ReaderOverrideRow> custom({
    Expression<int>? seriesId,
    Expression<String>? direction,
    Expression<String>? zoomMode,
    Expression<double>? brightness,
    Expression<double>? contrast,
    Expression<double>? saturation,
    Expression<int>? invert,
  }) {
    return RawValuesInsertable({
      if (seriesId != null) 'series_id': seriesId,
      if (direction != null) 'direction': direction,
      if (zoomMode != null) 'zoom_mode': zoomMode,
      if (brightness != null) 'brightness': brightness,
      if (contrast != null) 'contrast': contrast,
      if (saturation != null) 'saturation': saturation,
      if (invert != null) 'invert': invert,
    });
  }

  ReaderOverridesCompanion copyWith({
    Value<int>? seriesId,
    Value<String?>? direction,
    Value<String?>? zoomMode,
    Value<double?>? brightness,
    Value<double?>? contrast,
    Value<double?>? saturation,
    Value<bool?>? invert,
  }) {
    return ReaderOverridesCompanion(
      seriesId: seriesId ?? this.seriesId,
      direction: direction ?? this.direction,
      zoomMode: zoomMode ?? this.zoomMode,
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      saturation: saturation ?? this.saturation,
      invert: invert ?? this.invert,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seriesId.present) {
      map['series_id'] = Variable<int>(seriesId.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (zoomMode.present) {
      map['zoom_mode'] = Variable<String>(zoomMode.value);
    }
    if (brightness.present) {
      map['brightness'] = Variable<double>(brightness.value);
    }
    if (contrast.present) {
      map['contrast'] = Variable<double>(contrast.value);
    }
    if (saturation.present) {
      map['saturation'] = Variable<double>(saturation.value);
    }
    if (invert.present) {
      map['invert'] = Variable<int>(
        $ReaderOverridesTable.$converterinvertn.toSql(invert.value),
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReaderOverridesCompanion(')
          ..write('seriesId: $seriesId, ')
          ..write('direction: $direction, ')
          ..write('zoomMode: $zoomMode, ')
          ..write('brightness: $brightness, ')
          ..write('contrast: $contrast, ')
          ..write('saturation: $saturation, ')
          ..write('invert: $invert')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LibraryRootsTable libraryRoots = $LibraryRootsTable(this);
  late final $SeriesTable series = $SeriesTable(this);
  late final $ComicsTable comics = $ComicsTable(this);
  late final $ReadingProgressTable readingProgress = $ReadingProgressTable(
    this,
  );
  late final $BookmarksTable bookmarks = $BookmarksTable(this);
  late final $CollectionsTable collections = $CollectionsTable(this);
  late final $CollectionSeriesTable collectionSeries = $CollectionSeriesTable(
    this,
  );
  late final $SettingsTable settings = $SettingsTable(this);
  late final $ReaderOverridesTable readerOverrides = $ReaderOverridesTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    libraryRoots,
    series,
    comics,
    readingProgress,
    bookmarks,
    collections,
    collectionSeries,
    settings,
    readerOverrides,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'series',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('comics', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'library_roots',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('comics', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'comics',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reading_progress', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'comics',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('bookmarks', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'collections',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('collection_series', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'series',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('collection_series', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'series',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('reader_overrides', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$LibraryRootsTableCreateCompanionBuilder =
    LibraryRootsCompanion Function({
      Value<int> id,
      required String uri,
      required String displayName,
      Value<bool> autoScan,
      Value<int?> lastScanAt,
    });
typedef $$LibraryRootsTableUpdateCompanionBuilder =
    LibraryRootsCompanion Function({
      Value<int> id,
      Value<String> uri,
      Value<String> displayName,
      Value<bool> autoScan,
      Value<int?> lastScanAt,
    });

final class $$LibraryRootsTableReferences
    extends BaseReferences<_$AppDatabase, $LibraryRootsTable, LibraryRootRow> {
  $$LibraryRootsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ComicsTable, List<ComicRow>> _comicsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.comics,
    aliasName: 'library_roots__id__comics__root_id',
  );

  $$ComicsTableProcessedTableManager get comicsRefs {
    final manager = $$ComicsTableTableManager(
      $_db,
      $_db.comics,
    ).filter((f) => f.rootId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_comicsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LibraryRootsTableFilterComposer
    extends Composer<_$AppDatabase, $LibraryRootsTable> {
  $$LibraryRootsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uri => $composableBuilder(
    column: $table.uri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<bool, bool, int> get autoScan =>
      $composableBuilder(
        column: $table.autoScan,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get lastScanAt => $composableBuilder(
    column: $table.lastScanAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> comicsRefs(
    Expression<bool> Function($$ComicsTableFilterComposer f) f,
  ) {
    final $$ComicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.comics,
      getReferencedColumn: (t) => t.rootId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComicsTableFilterComposer(
            $db: $db,
            $table: $db.comics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LibraryRootsTableOrderingComposer
    extends Composer<_$AppDatabase, $LibraryRootsTable> {
  $$LibraryRootsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uri => $composableBuilder(
    column: $table.uri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get autoScan => $composableBuilder(
    column: $table.autoScan,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastScanAt => $composableBuilder(
    column: $table.lastScanAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LibraryRootsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LibraryRootsTable> {
  $$LibraryRootsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uri =>
      $composableBuilder(column: $table.uri, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<bool, int> get autoScan =>
      $composableBuilder(column: $table.autoScan, builder: (column) => column);

  GeneratedColumn<int> get lastScanAt => $composableBuilder(
    column: $table.lastScanAt,
    builder: (column) => column,
  );

  Expression<T> comicsRefs<T extends Object>(
    Expression<T> Function($$ComicsTableAnnotationComposer a) f,
  ) {
    final $$ComicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.comics,
      getReferencedColumn: (t) => t.rootId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComicsTableAnnotationComposer(
            $db: $db,
            $table: $db.comics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LibraryRootsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LibraryRootsTable,
          LibraryRootRow,
          $$LibraryRootsTableFilterComposer,
          $$LibraryRootsTableOrderingComposer,
          $$LibraryRootsTableAnnotationComposer,
          $$LibraryRootsTableCreateCompanionBuilder,
          $$LibraryRootsTableUpdateCompanionBuilder,
          (LibraryRootRow, $$LibraryRootsTableReferences),
          LibraryRootRow,
          PrefetchHooks Function({bool comicsRefs})
        > {
  $$LibraryRootsTableTableManager(_$AppDatabase db, $LibraryRootsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LibraryRootsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LibraryRootsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LibraryRootsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> uri = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<bool> autoScan = const Value.absent(),
                Value<int?> lastScanAt = const Value.absent(),
              }) => LibraryRootsCompanion(
                id: id,
                uri: uri,
                displayName: displayName,
                autoScan: autoScan,
                lastScanAt: lastScanAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String uri,
                required String displayName,
                Value<bool> autoScan = const Value.absent(),
                Value<int?> lastScanAt = const Value.absent(),
              }) => LibraryRootsCompanion.insert(
                id: id,
                uri: uri,
                displayName: displayName,
                autoScan: autoScan,
                lastScanAt: lastScanAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LibraryRootsTable, LibraryRootRow>(table),
                  $$LibraryRootsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({comicsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (comicsRefs) db.comics],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (comicsRefs)
                    await $_getPrefetchedDataByColumns<
                      LibraryRootRow,
                      $LibraryRootsTable,
                      ComicRow,
                      $ComicsTable
                    >(
                      currentTable: table,
                      referencedTable: $$LibraryRootsTableReferences
                          ._comicsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$LibraryRootsTableReferences(
                            db,
                            table,
                            p0,
                          ).comicsRefs,
                      currentColumn: 'id',
                      referencedColumn: 'root_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$LibraryRootsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LibraryRootsTable,
      LibraryRootRow,
      $$LibraryRootsTableFilterComposer,
      $$LibraryRootsTableOrderingComposer,
      $$LibraryRootsTableAnnotationComposer,
      $$LibraryRootsTableCreateCompanionBuilder,
      $$LibraryRootsTableUpdateCompanionBuilder,
      (LibraryRootRow, $$LibraryRootsTableReferences),
      LibraryRootRow,
      PrefetchHooks Function({bool comicsRefs})
    >;
typedef $$SeriesTableCreateCompanionBuilder =
    SeriesCompanion Function({
      Value<int> id,
      required String title,
      Value<String?> author,
      Value<ComicType> type,
      Value<bool> isFavourite,
      Value<bool> isCompleted,
      Value<int?> coverComicId,
      Value<bool> manualOverride,
      required int createdAt,
    });
typedef $$SeriesTableUpdateCompanionBuilder =
    SeriesCompanion Function({
      Value<int> id,
      Value<String> title,
      Value<String?> author,
      Value<ComicType> type,
      Value<bool> isFavourite,
      Value<bool> isCompleted,
      Value<int?> coverComicId,
      Value<bool> manualOverride,
      Value<int> createdAt,
    });

final class $$SeriesTableReferences
    extends BaseReferences<_$AppDatabase, $SeriesTable, SeriesRow> {
  $$SeriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$ComicsTable, List<ComicRow>> _comicsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.comics,
    aliasName: 'series__id__comics__series_id',
  );

  $$ComicsTableProcessedTableManager get comicsRefs {
    final manager = $$ComicsTableTableManager(
      $_db,
      $_db.comics,
    ).filter((f) => f.seriesId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_comicsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$CollectionSeriesTable, List<CollectionSeriesRow>>
  _collectionSeriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.collectionSeries,
    aliasName: 'series__id__collection_series__series_id',
  );

  $$CollectionSeriesTableProcessedTableManager get collectionSeriesRefs {
    final manager = $$CollectionSeriesTableTableManager(
      $_db,
      $_db.collectionSeries,
    ).filter((f) => f.seriesId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _collectionSeriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReaderOverridesTable, List<ReaderOverrideRow>>
  _readerOverridesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readerOverrides,
    aliasName: 'series__id__reader_overrides__series_id',
  );

  $$ReaderOverridesTableProcessedTableManager get readerOverridesRefs {
    final manager = $$ReaderOverridesTableTableManager(
      $_db,
      $_db.readerOverrides,
    ).filter((f) => f.seriesId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _readerOverridesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SeriesTableFilterComposer
    extends Composer<_$AppDatabase, $SeriesTable> {
  $$SeriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ComicType, ComicType, String> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<bool, bool, int> get isFavourite =>
      $composableBuilder(
        column: $table.isFavourite,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<bool, bool, int> get isCompleted =>
      $composableBuilder(
        column: $table.isCompleted,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get coverComicId => $composableBuilder(
    column: $table.coverComicId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<bool, bool, int> get manualOverride =>
      $composableBuilder(
        column: $table.manualOverride,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> comicsRefs(
    Expression<bool> Function($$ComicsTableFilterComposer f) f,
  ) {
    final $$ComicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.comics,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComicsTableFilterComposer(
            $db: $db,
            $table: $db.comics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> collectionSeriesRefs(
    Expression<bool> Function($$CollectionSeriesTableFilterComposer f) f,
  ) {
    final $$CollectionSeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.collectionSeries,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionSeriesTableFilterComposer(
            $db: $db,
            $table: $db.collectionSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> readerOverridesRefs(
    Expression<bool> Function($$ReaderOverridesTableFilterComposer f) f,
  ) {
    final $$ReaderOverridesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readerOverrides,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReaderOverridesTableFilterComposer(
            $db: $db,
            $table: $db.readerOverrides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SeriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SeriesTable> {
  $$SeriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get author => $composableBuilder(
    column: $table.author,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isFavourite => $composableBuilder(
    column: $table.isFavourite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coverComicId => $composableBuilder(
    column: $table.coverComicId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get manualOverride => $composableBuilder(
    column: $table.manualOverride,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SeriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SeriesTable> {
  $$SeriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ComicType, String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<bool, int> get isFavourite =>
      $composableBuilder(
        column: $table.isFavourite,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<bool, int> get isCompleted =>
      $composableBuilder(
        column: $table.isCompleted,
        builder: (column) => column,
      );

  GeneratedColumn<int> get coverComicId => $composableBuilder(
    column: $table.coverComicId,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<bool, int> get manualOverride =>
      $composableBuilder(
        column: $table.manualOverride,
        builder: (column) => column,
      );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> comicsRefs<T extends Object>(
    Expression<T> Function($$ComicsTableAnnotationComposer a) f,
  ) {
    final $$ComicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.comics,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComicsTableAnnotationComposer(
            $db: $db,
            $table: $db.comics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> collectionSeriesRefs<T extends Object>(
    Expression<T> Function($$CollectionSeriesTableAnnotationComposer a) f,
  ) {
    final $$CollectionSeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.collectionSeries,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionSeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.collectionSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> readerOverridesRefs<T extends Object>(
    Expression<T> Function($$ReaderOverridesTableAnnotationComposer a) f,
  ) {
    final $$ReaderOverridesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readerOverrides,
      getReferencedColumn: (t) => t.seriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReaderOverridesTableAnnotationComposer(
            $db: $db,
            $table: $db.readerOverrides,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SeriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SeriesTable,
          SeriesRow,
          $$SeriesTableFilterComposer,
          $$SeriesTableOrderingComposer,
          $$SeriesTableAnnotationComposer,
          $$SeriesTableCreateCompanionBuilder,
          $$SeriesTableUpdateCompanionBuilder,
          (SeriesRow, $$SeriesTableReferences),
          SeriesRow,
          PrefetchHooks Function({
            bool comicsRefs,
            bool collectionSeriesRefs,
            bool readerOverridesRefs,
          })
        > {
  $$SeriesTableTableManager(_$AppDatabase db, $SeriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SeriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SeriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SeriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> author = const Value.absent(),
                Value<ComicType> type = const Value.absent(),
                Value<bool> isFavourite = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int?> coverComicId = const Value.absent(),
                Value<bool> manualOverride = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => SeriesCompanion(
                id: id,
                title: title,
                author: author,
                type: type,
                isFavourite: isFavourite,
                isCompleted: isCompleted,
                coverComicId: coverComicId,
                manualOverride: manualOverride,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String title,
                Value<String?> author = const Value.absent(),
                Value<ComicType> type = const Value.absent(),
                Value<bool> isFavourite = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<int?> coverComicId = const Value.absent(),
                Value<bool> manualOverride = const Value.absent(),
                required int createdAt,
              }) => SeriesCompanion.insert(
                id: id,
                title: title,
                author: author,
                type: type,
                isFavourite: isFavourite,
                isCompleted: isCompleted,
                coverComicId: coverComicId,
                manualOverride: manualOverride,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SeriesTable, SeriesRow>(table),
                  $$SeriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                comicsRefs = false,
                collectionSeriesRefs = false,
                readerOverridesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (comicsRefs) db.comics,
                    if (collectionSeriesRefs) db.collectionSeries,
                    if (readerOverridesRefs) db.readerOverrides,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (comicsRefs)
                        await $_getPrefetchedDataByColumns<
                          SeriesRow,
                          $SeriesTable,
                          ComicRow,
                          $ComicsTable
                        >(
                          currentTable: table,
                          referencedTable: $$SeriesTableReferences
                              ._comicsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SeriesTableReferences(db, table, p0).comicsRefs,
                          currentColumn: 'id',
                          referencedColumn: 'series_id',
                          typedResults: items,
                        ),
                      if (collectionSeriesRefs)
                        await $_getPrefetchedDataByColumns<
                          SeriesRow,
                          $SeriesTable,
                          CollectionSeriesRow,
                          $CollectionSeriesTable
                        >(
                          currentTable: table,
                          referencedTable: $$SeriesTableReferences
                              ._collectionSeriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SeriesTableReferences(
                                db,
                                table,
                                p0,
                              ).collectionSeriesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'series_id',
                          typedResults: items,
                        ),
                      if (readerOverridesRefs)
                        await $_getPrefetchedDataByColumns<
                          SeriesRow,
                          $SeriesTable,
                          ReaderOverrideRow,
                          $ReaderOverridesTable
                        >(
                          currentTable: table,
                          referencedTable: $$SeriesTableReferences
                              ._readerOverridesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SeriesTableReferences(
                                db,
                                table,
                                p0,
                              ).readerOverridesRefs,
                          currentColumn: 'id',
                          referencedColumn: 'series_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SeriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SeriesTable,
      SeriesRow,
      $$SeriesTableFilterComposer,
      $$SeriesTableOrderingComposer,
      $$SeriesTableAnnotationComposer,
      $$SeriesTableCreateCompanionBuilder,
      $$SeriesTableUpdateCompanionBuilder,
      (SeriesRow, $$SeriesTableReferences),
      SeriesRow,
      PrefetchHooks Function({
        bool comicsRefs,
        bool collectionSeriesRefs,
        bool readerOverridesRefs,
      })
    >;
typedef $$ComicsTableCreateCompanionBuilder =
    ComicsCompanion Function({
      Value<int> id,
      Value<int?> seriesId,
      Value<int?> rootId,
      required String uri,
      required String fileName,
      required ComicFormat format,
      required int sizeBytes,
      Value<String?> contentHash,
      Value<double?> chapterNumber,
      Value<String?> chapterTitle,
      Value<int?> pageCount,
      Value<String?> coverCachePath,
      required int addedAt,
      Value<bool> missing,
    });
typedef $$ComicsTableUpdateCompanionBuilder =
    ComicsCompanion Function({
      Value<int> id,
      Value<int?> seriesId,
      Value<int?> rootId,
      Value<String> uri,
      Value<String> fileName,
      Value<ComicFormat> format,
      Value<int> sizeBytes,
      Value<String?> contentHash,
      Value<double?> chapterNumber,
      Value<String?> chapterTitle,
      Value<int?> pageCount,
      Value<String?> coverCachePath,
      Value<int> addedAt,
      Value<bool> missing,
    });

final class $$ComicsTableReferences
    extends BaseReferences<_$AppDatabase, $ComicsTable, ComicRow> {
  $$ComicsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SeriesTable _seriesIdTable(_$AppDatabase db) =>
      db.series.createAlias('comics__series_id__series__id');

  $$SeriesTableProcessedTableManager? get seriesId {
    final $_column = $_itemColumn<int>('series_id');
    if ($_column == null) return null;
    final manager = $$SeriesTableTableManager(
      $_db,
      $_db.series,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seriesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $LibraryRootsTable _rootIdTable(_$AppDatabase db) =>
      db.libraryRoots.createAlias('comics__root_id__library_roots__id');

  $$LibraryRootsTableProcessedTableManager? get rootId {
    final $_column = $_itemColumn<int>('root_id');
    if ($_column == null) return null;
    final manager = $$LibraryRootsTableTableManager(
      $_db,
      $_db.libraryRoots,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_rootIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ReadingProgressTable, List<ReadingProgressRow>>
  _readingProgressRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.readingProgress,
    aliasName: 'comics__id__reading_progress__comic_id',
  );

  $$ReadingProgressTableProcessedTableManager get readingProgressRefs {
    final manager = $$ReadingProgressTableTableManager(
      $_db,
      $_db.readingProgress,
    ).filter((f) => f.comicId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _readingProgressRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$BookmarksTable, List<BookmarkRow>>
  _bookmarksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.bookmarks,
    aliasName: 'comics__id__bookmarks__comic_id',
  );

  $$BookmarksTableProcessedTableManager get bookmarksRefs {
    final manager = $$BookmarksTableTableManager(
      $_db,
      $_db.bookmarks,
    ).filter((f) => f.comicId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_bookmarksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ComicsTableFilterComposer
    extends Composer<_$AppDatabase, $ComicsTable> {
  $$ComicsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get uri => $composableBuilder(
    column: $table.uri,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ComicFormat, ComicFormat, String> get format =>
      $composableBuilder(
        column: $table.format,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get chapterNumber => $composableBuilder(
    column: $table.chapterNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chapterTitle => $composableBuilder(
    column: $table.chapterTitle,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverCachePath => $composableBuilder(
    column: $table.coverCachePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<bool, bool, int> get missing =>
      $composableBuilder(
        column: $table.missing,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$SeriesTableFilterComposer get seriesId {
    final $$SeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.series,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableFilterComposer(
            $db: $db,
            $table: $db.series,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LibraryRootsTableFilterComposer get rootId {
    final $$LibraryRootsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootId,
      referencedTable: $db.libraryRoots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryRootsTableFilterComposer(
            $db: $db,
            $table: $db.libraryRoots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> readingProgressRefs(
    Expression<bool> Function($$ReadingProgressTableFilterComposer f) f,
  ) {
    final $$ReadingProgressTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingProgress,
      getReferencedColumn: (t) => t.comicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingProgressTableFilterComposer(
            $db: $db,
            $table: $db.readingProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> bookmarksRefs(
    Expression<bool> Function($$BookmarksTableFilterComposer f) f,
  ) {
    final $$BookmarksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarks,
      getReferencedColumn: (t) => t.comicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarksTableFilterComposer(
            $db: $db,
            $table: $db.bookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ComicsTableOrderingComposer
    extends Composer<_$AppDatabase, $ComicsTable> {
  $$ComicsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get uri => $composableBuilder(
    column: $table.uri,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get format => $composableBuilder(
    column: $table.format,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sizeBytes => $composableBuilder(
    column: $table.sizeBytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get chapterNumber => $composableBuilder(
    column: $table.chapterNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chapterTitle => $composableBuilder(
    column: $table.chapterTitle,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageCount => $composableBuilder(
    column: $table.pageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverCachePath => $composableBuilder(
    column: $table.coverCachePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get missing => $composableBuilder(
    column: $table.missing,
    builder: (column) => ColumnOrderings(column),
  );

  $$SeriesTableOrderingComposer get seriesId {
    final $$SeriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.series,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableOrderingComposer(
            $db: $db,
            $table: $db.series,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LibraryRootsTableOrderingComposer get rootId {
    final $$LibraryRootsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootId,
      referencedTable: $db.libraryRoots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryRootsTableOrderingComposer(
            $db: $db,
            $table: $db.libraryRoots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ComicsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComicsTable> {
  $$ComicsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get uri =>
      $composableBuilder(column: $table.uri, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ComicFormat, String> get format =>
      $composableBuilder(column: $table.format, builder: (column) => column);

  GeneratedColumn<int> get sizeBytes =>
      $composableBuilder(column: $table.sizeBytes, builder: (column) => column);

  GeneratedColumn<String> get contentHash => $composableBuilder(
    column: $table.contentHash,
    builder: (column) => column,
  );

  GeneratedColumn<double> get chapterNumber => $composableBuilder(
    column: $table.chapterNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get chapterTitle => $composableBuilder(
    column: $table.chapterTitle,
    builder: (column) => column,
  );

  GeneratedColumn<int> get pageCount =>
      $composableBuilder(column: $table.pageCount, builder: (column) => column);

  GeneratedColumn<String> get coverCachePath => $composableBuilder(
    column: $table.coverCachePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);

  GeneratedColumnWithTypeConverter<bool, int> get missing =>
      $composableBuilder(column: $table.missing, builder: (column) => column);

  $$SeriesTableAnnotationComposer get seriesId {
    final $$SeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.series,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.series,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$LibraryRootsTableAnnotationComposer get rootId {
    final $$LibraryRootsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.rootId,
      referencedTable: $db.libraryRoots,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LibraryRootsTableAnnotationComposer(
            $db: $db,
            $table: $db.libraryRoots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> readingProgressRefs<T extends Object>(
    Expression<T> Function($$ReadingProgressTableAnnotationComposer a) f,
  ) {
    final $$ReadingProgressTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.readingProgress,
      getReferencedColumn: (t) => t.comicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReadingProgressTableAnnotationComposer(
            $db: $db,
            $table: $db.readingProgress,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> bookmarksRefs<T extends Object>(
    Expression<T> Function($$BookmarksTableAnnotationComposer a) f,
  ) {
    final $$BookmarksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.bookmarks,
      getReferencedColumn: (t) => t.comicId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BookmarksTableAnnotationComposer(
            $db: $db,
            $table: $db.bookmarks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ComicsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComicsTable,
          ComicRow,
          $$ComicsTableFilterComposer,
          $$ComicsTableOrderingComposer,
          $$ComicsTableAnnotationComposer,
          $$ComicsTableCreateCompanionBuilder,
          $$ComicsTableUpdateCompanionBuilder,
          (ComicRow, $$ComicsTableReferences),
          ComicRow,
          PrefetchHooks Function({
            bool seriesId,
            bool rootId,
            bool readingProgressRefs,
            bool bookmarksRefs,
          })
        > {
  $$ComicsTableTableManager(_$AppDatabase db, $ComicsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComicsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComicsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComicsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> seriesId = const Value.absent(),
                Value<int?> rootId = const Value.absent(),
                Value<String> uri = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<ComicFormat> format = const Value.absent(),
                Value<int> sizeBytes = const Value.absent(),
                Value<String?> contentHash = const Value.absent(),
                Value<double?> chapterNumber = const Value.absent(),
                Value<String?> chapterTitle = const Value.absent(),
                Value<int?> pageCount = const Value.absent(),
                Value<String?> coverCachePath = const Value.absent(),
                Value<int> addedAt = const Value.absent(),
                Value<bool> missing = const Value.absent(),
              }) => ComicsCompanion(
                id: id,
                seriesId: seriesId,
                rootId: rootId,
                uri: uri,
                fileName: fileName,
                format: format,
                sizeBytes: sizeBytes,
                contentHash: contentHash,
                chapterNumber: chapterNumber,
                chapterTitle: chapterTitle,
                pageCount: pageCount,
                coverCachePath: coverCachePath,
                addedAt: addedAt,
                missing: missing,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> seriesId = const Value.absent(),
                Value<int?> rootId = const Value.absent(),
                required String uri,
                required String fileName,
                required ComicFormat format,
                required int sizeBytes,
                Value<String?> contentHash = const Value.absent(),
                Value<double?> chapterNumber = const Value.absent(),
                Value<String?> chapterTitle = const Value.absent(),
                Value<int?> pageCount = const Value.absent(),
                Value<String?> coverCachePath = const Value.absent(),
                required int addedAt,
                Value<bool> missing = const Value.absent(),
              }) => ComicsCompanion.insert(
                id: id,
                seriesId: seriesId,
                rootId: rootId,
                uri: uri,
                fileName: fileName,
                format: format,
                sizeBytes: sizeBytes,
                contentHash: contentHash,
                chapterNumber: chapterNumber,
                chapterTitle: chapterTitle,
                pageCount: pageCount,
                coverCachePath: coverCachePath,
                addedAt: addedAt,
                missing: missing,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ComicsTable, ComicRow>(table),
                  $$ComicsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                seriesId = false,
                rootId = false,
                readingProgressRefs = false,
                bookmarksRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (readingProgressRefs) db.readingProgress,
                    if (bookmarksRefs) db.bookmarks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (seriesId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.seriesId,
                                    referencedTable: $$ComicsTableReferences
                                        ._seriesIdTable(db),
                                    referencedColumn: $$ComicsTableReferences
                                        ._seriesIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (rootId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.rootId,
                                    referencedTable: $$ComicsTableReferences
                                        ._rootIdTable(db),
                                    referencedColumn: $$ComicsTableReferences
                                        ._rootIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (readingProgressRefs)
                        await $_getPrefetchedDataByColumns<
                          ComicRow,
                          $ComicsTable,
                          ReadingProgressRow,
                          $ReadingProgressTable
                        >(
                          currentTable: table,
                          referencedTable: $$ComicsTableReferences
                              ._readingProgressRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ComicsTableReferences(
                                db,
                                table,
                                p0,
                              ).readingProgressRefs,
                          currentColumn: 'id',
                          referencedColumn: 'comic_id',
                          typedResults: items,
                        ),
                      if (bookmarksRefs)
                        await $_getPrefetchedDataByColumns<
                          ComicRow,
                          $ComicsTable,
                          BookmarkRow,
                          $BookmarksTable
                        >(
                          currentTable: table,
                          referencedTable: $$ComicsTableReferences
                              ._bookmarksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ComicsTableReferences(
                                db,
                                table,
                                p0,
                              ).bookmarksRefs,
                          currentColumn: 'id',
                          referencedColumn: 'comic_id',
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ComicsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComicsTable,
      ComicRow,
      $$ComicsTableFilterComposer,
      $$ComicsTableOrderingComposer,
      $$ComicsTableAnnotationComposer,
      $$ComicsTableCreateCompanionBuilder,
      $$ComicsTableUpdateCompanionBuilder,
      (ComicRow, $$ComicsTableReferences),
      ComicRow,
      PrefetchHooks Function({
        bool seriesId,
        bool rootId,
        bool readingProgressRefs,
        bool bookmarksRefs,
      })
    >;
typedef $$ReadingProgressTableCreateCompanionBuilder =
    ReadingProgressCompanion Function({
      Value<int> comicId,
      Value<int> pageIndex,
      Value<double> scrollOffset,
      Value<double> percent,
      Value<bool> completed,
      required int lastReadAt,
      required int updatedAt,
    });
typedef $$ReadingProgressTableUpdateCompanionBuilder =
    ReadingProgressCompanion Function({
      Value<int> comicId,
      Value<int> pageIndex,
      Value<double> scrollOffset,
      Value<double> percent,
      Value<bool> completed,
      Value<int> lastReadAt,
      Value<int> updatedAt,
    });

final class $$ReadingProgressTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReadingProgressTable,
          ReadingProgressRow
        > {
  $$ReadingProgressTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ComicsTable _comicIdTable(_$AppDatabase db) =>
      db.comics.createAlias('reading_progress__comic_id__comics__id');

  $$ComicsTableProcessedTableManager get comicId {
    final $_column = $_itemColumn<int>('comic_id')!;

    final manager = $$ComicsTableTableManager(
      $_db,
      $_db.comics,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_comicIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReadingProgressTableFilterComposer
    extends Composer<_$AppDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get pageIndex => $composableBuilder(
    column: $table.pageIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get scrollOffset => $composableBuilder(
    column: $table.scrollOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get percent => $composableBuilder(
    column: $table.percent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<bool, bool, int> get completed =>
      $composableBuilder(
        column: $table.completed,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ComicsTableFilterComposer get comicId {
    final $$ComicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.comicId,
      referencedTable: $db.comics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComicsTableFilterComposer(
            $db: $db,
            $table: $db.comics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get pageIndex => $composableBuilder(
    column: $table.pageIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get scrollOffset => $composableBuilder(
    column: $table.scrollOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get percent => $composableBuilder(
    column: $table.percent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completed => $composableBuilder(
    column: $table.completed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ComicsTableOrderingComposer get comicId {
    final $$ComicsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.comicId,
      referencedTable: $db.comics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComicsTableOrderingComposer(
            $db: $db,
            $table: $db.comics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadingProgressTable> {
  $$ReadingProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get pageIndex =>
      $composableBuilder(column: $table.pageIndex, builder: (column) => column);

  GeneratedColumn<double> get scrollOffset => $composableBuilder(
    column: $table.scrollOffset,
    builder: (column) => column,
  );

  GeneratedColumn<double> get percent =>
      $composableBuilder(column: $table.percent, builder: (column) => column);

  GeneratedColumnWithTypeConverter<bool, int> get completed =>
      $composableBuilder(column: $table.completed, builder: (column) => column);

  GeneratedColumn<int> get lastReadAt => $composableBuilder(
    column: $table.lastReadAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ComicsTableAnnotationComposer get comicId {
    final $$ComicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.comicId,
      referencedTable: $db.comics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComicsTableAnnotationComposer(
            $db: $db,
            $table: $db.comics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReadingProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReadingProgressTable,
          ReadingProgressRow,
          $$ReadingProgressTableFilterComposer,
          $$ReadingProgressTableOrderingComposer,
          $$ReadingProgressTableAnnotationComposer,
          $$ReadingProgressTableCreateCompanionBuilder,
          $$ReadingProgressTableUpdateCompanionBuilder,
          (ReadingProgressRow, $$ReadingProgressTableReferences),
          ReadingProgressRow,
          PrefetchHooks Function({bool comicId})
        > {
  $$ReadingProgressTableTableManager(
    _$AppDatabase db,
    $ReadingProgressTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadingProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadingProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadingProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> comicId = const Value.absent(),
                Value<int> pageIndex = const Value.absent(),
                Value<double> scrollOffset = const Value.absent(),
                Value<double> percent = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                Value<int> lastReadAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
              }) => ReadingProgressCompanion(
                comicId: comicId,
                pageIndex: pageIndex,
                scrollOffset: scrollOffset,
                percent: percent,
                completed: completed,
                lastReadAt: lastReadAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> comicId = const Value.absent(),
                Value<int> pageIndex = const Value.absent(),
                Value<double> scrollOffset = const Value.absent(),
                Value<double> percent = const Value.absent(),
                Value<bool> completed = const Value.absent(),
                required int lastReadAt,
                required int updatedAt,
              }) => ReadingProgressCompanion.insert(
                comicId: comicId,
                pageIndex: pageIndex,
                scrollOffset: scrollOffset,
                percent: percent,
                completed: completed,
                lastReadAt: lastReadAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReadingProgressTable, ReadingProgressRow>(table),
                  $$ReadingProgressTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({comicId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (comicId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.comicId,
                                referencedTable:
                                    $$ReadingProgressTableReferences
                                        ._comicIdTable(db),
                                referencedColumn:
                                    $$ReadingProgressTableReferences
                                        ._comicIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReadingProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReadingProgressTable,
      ReadingProgressRow,
      $$ReadingProgressTableFilterComposer,
      $$ReadingProgressTableOrderingComposer,
      $$ReadingProgressTableAnnotationComposer,
      $$ReadingProgressTableCreateCompanionBuilder,
      $$ReadingProgressTableUpdateCompanionBuilder,
      (ReadingProgressRow, $$ReadingProgressTableReferences),
      ReadingProgressRow,
      PrefetchHooks Function({bool comicId})
    >;
typedef $$BookmarksTableCreateCompanionBuilder =
    BookmarksCompanion Function({
      Value<int> id,
      required int comicId,
      required int pageIndex,
      Value<double> scrollOffset,
      Value<String?> note,
      required int createdAt,
    });
typedef $$BookmarksTableUpdateCompanionBuilder =
    BookmarksCompanion Function({
      Value<int> id,
      Value<int> comicId,
      Value<int> pageIndex,
      Value<double> scrollOffset,
      Value<String?> note,
      Value<int> createdAt,
    });

final class $$BookmarksTableReferences
    extends BaseReferences<_$AppDatabase, $BookmarksTable, BookmarkRow> {
  $$BookmarksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ComicsTable _comicIdTable(_$AppDatabase db) =>
      db.comics.createAlias('bookmarks__comic_id__comics__id');

  $$ComicsTableProcessedTableManager get comicId {
    final $_column = $_itemColumn<int>('comic_id')!;

    final manager = $$ComicsTableTableManager(
      $_db,
      $_db.comics,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_comicIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$BookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get pageIndex => $composableBuilder(
    column: $table.pageIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get scrollOffset => $composableBuilder(
    column: $table.scrollOffset,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ComicsTableFilterComposer get comicId {
    final $$ComicsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.comicId,
      referencedTable: $db.comics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComicsTableFilterComposer(
            $db: $db,
            $table: $db.comics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get pageIndex => $composableBuilder(
    column: $table.pageIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get scrollOffset => $composableBuilder(
    column: $table.scrollOffset,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ComicsTableOrderingComposer get comicId {
    final $$ComicsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.comicId,
      referencedTable: $db.comics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComicsTableOrderingComposer(
            $db: $db,
            $table: $db.comics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BookmarksTable> {
  $$BookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get pageIndex =>
      $composableBuilder(column: $table.pageIndex, builder: (column) => column);

  GeneratedColumn<double> get scrollOffset => $composableBuilder(
    column: $table.scrollOffset,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ComicsTableAnnotationComposer get comicId {
    final $$ComicsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.comicId,
      referencedTable: $db.comics,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComicsTableAnnotationComposer(
            $db: $db,
            $table: $db.comics,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BookmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BookmarksTable,
          BookmarkRow,
          $$BookmarksTableFilterComposer,
          $$BookmarksTableOrderingComposer,
          $$BookmarksTableAnnotationComposer,
          $$BookmarksTableCreateCompanionBuilder,
          $$BookmarksTableUpdateCompanionBuilder,
          (BookmarkRow, $$BookmarksTableReferences),
          BookmarkRow,
          PrefetchHooks Function({bool comicId})
        > {
  $$BookmarksTableTableManager(_$AppDatabase db, $BookmarksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> comicId = const Value.absent(),
                Value<int> pageIndex = const Value.absent(),
                Value<double> scrollOffset = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => BookmarksCompanion(
                id: id,
                comicId: comicId,
                pageIndex: pageIndex,
                scrollOffset: scrollOffset,
                note: note,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int comicId,
                required int pageIndex,
                Value<double> scrollOffset = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required int createdAt,
              }) => BookmarksCompanion.insert(
                id: id,
                comicId: comicId,
                pageIndex: pageIndex,
                scrollOffset: scrollOffset,
                note: note,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$BookmarksTable, BookmarkRow>(table),
                  $$BookmarksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({comicId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (comicId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.comicId,
                                referencedTable: $$BookmarksTableReferences
                                    ._comicIdTable(db),
                                referencedColumn: $$BookmarksTableReferences
                                    ._comicIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$BookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BookmarksTable,
      BookmarkRow,
      $$BookmarksTableFilterComposer,
      $$BookmarksTableOrderingComposer,
      $$BookmarksTableAnnotationComposer,
      $$BookmarksTableCreateCompanionBuilder,
      $$BookmarksTableUpdateCompanionBuilder,
      (BookmarkRow, $$BookmarksTableReferences),
      BookmarkRow,
      PrefetchHooks Function({bool comicId})
    >;
typedef $$CollectionsTableCreateCompanionBuilder =
    CollectionsCompanion Function({
      Value<int> id,
      required String name,
      Value<int> sortOrder,
      required int createdAt,
    });
typedef $$CollectionsTableUpdateCompanionBuilder =
    CollectionsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> sortOrder,
      Value<int> createdAt,
    });

final class $$CollectionsTableReferences
    extends BaseReferences<_$AppDatabase, $CollectionsTable, CollectionRow> {
  $$CollectionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CollectionSeriesTable, List<CollectionSeriesRow>>
  _collectionSeriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.collectionSeries,
    aliasName: 'collections__id__collection_series__collection_id',
  );

  $$CollectionSeriesTableProcessedTableManager get collectionSeriesRefs {
    final manager = $$CollectionSeriesTableTableManager(
      $_db,
      $_db.collectionSeries,
    ).filter((f) => f.collectionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _collectionSeriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CollectionsTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> collectionSeriesRefs(
    Expression<bool> Function($$CollectionSeriesTableFilterComposer f) f,
  ) {
    final $$CollectionSeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.collectionSeries,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionSeriesTableFilterComposer(
            $db: $db,
            $table: $db.collectionSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CollectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CollectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionsTable> {
  $$CollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> collectionSeriesRefs<T extends Object>(
    Expression<T> Function($$CollectionSeriesTableAnnotationComposer a) f,
  ) {
    final $$CollectionSeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.collectionSeries,
      getReferencedColumn: (t) => t.collectionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionSeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.collectionSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CollectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectionsTable,
          CollectionRow,
          $$CollectionsTableFilterComposer,
          $$CollectionsTableOrderingComposer,
          $$CollectionsTableAnnotationComposer,
          $$CollectionsTableCreateCompanionBuilder,
          $$CollectionsTableUpdateCompanionBuilder,
          (CollectionRow, $$CollectionsTableReferences),
          CollectionRow,
          PrefetchHooks Function({bool collectionSeriesRefs})
        > {
  $$CollectionsTableTableManager(_$AppDatabase db, $CollectionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => CollectionsCompanion(
                id: id,
                name: name,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<int> sortOrder = const Value.absent(),
                required int createdAt,
              }) => CollectionsCompanion.insert(
                id: id,
                name: name,
                sortOrder: sortOrder,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CollectionsTable, CollectionRow>(table),
                  $$CollectionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({collectionSeriesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (collectionSeriesRefs) db.collectionSeries,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (collectionSeriesRefs)
                    await $_getPrefetchedDataByColumns<
                      CollectionRow,
                      $CollectionsTable,
                      CollectionSeriesRow,
                      $CollectionSeriesTable
                    >(
                      currentTable: table,
                      referencedTable: $$CollectionsTableReferences
                          ._collectionSeriesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CollectionsTableReferences(
                            db,
                            table,
                            p0,
                          ).collectionSeriesRefs,
                      currentColumn: 'id',
                      referencedColumn: 'collection_id',
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CollectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectionsTable,
      CollectionRow,
      $$CollectionsTableFilterComposer,
      $$CollectionsTableOrderingComposer,
      $$CollectionsTableAnnotationComposer,
      $$CollectionsTableCreateCompanionBuilder,
      $$CollectionsTableUpdateCompanionBuilder,
      (CollectionRow, $$CollectionsTableReferences),
      CollectionRow,
      PrefetchHooks Function({bool collectionSeriesRefs})
    >;
typedef $$CollectionSeriesTableCreateCompanionBuilder =
    CollectionSeriesCompanion Function({
      required int collectionId,
      required int seriesId,
      Value<int> rowid,
    });
typedef $$CollectionSeriesTableUpdateCompanionBuilder =
    CollectionSeriesCompanion Function({
      Value<int> collectionId,
      Value<int> seriesId,
      Value<int> rowid,
    });

final class $$CollectionSeriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CollectionSeriesTable,
          CollectionSeriesRow
        > {
  $$CollectionSeriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CollectionsTable _collectionIdTable(_$AppDatabase db) => db
      .collections
      .createAlias('collection_series__collection_id__collections__id');

  $$CollectionsTableProcessedTableManager get collectionId {
    final $_column = $_itemColumn<int>('collection_id')!;

    final manager = $$CollectionsTableTableManager(
      $_db,
      $_db.collections,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_collectionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SeriesTable _seriesIdTable(_$AppDatabase db) =>
      db.series.createAlias('collection_series__series_id__series__id');

  $$SeriesTableProcessedTableManager get seriesId {
    final $_column = $_itemColumn<int>('series_id')!;

    final manager = $$SeriesTableTableManager(
      $_db,
      $_db.series,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seriesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CollectionSeriesTableFilterComposer
    extends Composer<_$AppDatabase, $CollectionSeriesTable> {
  $$CollectionSeriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$CollectionsTableFilterComposer get collectionId {
    final $$CollectionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableFilterComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SeriesTableFilterComposer get seriesId {
    final $$SeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.series,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableFilterComposer(
            $db: $db,
            $table: $db.series,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollectionSeriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CollectionSeriesTable> {
  $$CollectionSeriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$CollectionsTableOrderingComposer get collectionId {
    final $$CollectionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableOrderingComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SeriesTableOrderingComposer get seriesId {
    final $$SeriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.series,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableOrderingComposer(
            $db: $db,
            $table: $db.series,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollectionSeriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CollectionSeriesTable> {
  $$CollectionSeriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$CollectionsTableAnnotationComposer get collectionId {
    final $$CollectionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.collectionId,
      referencedTable: $db.collections,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CollectionsTableAnnotationComposer(
            $db: $db,
            $table: $db.collections,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SeriesTableAnnotationComposer get seriesId {
    final $$SeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.series,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.series,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CollectionSeriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CollectionSeriesTable,
          CollectionSeriesRow,
          $$CollectionSeriesTableFilterComposer,
          $$CollectionSeriesTableOrderingComposer,
          $$CollectionSeriesTableAnnotationComposer,
          $$CollectionSeriesTableCreateCompanionBuilder,
          $$CollectionSeriesTableUpdateCompanionBuilder,
          (CollectionSeriesRow, $$CollectionSeriesTableReferences),
          CollectionSeriesRow,
          PrefetchHooks Function({bool collectionId, bool seriesId})
        > {
  $$CollectionSeriesTableTableManager(
    _$AppDatabase db,
    $CollectionSeriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CollectionSeriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CollectionSeriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CollectionSeriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> collectionId = const Value.absent(),
                Value<int> seriesId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CollectionSeriesCompanion(
                collectionId: collectionId,
                seriesId: seriesId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required int collectionId,
                required int seriesId,
                Value<int> rowid = const Value.absent(),
              }) => CollectionSeriesCompanion.insert(
                collectionId: collectionId,
                seriesId: seriesId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CollectionSeriesTable, CollectionSeriesRow>(
                    table,
                  ),
                  $$CollectionSeriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({collectionId = false, seriesId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (collectionId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.collectionId,
                                referencedTable:
                                    $$CollectionSeriesTableReferences
                                        ._collectionIdTable(db),
                                referencedColumn:
                                    $$CollectionSeriesTableReferences
                                        ._collectionIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (seriesId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.seriesId,
                                referencedTable:
                                    $$CollectionSeriesTableReferences
                                        ._seriesIdTable(db),
                                referencedColumn:
                                    $$CollectionSeriesTableReferences
                                        ._seriesIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CollectionSeriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CollectionSeriesTable,
      CollectionSeriesRow,
      $$CollectionSeriesTableFilterComposer,
      $$CollectionSeriesTableOrderingComposer,
      $$CollectionSeriesTableAnnotationComposer,
      $$CollectionSeriesTableCreateCompanionBuilder,
      $$CollectionSeriesTableUpdateCompanionBuilder,
      (CollectionSeriesRow, $$CollectionSeriesTableReferences),
      CollectionSeriesRow,
      PrefetchHooks Function({bool collectionId, bool seriesId})
    >;
typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          SettingRow,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            SettingRow,
            BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>,
          ),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, SettingRow>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      SettingRow,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (SettingRow, BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>),
      SettingRow,
      PrefetchHooks Function()
    >;
typedef $$ReaderOverridesTableCreateCompanionBuilder =
    ReaderOverridesCompanion Function({
      Value<int> seriesId,
      Value<String?> direction,
      Value<String?> zoomMode,
      Value<double?> brightness,
      Value<double?> contrast,
      Value<double?> saturation,
      Value<bool?> invert,
    });
typedef $$ReaderOverridesTableUpdateCompanionBuilder =
    ReaderOverridesCompanion Function({
      Value<int> seriesId,
      Value<String?> direction,
      Value<String?> zoomMode,
      Value<double?> brightness,
      Value<double?> contrast,
      Value<double?> saturation,
      Value<bool?> invert,
    });

final class $$ReaderOverridesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $ReaderOverridesTable,
          ReaderOverrideRow
        > {
  $$ReaderOverridesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SeriesTable _seriesIdTable(_$AppDatabase db) =>
      db.series.createAlias('reader_overrides__series_id__series__id');

  $$SeriesTableProcessedTableManager get seriesId {
    final $_column = $_itemColumn<int>('series_id')!;

    final manager = $$SeriesTableTableManager(
      $_db,
      $_db.series,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_seriesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReaderOverridesTableFilterComposer
    extends Composer<_$AppDatabase, $ReaderOverridesTable> {
  $$ReaderOverridesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get zoomMode => $composableBuilder(
    column: $table.zoomMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get brightness => $composableBuilder(
    column: $table.brightness,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get contrast => $composableBuilder(
    column: $table.contrast,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get saturation => $composableBuilder(
    column: $table.saturation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<bool?, bool, int> get invert =>
      $composableBuilder(
        column: $table.invert,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  $$SeriesTableFilterComposer get seriesId {
    final $$SeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.series,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableFilterComposer(
            $db: $db,
            $table: $db.series,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReaderOverridesTableOrderingComposer
    extends Composer<_$AppDatabase, $ReaderOverridesTable> {
  $$ReaderOverridesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get zoomMode => $composableBuilder(
    column: $table.zoomMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get brightness => $composableBuilder(
    column: $table.brightness,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get contrast => $composableBuilder(
    column: $table.contrast,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get saturation => $composableBuilder(
    column: $table.saturation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get invert => $composableBuilder(
    column: $table.invert,
    builder: (column) => ColumnOrderings(column),
  );

  $$SeriesTableOrderingComposer get seriesId {
    final $$SeriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.series,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableOrderingComposer(
            $db: $db,
            $table: $db.series,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReaderOverridesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReaderOverridesTable> {
  $$ReaderOverridesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<String> get zoomMode =>
      $composableBuilder(column: $table.zoomMode, builder: (column) => column);

  GeneratedColumn<double> get brightness => $composableBuilder(
    column: $table.brightness,
    builder: (column) => column,
  );

  GeneratedColumn<double> get contrast =>
      $composableBuilder(column: $table.contrast, builder: (column) => column);

  GeneratedColumn<double> get saturation => $composableBuilder(
    column: $table.saturation,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<bool?, int> get invert =>
      $composableBuilder(column: $table.invert, builder: (column) => column);

  $$SeriesTableAnnotationComposer get seriesId {
    final $$SeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.seriesId,
      referencedTable: $db.series,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.series,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReaderOverridesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReaderOverridesTable,
          ReaderOverrideRow,
          $$ReaderOverridesTableFilterComposer,
          $$ReaderOverridesTableOrderingComposer,
          $$ReaderOverridesTableAnnotationComposer,
          $$ReaderOverridesTableCreateCompanionBuilder,
          $$ReaderOverridesTableUpdateCompanionBuilder,
          (ReaderOverrideRow, $$ReaderOverridesTableReferences),
          ReaderOverrideRow,
          PrefetchHooks Function({bool seriesId})
        > {
  $$ReaderOverridesTableTableManager(
    _$AppDatabase db,
    $ReaderOverridesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReaderOverridesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReaderOverridesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReaderOverridesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> seriesId = const Value.absent(),
                Value<String?> direction = const Value.absent(),
                Value<String?> zoomMode = const Value.absent(),
                Value<double?> brightness = const Value.absent(),
                Value<double?> contrast = const Value.absent(),
                Value<double?> saturation = const Value.absent(),
                Value<bool?> invert = const Value.absent(),
              }) => ReaderOverridesCompanion(
                seriesId: seriesId,
                direction: direction,
                zoomMode: zoomMode,
                brightness: brightness,
                contrast: contrast,
                saturation: saturation,
                invert: invert,
              ),
          createCompanionCallback:
              ({
                Value<int> seriesId = const Value.absent(),
                Value<String?> direction = const Value.absent(),
                Value<String?> zoomMode = const Value.absent(),
                Value<double?> brightness = const Value.absent(),
                Value<double?> contrast = const Value.absent(),
                Value<double?> saturation = const Value.absent(),
                Value<bool?> invert = const Value.absent(),
              }) => ReaderOverridesCompanion.insert(
                seriesId: seriesId,
                direction: direction,
                zoomMode: zoomMode,
                brightness: brightness,
                contrast: contrast,
                saturation: saturation,
                invert: invert,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ReaderOverridesTable, ReaderOverrideRow>(table),
                  $$ReaderOverridesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({seriesId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (seriesId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.seriesId,
                                referencedTable:
                                    $$ReaderOverridesTableReferences
                                        ._seriesIdTable(db),
                                referencedColumn:
                                    $$ReaderOverridesTableReferences
                                        ._seriesIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReaderOverridesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReaderOverridesTable,
      ReaderOverrideRow,
      $$ReaderOverridesTableFilterComposer,
      $$ReaderOverridesTableOrderingComposer,
      $$ReaderOverridesTableAnnotationComposer,
      $$ReaderOverridesTableCreateCompanionBuilder,
      $$ReaderOverridesTableUpdateCompanionBuilder,
      (ReaderOverrideRow, $$ReaderOverridesTableReferences),
      ReaderOverrideRow,
      PrefetchHooks Function({bool seriesId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LibraryRootsTableTableManager get libraryRoots =>
      $$LibraryRootsTableTableManager(_db, _db.libraryRoots);
  $$SeriesTableTableManager get series =>
      $$SeriesTableTableManager(_db, _db.series);
  $$ComicsTableTableManager get comics =>
      $$ComicsTableTableManager(_db, _db.comics);
  $$ReadingProgressTableTableManager get readingProgress =>
      $$ReadingProgressTableTableManager(_db, _db.readingProgress);
  $$BookmarksTableTableManager get bookmarks =>
      $$BookmarksTableTableManager(_db, _db.bookmarks);
  $$CollectionsTableTableManager get collections =>
      $$CollectionsTableTableManager(_db, _db.collections);
  $$CollectionSeriesTableTableManager get collectionSeries =>
      $$CollectionSeriesTableTableManager(_db, _db.collectionSeries);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$ReaderOverridesTableTableManager get readerOverrides =>
      $$ReaderOverridesTableTableManager(_db, _db.readerOverrides);
}
