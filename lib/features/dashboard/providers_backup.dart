import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/library_query.dart';
import '../../domain/models.dart';
import '../../domain/reading_stats.dart';
import 'sample/sample_library.dart';

// Notifier (not StateProvider) so this compiles on Riverpod 2.x and 3.x,
// matching the convention already used in glass_quality.dart.

class NavSectionNotifier extends Notifier<NavSection> {
  @override
  NavSection build() => NavSection.home;
  void select(NavSection section) => state = section;
}

final navSectionProvider = NotifierProvider<NavSectionNotifier, NavSection>(
  NavSectionNotifier.new,
);

class LibraryLayoutNotifier extends Notifier<LibraryLayout> {
  @override
  LibraryLayout build() => LibraryLayout.grid;
  void toggle() => state = state == LibraryLayout.grid
      ? LibraryLayout.list
      : LibraryLayout.grid;
}

final libraryLayoutProvider =
    NotifierProvider<LibraryLayoutNotifier, LibraryLayout>(
      LibraryLayoutNotifier.new,
    );

/// Source of truth for the UI. Seeded with SAMPLE data until the Phase 3
/// repository (database + folder scan) replaces [build].
class LibraryItemsNotifier extends Notifier<List<LibraryItem>> {
  @override
  List<LibraryItem> build() => buildSampleLibrary(DateTime.now());

  void toggleFavourite(String id) {
    state = [
      for (final i in state)
        i.id == id ? i.copyWith(isFavourite: !i.isFavourite) : i,
    ];
  }
}

final libraryItemsProvider =
    NotifierProvider<LibraryItemsNotifier, List<LibraryItem>>(
      LibraryItemsNotifier.new,
    );

class LibraryQueryNotifier extends Notifier<LibraryQuery> {
  @override
  LibraryQuery build() => const LibraryQuery();

  void setSearch(String value) => state = state.copyWith(search: value);

  void toggleType(ComicType type) {
    final next = <ComicType>{...state.types};
    if (!next.add(type)) next.remove(type);
    state = state.copyWith(types: next);
  }

  void setStatus(ReadStatus? status) => state = status == null
      ? state.copyWith(clearStatus: true)
      : state.copyWith(status: status);

  void setFavouritesOnly(bool value) =>
      state = state.copyWith(favouritesOnly: value);

  void setSort(LibrarySort sort) => state = state.copyWith(sort: sort);

  /// Clears type/status/favourites filters; keeps search text and sort.
  void clearFilters() =>
      state = LibraryQuery(search: state.search, sort: state.sort);

  /// Clears filters AND search text; keeps sort.
  void clearAll() => state = LibraryQuery(sort: state.sort);
}

final libraryQueryProvider =
    NotifierProvider<LibraryQueryNotifier, LibraryQuery>(
      LibraryQueryNotifier.new,
    );

final visibleItemsProvider = Provider<List<LibraryItem>>(
  (ref) => applyQuery(
    ref.watch(libraryItemsProvider),
    ref.watch(libraryQueryProvider),
  ),
);

final statsProvider = Provider<ReadingStats>(
  (ref) => computeStats(ref.watch(libraryItemsProvider)),
);

/// Series currently being read, most recently read first.
final continueReadingProvider = Provider<List<LibraryItem>>((ref) {
  final list =
      ref
          .watch(libraryItemsProvider)
          .where((i) => i.status == ReadStatus.reading)
          .toList()
        ..sort((a, b) => compareItems(a, b, LibrarySort.recentlyRead));
  return list;
});

final recentlyAddedProvider = Provider<List<LibraryItem>>(
  (ref) => applyQuery(
    ref.watch(libraryItemsProvider),
    const LibraryQuery(),
  ).take(10).toList(),
);

/// Anything with a last-read time, most recent first.
final historyProvider = Provider<List<LibraryItem>>((ref) {
  final list =
      ref
          .watch(libraryItemsProvider)
          .where((i) => i.lastReadAt != null)
          .toList()
        ..sort((a, b) => compareItems(a, b, LibrarySort.recentlyRead));
  return list;
});

final favouritesProvider = Provider<List<LibraryItem>>((ref) {
  final list =
      ref.watch(libraryItemsProvider).where((i) => i.isFavourite).toList()
        ..sort((a, b) => compareItems(a, b, LibrarySort.alphabetical));
  return list;
});

/// Smart collections (computed) followed by manual ones (sample for now).
final collectionsProvider = Provider<List<CollectionInfo>>((ref) {
  final items = ref.watch(libraryItemsProvider);
  final existing = {for (final i in items) i.id};
  return [
    CollectionInfo(
      id: 'smart-favourites',
      name: 'Favourites',
      itemIds: [
        for (final i in items)
          if (i.isFavourite) i.id,
      ],
      isSmart: true,
    ),
    CollectionInfo(
      id: 'smart-completed',
      name: 'Completed',
      itemIds: [
        for (final i in items)
          if (i.isCompleted) i.id,
      ],
      isSmart: true,
    ),
    for (final c in sampleManualCollections)
      CollectionInfo(
        id: c.id,
        name: c.name,
        itemIds: [
          for (final id in c.itemIds)
            if (existing.contains(id)) id,
        ],
      ),
  ];
});
