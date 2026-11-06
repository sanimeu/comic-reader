import 'package:comic_reader/data/db/library_mapper.dart';
import 'package:comic_reader/domain/models.dart';
import 'package:flutter_test/flutter_test.dart';

/// A chapter WITH a reading_progress row.
ChapterSnapshot _c(
  int id, {
  double? number,
  String? name,
  double percent = 0,
  bool completed = false,
  int page = 0,
  int read = 0,
}) => ChapterSnapshot(
  id: id,
  fileName: name ?? 'ch$id.cbz',
  chapterNumber: number,
  progress: ChapterProgressSnapshot(
    percent: percent,
    completed: completed,
    pageIndex: page,
    lastReadAtMs: read,
  ),
);

/// A chapter with no reading_progress row at all.
ChapterSnapshot _fresh(int id, {double? number, String? name}) =>
    ChapterSnapshot(
      id: id,
      fileName: name ?? 'ch$id.cbz',
      chapterNumber: number,
    );

void main() {
  group('chapter ordering', () {
    test(
      'numbered chapters ascending (incl. decimals), unnumbered last in natural file order',
      () {
        final out = orderChapters([
          _fresh(1, number: 10),
          _fresh(2, name: 'Extra 10.cbz'),
          _fresh(3, number: 1.5),
          _fresh(4, name: 'Extra 2.cbz'),
          _fresh(5, number: 2),
        ]).map((e) => e.id).toList();
        expect(out, [3, 5, 1, 4, 2]);
      },
    );

    test('ties fall back to file name, then id (deterministic)', () {
      final out = orderChapters([
        _fresh(9, number: 1, name: 'b.cbz'),
        _fresh(8, number: 1, name: 'a.cbz'),
        _fresh(7, number: 1, name: 'a.cbz'),
      ]).map((e) => e.id).toList();
      expect(out, [7, 8, 9]);
    });
  });

  group('deriveSeries', () {
    test(
      'no comics: zero chapters, unread, current chapter 1, no last read',
      () {
        final d = deriveSeries(markedCompleted: false, chapters: const []);
        expect(d.totalChapters, 0);
        expect(d.progress, 0);
        expect(d.currentChapter, 1);
        expect(d.lastReadAtMs, isNull);
      },
    );

    test(
      'chapter count is the number of comics, with or without progress rows',
      () {
        final d = deriveSeries(
          markedCompleted: false,
          chapters: [_fresh(1), _fresh(2), _fresh(3)],
        );
        expect(d.totalChapters, 3);
        expect(d.progress, 0);
        expect(d.currentChapter, 1);
      },
    );

    test(
      'reading: completed + partial chapters give a fractional series progress',
      () {
        final d = deriveSeries(
          markedCompleted: false,
          chapters: [
            _c(1, number: 1, completed: true, read: 100),
            _c(2, number: 2, percent: 0.5, page: 4, read: 200),
            _fresh(3, number: 3),
            _fresh(4, number: 4),
          ],
        );
        expect(d.totalChapters, 4);
        expect(d.progress, closeTo(0.375, 1e-9)); // (1 + 0.5) / 4
        expect(d.currentChapter, 2);
        expect(d.lastReadAtMs, 200);
      },
    );

    test(
      'nothing in progress: current chapter is the first one not completed',
      () {
        final d = deriveSeries(
          markedCompleted: false,
          chapters: [
            _c(1, number: 1, completed: true, read: 1),
            _c(2, number: 2, completed: true, read: 2),
            _fresh(3, number: 3),
            _fresh(4, number: 4),
          ],
        );
        expect(d.progress, closeTo(0.5, 1e-9));
        expect(d.currentChapter, 3);
      },
    );

    test('several chapters in progress: the most recently read one wins', () {
      final d = deriveSeries(
        markedCompleted: false,
        chapters: [
          _c(1, number: 1, percent: 0.2, page: 1, read: 100),
          _c(2, number: 2, percent: 0.2, page: 1, read: 300),
          _c(3, number: 3, percent: 0.2, page: 1, read: 200),
        ],
      );
      expect(d.currentChapter, 2);
      expect(d.lastReadAtMs, 300);
    });

    test(
      'all chapters completed: progress 1.0, current chapter is the last',
      () {
        final d = deriveSeries(
          markedCompleted: false,
          chapters: [
            _c(1, number: 1, completed: true, read: 1),
            _c(2, number: 2, completed: true, read: 2),
          ],
        );
        expect(d.progress, 1.0);
        expect(d.currentChapter, 2);
      },
    );

    test(
      'series.is_completed is a manual override: forces 100% without any progress rows',
      () {
        final d = deriveSeries(
          markedCompleted: true,
          chapters: [_fresh(1), _fresh(2), _fresh(3)],
        );
        expect(d.progress, 1.0);
        expect(d.currentChapter, 3);
        expect(d.totalChapters, 3);
      },
    );

    test(
      'percent is clamped to 0..1 and a completed flag wins over percent',
      () {
        final d = deriveSeries(
          markedCompleted: false,
          chapters: [
            _c(1, number: 1, percent: 1.7, page: 1, read: 1),
            _c(2, number: 2, percent: -0.2, page: 1, read: 2),
            _c(3, number: 3, percent: 0.1, completed: true, read: 3),
          ],
        );
        expect(d.progress, closeTo((1.0 + 0.0 + 1.0) / 3, 1e-9));
      },
    );

    test(
      'a progress row that was never started (0%, page 0) does not count as in progress',
      () {
        final d = deriveSeries(
          markedCompleted: false,
          chapters: [
            _c(1, number: 1, completed: true, read: 1),
            _c(2, number: 2, percent: 0, page: 0, read: 50),
          ],
        );
        expect(d.currentChapter, 2); // first not completed, not "in progress"
      },
    );
  });

  group('buildLibraryItem', () {
    test(
      'maps ids, defaults and derived values onto the existing LibraryItem model',
      () {
        final item = buildLibraryItem(
          seriesId: 42,
          title: 'Night Shift',
          author: null,
          type: ComicType.manhwa,
          isFavourite: true,
          isCompleted: false,
          createdAtMs: DateTime(2026, 1, 2).millisecondsSinceEpoch,
          chapters: [
            _c(
              1,
              number: 1,
              completed: true,
              read: DateTime(2026, 3, 1).millisecondsSinceEpoch,
            ),
            _c(
              2,
              number: 2,
              percent: 0.5,
              page: 3,
              read: DateTime(2026, 3, 5).millisecondsSinceEpoch,
            ),
          ],
        );
        expect(item.id, '42');
        expect(item.coverSeed, 42);
        expect(item.author, kUnknownAuthor);
        expect(item.type, ComicType.manhwa);
        expect(item.isFavourite, isTrue);
        expect(item.isSample, isFalse);
        expect(item.totalChapters, 2);
        expect(item.currentChapter, 2);
        expect(item.progress, closeTo(0.75, 1e-9));
        expect(item.status, ReadStatus.reading);
        expect(item.chaptersRead, 1);
        expect(item.addedAt, DateTime(2026, 1, 2));
        expect(item.lastReadAt, DateTime(2026, 3, 5));
      },
    );

    test('blank author becomes the placeholder; real author is trimmed', () {
      LibraryItem build(String? a) => buildLibraryItem(
        seriesId: 1,
        title: 't',
        author: a,
        type: ComicType.manga,
        isFavourite: false,
        isCompleted: false,
        createdAtMs: 0,
        chapters: const [],
      );
      expect(build('   ').author, kUnknownAuthor);
      expect(build('  Kim  ').author, 'Kim');
    });

    test(
      'completed series derives ReadStatus.completed and counts every chapter as read',
      () {
        final item = buildLibraryItem(
          seriesId: 1,
          title: 't',
          author: 'a',
          type: ComicType.manga,
          isFavourite: false,
          isCompleted: true,
          createdAtMs: 0,
          chapters: [_fresh(1), _fresh(2)],
        );
        expect(item.status, ReadStatus.completed);
        expect(item.chaptersRead, 2);
      },
    );
  });
}
