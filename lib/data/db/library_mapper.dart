import '../../domain/models.dart';
import '../../domain/natural_sort.dart';

/// Pure (no Drift, no Flutter) rules that turn database facts into the existing
/// display model [LibraryItem]. The dashboard model is unchanged; this is the
/// bridge the Phase 3 repository will use.
///
/// Rules (documented in docs/DATABASE.md):
///  * totalChapters   = number of comics whose series_id is this series (derived, never stored).
///  * progress        = sum(chapter fractions) / totalChapters, where a chapter counts 1.0 when
///                      completed, otherwise clamp(percent, 0..1); no progress row = 0.
///  * status          = derived by LibraryItem from progress (unread / reading / completed).
///  * series.is_completed = MANUAL override: forces progress 1.0. It is never written automatically.
///  * currentChapter  = 1-based position (chapters ordered by chapter_number, nulls last, then
///                      natural file name) of the most recently read unfinished chapter; else the
///                      first chapter not completed; else the last chapter.

const String kUnknownAuthor = 'Unknown author';

class ChapterProgressSnapshot {
  const ChapterProgressSnapshot({
    required this.percent,
    required this.completed,
    required this.pageIndex,
    required this.lastReadAtMs,
  });

  /// Fraction 0.0 to 1.0.
  final double percent;
  final bool completed;
  final int pageIndex;

  /// Epoch milliseconds.
  final int lastReadAtMs;

  double get fraction => completed ? 1.0 : percent.clamp(0.0, 1.0).toDouble();

  /// Started but not finished.
  bool get inProgress => !completed && (percent > 0 || pageIndex > 0);
}

class ChapterSnapshot {
  const ChapterSnapshot({
    required this.id,
    required this.fileName,
    this.chapterNumber,
    this.coverCachePath,
    this.progress,
  });
  final int id;
  final String fileName;
  final double? chapterNumber;
  final String? coverCachePath;
  final ChapterProgressSnapshot? progress;

  bool get isCompleted => progress?.completed ?? false;
}

/// Reading order: chapter_number ascending (numbered before unnumbered),
/// then natural file-name order, then id (deterministic).
int compareChapters(ChapterSnapshot a, ChapterSnapshot b) {
  final x = a.chapterNumber, y = b.chapterNumber;
  if (x != null && y != null) {
    final c = x.compareTo(y);
    if (c != 0) return c;
  } else if (x != null) {
    return -1;
  } else if (y != null) {
    return 1;
  }
  final c = naturalCompare(a.fileName, b.fileName);
  if (c != 0) return c;
  return a.id.compareTo(b.id);
}

List<ChapterSnapshot> orderChapters(Iterable<ChapterSnapshot> chapters) =>
    [...chapters]..sort(compareChapters);

class SeriesDerivation {
  const SeriesDerivation({
    required this.totalChapters,
    required this.currentChapter,
    required this.progress,
    required this.lastReadAtMs,
  });
  final int totalChapters;
  final int currentChapter;
  final double progress;
  final int? lastReadAtMs;
}

SeriesDerivation deriveSeries({
  required bool markedCompleted,
  required Iterable<ChapterSnapshot> chapters,
}) {
  final ordered = orderChapters(chapters);
  final total = ordered.length;

  int? lastRead;
  var sum = 0.0;
  for (final c in ordered) {
    final p = c.progress;
    if (p == null) continue;
    sum += p.fraction;
    if (lastRead == null || p.lastReadAtMs > lastRead) {
      lastRead = p.lastReadAtMs;
    }
  }

  var progress = total == 0 ? 0.0 : sum / total;
  if (markedCompleted) progress = 1.0;

  final int current;
  if (total == 0) {
    current = 1;
  } else if (markedCompleted) {
    current = total;
  } else {
    int? bestIndex;
    int bestRead = 0;
    for (var i = 0; i < total; i++) {
      final p = ordered[i].progress;
      if (p != null &&
          p.inProgress &&
          (bestIndex == null || p.lastReadAtMs > bestRead)) {
        bestIndex = i;
        bestRead = p.lastReadAtMs;
      }
    }
    if (bestIndex != null) {
      current = bestIndex + 1;
    } else {
      final firstUnfinished = ordered.indexWhere((c) => !c.isCompleted);
      current = firstUnfinished == -1 ? total : firstUnfinished + 1;
    }
  }

  return SeriesDerivation(
    totalChapters: total,
    currentChapter: current,
    progress: progress,
    lastReadAtMs: lastRead,
  );
}

/// Builds the existing display model from primitives (so this file stays Drift-free).
/// Ids: the DB integer id becomes the String id; the integer also seeds the generated cover.
LibraryItem buildLibraryItem({
  required int seriesId,
  required String title,
  required String? author,
  required ComicType type,
  required bool isFavourite,
  required bool isCompleted,
  required int createdAtMs,
  required Iterable<ChapterSnapshot> chapters,
}) {
  final d = deriveSeries(markedCompleted: isCompleted, chapters: chapters);
  final trimmed = author?.trim();
  return LibraryItem(
    id: seriesId.toString(),
    title: title,
    author: (trimmed == null || trimmed.isEmpty) ? kUnknownAuthor : trimmed,
    type: type,
    totalChapters: d.totalChapters,
    currentChapter: d.currentChapter,
    progress: d.progress,
    addedAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
    lastReadAt: d.lastReadAtMs == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(d.lastReadAtMs!),
    isFavourite: isFavourite,
    coverSeed: seriesId,
    coverCachePath: _firstCoverPath(chapters),
    isSample: false,
  );
}

String? _firstCoverPath(Iterable<ChapterSnapshot> chapters) {
  for (final chapter in orderChapters(chapters)) {
    final path = chapter.coverCachePath;
    if (path != null && path.isNotEmpty) return path;
  }
  return null;
}
