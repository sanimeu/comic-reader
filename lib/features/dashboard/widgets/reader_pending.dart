import 'package:flutter/material.dart';
import '../../../domain/models.dart';
import '../pages/reader_screen.dart';

/// Opens an imported database-backed series in the comic reader (CBZ, ZIP or PDF).
void openComicReader(BuildContext context, LibraryItem item) {
  final seriesId = int.tryParse(item.id);
  if (seriesId == null) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        const SnackBar(content: Text('Import a comic file to read it.')),
      );
    return;
  }
  Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => ReaderScreen(
        seriesId: seriesId,
        title: item.title,
        initialChapter: item.currentChapter,
      ),
    ),
  );
}
