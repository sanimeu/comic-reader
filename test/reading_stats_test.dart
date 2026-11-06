import 'package:comic_reader/domain/models.dart';
import 'package:comic_reader/domain/reading_stats.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:comic_reader/data/db/app_database.dart';
import 'package:comic_reader/data/db/database_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:comic_reader/features/dashboard/providers.dart';

LibraryItem _i(
  String id,
  double progress,
  int current,
  int total, {
  bool fav = false,
}) => LibraryItem(
  id: id,
  title: id,
  author: 'A',
  type: ComicType.manga,
  totalChapters: total,
  currentChapter: current,
  progress: progress,
  addedAt: DateTime(2026, 1, 1),
  isFavourite: fav,
);

ProviderContainer _testContainer() {
  return ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWith((ref) {
        final db = AppDatabase(NativeDatabase.memory());
        ref.onDispose(db.close);
        return db;
      }),
    ],
  );
}

void main() {
  test(
    'empty library gives zeros and 0 overall progress (no divide by zero)',
    () {
      final s = computeStats(const <LibraryItem>[]);
      expect(s.seriesCount, 0);
      expect(s.totalChapters, 0);
      expect(s.overallProgress, 0);
    },
  );

  test('counts statuses, favourites and chapters', () {
    final s = computeStats([
      _i('a', 0, 1, 10),
      _i('b', 0.5, 4, 20, fav: true), // 3 chapters read
      _i('c', 1.0, 30, 30, fav: true), // 30 read
    ]);
    expect(s.seriesCount, 3);
    expect(s.unread, 1);
    expect(s.reading, 1);
    expect(s.completed, 1);
    expect(s.favourites, 2);
    expect(s.chaptersRead, 33);
    expect(s.totalChapters, 60);
    expect(s.overallProgress, closeTo(0.55, 1e-9));
  });

  test(
    'providers: favourite toggle flows into stats; search flows into visible items',
    () async {
      final c = _testContainer();
      addTearDown(c.dispose);
      c.read(libraryItemsProvider);
      await c.read(libraryItemsProvider.notifier).waitForLoad();
      final before = c.read(statsProvider).favourites;
      final wasFav = c
          .read(libraryItemsProvider)
          .firstWhere((i) => i.id == 'sample-1')
          .isFavourite;
      c.read(libraryItemsProvider.notifier).toggleFavourite('sample-1');
      final after = c.read(statsProvider).favourites;
      expect(after, wasFav ? before - 1 : before + 1);

      c.read(libraryQueryProvider.notifier).setSearch('lotus');
      final visible = c.read(visibleItemsProvider);
      expect(visible.map((e) => e.title), ['Iron Lotus Chronicles']);

      c.read(libraryQueryProvider.notifier).clearAll();
      expect(
        c.read(visibleItemsProvider).length,
        c.read(libraryItemsProvider).length,
      );
    },
  );

  test(
    'providers: continue-reading only has items in progress; history only has read items',
    () async {
      final c = _testContainer();
      addTearDown(c.dispose);
      c.read(libraryItemsProvider);
      await c.read(libraryItemsProvider.notifier).waitForLoad();
      expect(
        c
            .read(continueReadingProvider)
            .every((i) => i.status == ReadStatus.reading),
        isTrue,
      );
      expect(
        c.read(historyProvider).every((i) => i.lastReadAt != null),
        isTrue,
      );
      expect(c.read(continueReadingProvider), isNotEmpty);
    },
  );
}
