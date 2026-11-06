/// Display-level library model. The Phase 3 repository maps database rows
/// (series + comics + reading_progress) into these. Sample data (see
/// features/dashboard/sample) also uses them but is flagged `isSample`.
enum ComicType { manga, manhwa, manhua, unknown }

enum ReadStatus { unread, reading, completed }

enum LibraryLayout { grid, list }

enum LibrarySort { recentlyAdded, recentlyRead, alphabetical }

enum NavSection { home, library, collections, history, favourites, settings }

extension ComicTypeLabel on ComicType {
  String get label => switch (this) {
    ComicType.manga => 'Manga',
    ComicType.manhwa => 'Manhwa',
    ComicType.manhua => 'Manhua',
    ComicType.unknown => 'Other',
  };
}

extension ReadStatusLabel on ReadStatus {
  String get label => switch (this) {
    ReadStatus.unread => 'Unread',
    ReadStatus.reading => 'Reading',
    ReadStatus.completed => 'Completed',
  };
}

extension LibrarySortLabel on LibrarySort {
  String get label => switch (this) {
    LibrarySort.recentlyAdded => 'Recently added',
    LibrarySort.recentlyRead => 'Recently read',
    LibrarySort.alphabetical => 'Alphabetical',
  };
}

extension NavSectionLabel on NavSection {
  String get label => switch (this) {
    NavSection.home => 'Home',
    NavSection.library => 'Library',
    NavSection.collections => 'Collections',
    NavSection.history => 'History',
    NavSection.favourites => 'Favourites',
    NavSection.settings => 'Settings',
  };
}

class LibraryItem {
  const LibraryItem({
    required this.id,
    required this.title,
    required this.author,
    required this.type,
    required this.totalChapters,
    required this.currentChapter,
    required this.progress,
    required this.addedAt,
    this.lastReadAt,
    this.isFavourite = false,
    this.coverSeed = 0,
    this.coverCachePath,
    this.isSample = false,
  });

  final String id;
  final String title;
  final String author;
  final ComicType type;
  final int totalChapters;

  /// 1-based chapter the reader is currently in (meaningful when status != unread).
  final int currentChapter;

  /// Whole-series progress, 0.0 to 1.0.
  final double progress;
  final DateTime addedAt;
  final DateTime? lastReadAt;
  final bool isFavourite;
  final int coverSeed;
  final String? coverCachePath;
  final bool isSample;

  ReadStatus get status {
    if (progress >= 1.0) return ReadStatus.completed;
    if (progress > 0) return ReadStatus.reading;
    return ReadStatus.unread;
  }

  bool get isCompleted => status == ReadStatus.completed;

  int get percent => (progress.clamp(0.0, 1.0) * 100).round();

  /// Chapters fully read, used by statistics.
  int get chaptersRead {
    switch (status) {
      case ReadStatus.unread:
        return 0;
      case ReadStatus.completed:
        return totalChapters;
      case ReadStatus.reading:
        final done = currentChapter - 1;
        if (done < 0) return 0;
        if (done > totalChapters) return totalChapters;
        return done;
    }
  }

  LibraryItem copyWith({
    double? progress,
    int? currentChapter,
    DateTime? lastReadAt,
    bool? isFavourite,
  }) => LibraryItem(
    id: id,
    title: title,
    author: author,
    type: type,
    totalChapters: totalChapters,
    currentChapter: currentChapter ?? this.currentChapter,
    progress: progress ?? this.progress,
    addedAt: addedAt,
    lastReadAt: lastReadAt ?? this.lastReadAt,
    isFavourite: isFavourite ?? this.isFavourite,
    coverSeed: coverSeed,
    coverCachePath: coverCachePath,
    isSample: isSample,
  );
}

/// A collection shown in the UI. Smart collections (Favourites, Completed) are
/// computed from item state; manual ones list explicit item ids.
class CollectionInfo {
  const CollectionInfo({
    required this.id,
    required this.name,
    required this.itemIds,
    this.isSmart = false,
  });
  final String id;
  final String name;
  final List<String> itemIds;
  final bool isSmart;
  int get count => itemIds.length;
}
