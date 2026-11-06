import 'models.dart';

class ReadingStats {
  const ReadingStats({
    required this.seriesCount,
    required this.reading,
    required this.completed,
    required this.unread,
    required this.favourites,
    required this.chaptersRead,
    required this.totalChapters,
  });
  final int seriesCount;
  final int reading;
  final int completed;
  final int unread;
  final int favourites;
  final int chaptersRead;
  final int totalChapters;

  /// Share of all chapters in the library that have been read, 0.0 to 1.0.
  double get overallProgress =>
      totalChapters == 0 ? 0 : chaptersRead / totalChapters;
}

ReadingStats computeStats(Iterable<LibraryItem> items) {
  var series = 0,
      reading = 0,
      completed = 0,
      unread = 0,
      fav = 0,
      read = 0,
      total = 0;
  for (final i in items) {
    series++;
    switch (i.status) {
      case ReadStatus.reading:
        reading++;
      case ReadStatus.completed:
        completed++;
      case ReadStatus.unread:
        unread++;
    }
    if (i.isFavourite) fav++;
    read += i.chaptersRead;
    total += i.totalChapters;
  }
  return ReadingStats(
    seriesCount: series,
    reading: reading,
    completed: completed,
    unread: unread,
    favourites: fav,
    chaptersRead: read,
    totalChapters: total,
  );
}
