import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';

import '../../data/db/app_database.dart';
import '../../data/db/database_provider.dart';
import '../../domain/library_query.dart';
import '../../domain/models.dart';
import '../../domain/reading_stats.dart';
import 'sample/sample_library.dart';

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

  void toggle() {
    state = state == LibraryLayout.grid
        ? LibraryLayout.list
        : LibraryLayout.grid;
  }
}

final libraryLayoutProvider =
    NotifierProvider<LibraryLayoutNotifier, LibraryLayout>(
      LibraryLayoutNotifier.new,
    );

/// Database-backed source of truth for the dashboard.
class LibraryItemsNotifier extends Notifier<List<LibraryItem>> {
  bool _disposed = false;
  Future<void>? _loadFuture;

  @override
  List<LibraryItem> build() {
    _disposed = false;

    ref.onDispose(() {
      _disposed = true;
    });

    // Keep the first-run demo usable before a library has been imported.
    // This also gives pure ProviderContainer consumers deterministic data
    // without requiring Flutter's path-provider platform channel.
    final sampleItems = buildSampleLibrary(DateTime.now());

    // Opening the persistent database is best-effort here: tests and previews
    // may run without a platform directory plugin. Imports can still explicitly
    // call refresh() once the app is running on a supported platform.
    try {
      final db = ref.watch(appDatabaseProvider);
      _loadFuture = _load(db);
    } catch (error, stackTrace) {
      debugPrint('Database unavailable; showing sample library: $error');
      debugPrint('$stackTrace');
    }

    return sampleItems;
  }

  Future<void> _load(AppDatabase db) async {
    try {
      final items = await db.loadLibraryItems();

      // An empty database represents a first launch. Keep the clearly-labelled
      // sample library visible until the user imports their own comics.
      if (!_disposed && items.isNotEmpty) {
        state = items;
      }
    } catch (error, stackTrace) {
      debugPrint('Library loading failed: $error');
      debugPrint('$stackTrace');
    }
  }

  /// Waits for the initial database load to finish.
  /// Primarily useful for tests that must keep the database alive until
  /// asynchronous loading has completed.
  Future<void> waitForLoad() async {
    final pending = _loadFuture;
    if (pending != null) {
      await pending;
    }
  }

  /// Reload library after importing comics or changing database records.
  Future<void> refresh() async {
    final db = ref.read(appDatabaseProvider);
    await _load(db);
  }

  /// Updates the UI immediately and persists the favourite in SQLite.
  Future<void> toggleFavourite(String id) async {
    final seriesId = int.tryParse(id);

    final index = state.indexWhere((item) => item.id == id);
    if (index == -1) return;

    final oldItem = state[index];
    final newValue = !oldItem.isFavourite;

    state = [
      for (final item in state)
        if (item.id == id) item.copyWith(isFavourite: newValue) else item,
    ];

    // Demo sample IDs are intentionally in-memory only.
    if (seriesId == null) return;

    try {
      final db = ref.read(appDatabaseProvider);

      await (db.update(db.series)..where((row) => row.id.equals(seriesId)))
          .write(SeriesCompanion(isFavourite: Value(newValue)));
    } catch (error, stackTrace) {
      debugPrint('Favourite update failed: $error');
      debugPrint('$stackTrace');

      await refresh();
    }
  }
}

final libraryItemsProvider =
    NotifierProvider<LibraryItemsNotifier, List<LibraryItem>>(
      LibraryItemsNotifier.new,
    );

class LibraryQueryNotifier extends Notifier<LibraryQuery> {
  @override
  LibraryQuery build() => const LibraryQuery();

  void setSearch(String value) {
    state = state.copyWith(search: value);
  }

  void toggleType(ComicType type) {
    final next = <ComicType>{...state.types};

    if (!next.add(type)) {
      next.remove(type);
    }

    state = state.copyWith(types: next);
  }

  void setStatus(ReadStatus? status) {
    state = status == null
        ? state.copyWith(clearStatus: true)
        : state.copyWith(status: status);
  }

  void setFavouritesOnly(bool value) {
    state = state.copyWith(favouritesOnly: value);
  }

  void setSort(LibrarySort sort) {
    state = state.copyWith(sort: sort);
  }

  void clearFilters() {
    state = LibraryQuery(search: state.search, sort: state.sort);
  }

  void clearAll() {
    state = LibraryQuery(sort: state.sort);
  }
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

final continueReadingProvider = Provider<List<LibraryItem>>((ref) {
  final list =
      ref
          .watch(libraryItemsProvider)
          .where((item) => item.status == ReadStatus.reading)
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

final historyProvider = Provider<List<LibraryItem>>((ref) {
  final list =
      ref
          .watch(libraryItemsProvider)
          .where((item) => item.lastReadAt != null)
          .toList()
        ..sort((a, b) => compareItems(a, b, LibrarySort.recentlyRead));

  return list;
});

final favouritesProvider = Provider<List<LibraryItem>>((ref) {
  final list =
      ref.watch(libraryItemsProvider).where((item) => item.isFavourite).toList()
        ..sort((a, b) => compareItems(a, b, LibrarySort.alphabetical));

  return list;
});

/// Smart collections followed by the existing sample manual collections.
final collectionsProvider = Provider<List<CollectionInfo>>((ref) {
  final items = ref.watch(libraryItemsProvider);
  final existing = {for (final item in items) item.id};

  return [
    CollectionInfo(
      id: 'smart-favourites',
      name: 'Favourites',
      itemIds: [
        for (final item in items)
          if (item.isFavourite) item.id,
      ],
      isSmart: true,
    ),
    CollectionInfo(
      id: 'smart-completed',
      name: 'Completed',
      itemIds: [
        for (final item in items)
          if (item.isCompleted) item.id,
      ],
      isSmart: true,
    ),
    for (final collection in sampleManualCollections)
      CollectionInfo(
        id: collection.id,
        name: collection.name,
        itemIds: [
          for (final id in collection.itemIds)
            if (existing.contains(id)) id,
        ],
      ),
  ];
});
