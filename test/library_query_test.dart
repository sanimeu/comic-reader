import 'package:comic_reader/domain/library_query.dart';
import 'package:comic_reader/domain/models.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 6, 1);

LibraryItem _i(
  String id,
  String title, {
  String author = 'Anon',
  ComicType type = ComicType.manga,
  double progress = 0,
  int addedDaysAgo = 10,
  int? readDaysAgo,
  bool fav = false,
}) => LibraryItem(
  id: id,
  title: title,
  author: author,
  type: type,
  totalChapters: 10,
  currentChapter: 1,
  progress: progress,
  addedAt: _now.subtract(Duration(days: addedDaysAgo)),
  lastReadAt: readDaysAgo == null
      ? null
      : _now.subtract(Duration(days: readDaysAgo)),
  isFavourite: fav,
);

void main() {
  final items = [
    _i(
      '1',
      'Chapter 10 Heroes',
      author: 'Kim',
      type: ComicType.manhwa,
      progress: 0.5,
      addedDaysAgo: 3,
      readDaysAgo: 1,
      fav: true,
    ),
    _i(
      '2',
      'Chapter 2 Heroes',
      author: 'Sato',
      type: ComicType.manga,
      progress: 1.0,
      addedDaysAgo: 30,
      readDaysAgo: 5,
    ),
    _i(
      '3',
      'Zeta Tales',
      author: 'Li',
      type: ComicType.manhua,
      progress: 0,
      addedDaysAgo: 1,
    ),
    _i(
      '4',
      'alpha Tales',
      author: 'Kim',
      type: ComicType.manga,
      progress: 0.2,
      addedDaysAgo: 20,
      readDaysAgo: 2,
    ),
  ];

  List<String> ids(LibraryQuery q) =>
      applyQuery(items, q).map((e) => e.id).toList();

  test('search: every token must match title or author, case-insensitive', () {
    expect(ids(const LibraryQuery(search: 'tales')).toSet(), {'3', '4'});
    expect(ids(const LibraryQuery(search: 'TALES kim')), ['4']);
    expect(ids(const LibraryQuery(search: '  ')).length, 4);
    expect(ids(const LibraryQuery(search: 'nomatch')), isEmpty);
  });

  test('type filter: empty = all, otherwise any selected type', () {
    expect(ids(const LibraryQuery()).length, 4);
    expect(ids(const LibraryQuery(types: {ComicType.manga})).toSet(), {
      '2',
      '4',
    });
    expect(
      ids(
        const LibraryQuery(types: {ComicType.manga, ComicType.manhua}),
      ).toSet(),
      {'2', '3', '4'},
    );
  });

  test('status and favourites filters combine with search and type', () {
    expect(ids(const LibraryQuery(status: ReadStatus.reading)).toSet(), {
      '1',
      '4',
    });
    expect(ids(const LibraryQuery(favouritesOnly: true)), ['1']);
    expect(
      ids(
        const LibraryQuery(
          status: ReadStatus.reading,
          types: {ComicType.manga},
        ),
      ),
      ['4'],
    );
    expect(
      ids(
        const LibraryQuery(search: 'kim', status: ReadStatus.reading),
      ).toSet(),
      {'1', '4'},
    );
  });

  test('recentlyAdded: newest first', () {
    expect(ids(const LibraryQuery(sort: LibrarySort.recentlyAdded)), [
      '3',
      '1',
      '4',
      '2',
    ]);
  });

  test('recentlyRead: most recent first, never-read last', () {
    expect(ids(const LibraryQuery(sort: LibrarySort.recentlyRead)), [
      '1',
      '4',
      '2',
      '3',
    ]);
  });

  test('alphabetical uses natural order (2 before 10), case-insensitive', () {
    expect(ids(const LibraryQuery(sort: LibrarySort.alphabetical)), [
      '4',
      '2',
      '1',
      '3',
    ]);
  });

  test('ties are deterministic (title, then id)', () {
    final twins = [
      _i('b', 'Same', addedDaysAgo: 5),
      _i('a', 'Same', addedDaysAgo: 5),
    ];
    final out = applyQuery(
      twins,
      const LibraryQuery(),
    ).map((e) => e.id).toList();
    expect(out, ['a', 'b']);
  });

  test('hasActiveFilters ignores search and sort', () {
    expect(
      const LibraryQuery(
        search: 'x',
        sort: LibrarySort.alphabetical,
      ).hasActiveFilters,
      isFalse,
    );
    expect(const LibraryQuery(favouritesOnly: true).hasActiveFilters, isTrue);
    expect(
      const LibraryQuery(types: {ComicType.manga}).hasActiveFilters,
      isTrue,
    );
    expect(
      const LibraryQuery(status: ReadStatus.unread).hasActiveFilters,
      isTrue,
    );
  });

  test('copyWith(clearStatus) removes the status filter', () {
    final q = const LibraryQuery(
      status: ReadStatus.reading,
    ).copyWith(clearStatus: true);
    expect(q.status, isNull);
  });
}
