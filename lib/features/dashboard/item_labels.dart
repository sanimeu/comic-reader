import '../../domain/models.dart';

/// One-line progress description used by cards and list rows.
String progressLabel(LibraryItem item) => switch (item.status) {
  ReadStatus.unread => 'Not started',
  ReadStatus.reading => 'Ch. ${item.currentChapter} / ${item.totalChapters}',
  ReadStatus.completed => 'Completed',
};
