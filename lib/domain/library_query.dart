import 'models.dart';
import 'natural_sort.dart';

/// Search + filters + sort, applied together (spec section 10).
class LibraryQuery {
  const LibraryQuery({
    this.search = '',
    this.types = const <ComicType>{},
    this.status,
    this.favouritesOnly = false,
    this.sort = LibrarySort.recentlyAdded,
  });

  final String search;

  /// Empty set means "all types".
  final Set<ComicType> types;

  /// null means "all statuses".
  final ReadStatus? status;
  final bool favouritesOnly;
  final LibrarySort sort;

  bool get hasActiveFilters =>
      types.isNotEmpty || status != null || favouritesOnly;

  LibraryQuery copyWith({
    String? search,
    Set<ComicType>? types,
    ReadStatus? status,
    bool clearStatus = false,
    bool? favouritesOnly,
    LibrarySort? sort,
  }) => LibraryQuery(
    search: search ?? this.search,
    types: types ?? this.types,
    status: clearStatus ? null : (status ?? this.status),
    favouritesOnly: favouritesOnly ?? this.favouritesOnly,
    sort: sort ?? this.sort,
  );
}

bool matchesSearch(LibraryItem item, String search) {
  final tokens = search
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((t) => t.isNotEmpty)
      .toList();
  if (tokens.isEmpty) return true;
  final haystack = '${item.title} ${item.author}'.toLowerCase();
  return tokens.every(haystack.contains);
}

List<LibraryItem> applyQuery(Iterable<LibraryItem> items, LibraryQuery q) {
  final out = items.where((i) {
    if (!matchesSearch(i, q.search)) return false;
    if (q.types.isNotEmpty && !q.types.contains(i.type)) return false;
    if (q.status != null && i.status != q.status) return false;
    if (q.favouritesOnly && !i.isFavourite) return false;
    return true;
  }).toList();
  out.sort((a, b) => compareItems(a, b, q.sort));
  return out;
}

int compareItems(LibraryItem a, LibraryItem b, LibrarySort sort) {
  int c;
  switch (sort) {
    case LibrarySort.recentlyAdded:
      c = b.addedAt.compareTo(a.addedAt);
    case LibrarySort.recentlyRead:
      final x = a.lastReadAt, y = b.lastReadAt;
      if (x == null && y == null) {
        c = 0;
      } else if (x == null) {
        c = 1; // never-read items go last
      } else if (y == null) {
        c = -1;
      } else {
        c = y.compareTo(x);
      }
    case LibrarySort.alphabetical:
      c = naturalCompare(a.title, b.title);
  }
  if (c != 0) return c;
  c = naturalCompare(a.title, b.title);
  if (c != 0) return c;
  return a.id.compareTo(b.id); // deterministic
}
