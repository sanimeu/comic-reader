import 'package:comic_reader/domain/models.dart';
import 'package:flutter_test/flutter_test.dart';

LibraryItem _item({double progress = 0, int current = 1, int total = 10}) =>
    LibraryItem(
      id: 'x',
      title: 'T',
      author: 'A',
      type: ComicType.manga,
      totalChapters: total,
      currentChapter: current,
      progress: progress,
      addedAt: DateTime(2026, 1, 1),
    );

void main() {
  test('status is derived from progress', () {
    expect(_item(progress: 0).status, ReadStatus.unread);
    expect(_item(progress: 0.3).status, ReadStatus.reading);
    expect(_item(progress: 1.0).status, ReadStatus.completed);
    expect(_item(progress: 1.0).isCompleted, isTrue);
  });

  test('percent is rounded and clamped', () {
    expect(_item(progress: 0.456).percent, 46);
    expect(_item(progress: 1.7).percent, 100);
    expect(_item(progress: -0.2).percent, 0);
  });

  test(
    'chaptersRead: unread 0, completed all, reading = current-1 clamped',
    () {
      expect(_item(progress: 0, total: 10).chaptersRead, 0);
      expect(_item(progress: 1, total: 10).chaptersRead, 10);
      expect(_item(progress: 0.5, current: 4, total: 10).chaptersRead, 3);
      expect(_item(progress: 0.5, current: 0, total: 10).chaptersRead, 0);
      expect(_item(progress: 0.5, current: 99, total: 10).chaptersRead, 10);
    },
  );

  test('copyWith changes only what is given', () {
    final a = _item(progress: 0.5, current: 4);
    final b = a.copyWith(isFavourite: true);
    expect(b.isFavourite, isTrue);
    expect(b.progress, 0.5);
    expect(b.currentChapter, 4);
    expect(b.id, a.id);
  });

  test('labels', () {
    expect(ComicType.unknown.label, 'Other');
    expect(ReadStatus.reading.label, 'Reading');
    expect(LibrarySort.recentlyRead.label, 'Recently read');
    expect(NavSection.favourites.label, 'Favourites');
  });
}
