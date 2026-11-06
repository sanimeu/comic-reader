import 'dart:io';

import 'package:archive/archive.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:pdfrx/pdfrx.dart';

import '../../../data/db/app_database.dart';
import '../../../data/db/database_provider.dart';
import '../../../domain/natural_sort.dart';

/// Opens CBZ/ZIP image archives or a PDFium-backed PDF viewer. Original files
/// remain in their library location; CBZ/ZIP reading progress is stored in SQLite.
class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({
    super.key,
    required this.seriesId,
    required this.title,
    this.initialChapter = 1,
  });

  final int seriesId;
  final String title;
  final int initialChapter;

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  AppDatabase? _db;
  List<ComicRow> _chapters = const [];
  ComicRow? _comic;
  List<Uint8List> _pages = const [];
  int _pageIndex = 0;
  bool _loading = true;
  bool _isPdf = false;
  String? _error;
  final PageController _pageController = PageController();
  final ScrollController _verticalController = ScrollController();
  bool _continuousScroll = false;
  int _rotationQuarterTurns = 0;
  BoxFit _fit = BoxFit.contain;
  String _readerBackground = 'gray';
  bool _negativeView = false;

  Color get _readerBackgroundColor => switch (_readerBackground) {
    'black' => Colors.black,
    'darkGray' => const Color(0xFF303238),
    _ => const Color(0xFF777777),
  };

  static const ColorFilter _negativeColorFilter = ColorFilter.matrix([
    -1,
    0,
    0,
    0,
    255,
    0,
    -1,
    0,
    0,
    255,
    0,
    0,
    -1,
    0,
    255,
    0,
    0,
    0,
    1,
    0,
  ]);

  @override
  void initState() {
    super.initState();
    _open();
  }

  Future<void> _open({int? preferredComicId}) async {
    setState(() {
      _loading = true;
      _error = null;
      _isPdf = false;
    });
    try {
      final db = ref.read(appDatabaseProvider);
      _db = db;
      final preferences =
          await (db.select(db.settings)..where(
                (row) => row.key.isIn([
                  'reader.continuousScroll',
                  'reader.rotation',
                  'reader.fit',
                  'reader.background',
                  'reader.negativeView',
                ]),
              ))
              .get();
      final preferenceMap = {
        for (final item in preferences) item.key: item.value,
      };
      _continuousScroll = preferenceMap['reader.continuousScroll'] == 'true';
      _rotationQuarterTurns =
          (int.tryParse(preferenceMap['reader.rotation'] ?? '0') ?? 0) % 4;
      _fit = preferenceMap['reader.fit'] == 'width'
          ? BoxFit.fitWidth
          : BoxFit.contain;
      _readerBackground = preferenceMap['reader.background'] ?? 'gray';
      _negativeView = preferenceMap['reader.negativeView'] == 'true';
      final chapters = await (db.select(
        db.comics,
      )..where((row) => row.seriesId.equals(widget.seriesId))).get();
      chapters.sort((a, b) {
        final an = a.chapterNumber;
        final bn = b.chapterNumber;
        if (an != null && bn != null && an != bn) return an.compareTo(bn);
        if (an != null && bn == null) return -1;
        if (an == null && bn != null) return 1;
        return naturalCompare(a.fileName, b.fileName);
      });
      if (chapters.isEmpty) {
        throw Exception(
          'No imported comic chapters were found for this series.',
        );
      }
      final fallbackIndex = (widget.initialChapter - 1)
          .clamp(0, chapters.length - 1)
          .toInt();
      final selected = chapters.firstWhere(
        (c) => c.id == preferredComicId,
        orElse: () => chapters[fallbackIndex],
      );
      final file = File(selected.uri);
      if (!await file.exists()) {
        throw Exception('The comic file is missing: ${selected.fileName}');
      }
      final extension = p.extension(selected.uri).toLowerCase();
      if (extension == '.pdf') {
        final document = await PdfDocument.openFile(selected.uri);
        final pageCount = document.pages.length;
        await document.dispose();
        if (pageCount == 0) throw Exception('This PDF contains no pages.');
        if (!mounted) return;
        setState(() {
          _chapters = chapters;
          _comic = selected;
          _pages = const [];
          _pageIndex = 0;
          _isPdf = true;
          _loading = false;
        });
        return;
      }
      if (extension == '.cbr') {
        throw Exception(
          'CBR (RAR) archives require the optional libarchive/7-Zip backend, which is not present in this build.',
        );
      }
      if (extension == '.cb7') {
        throw Exception(
          'CB7 (7-Zip) archives require the optional libarchive/7-Zip backend, which is not present in this build.',
        );
      }
      if (!{'.cbz', '.zip'}.contains(extension)) {
        throw Exception('Unsupported comic format: $extension');
      }
      final archive = ZipDecoder().decodeBytes(
        await file.readAsBytes(),
        verify: true,
      );
      final entries =
          archive.files
              .where(
                (entry) =>
                    entry.isFile &&
                    const {
                      '.jpg',
                      '.jpeg',
                      '.png',
                      '.webp',
                    }.contains(p.extension(entry.name).toLowerCase()),
              )
              .toList()
            ..sort((a, b) => naturalCompare(a.name, b.name));
      final pages = <Uint8List>[];
      for (final entry in entries) {
        final data = entry.readBytes();
        if (data != null && data.isNotEmpty) pages.add(data);
      }
      if (pages.isEmpty) {
        throw Exception('This archive contains no readable image pages.');
      }

      final progress = await (db.select(
        db.readingProgress,
      )..where((row) => row.comicId.equals(selected.id))).getSingleOrNull();
      final initialPage = (progress?.pageIndex ?? 0)
          .clamp(0, pages.length - 1)
          .toInt();
      final initialScrollOffset = progress?.scrollOffset ?? 0.0;
      if (!mounted) return;
      setState(() {
        _chapters = chapters;
        _comic = selected;
        _pages = pages;
        _pageIndex = initialPage;
        _loading = false;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_continuousScroll && _verticalController.hasClients) {
          _verticalController.jumpTo(
            initialScrollOffset
                .clamp(0.0, _verticalController.position.maxScrollExtent)
                .toDouble(),
          );
        } else if (_pageController.hasClients) {
          _pageController.jumpToPage(initialPage);
        }
      });
      try {
        await _saveProgress(initialPage, scrollOffset: initialScrollOffset);
      } catch (_) {
        // A progress-write failure must not prevent opening the comic.
      }
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  Future<void> _saveProgress(int page, {double scrollOffset = 0}) async {
    final db = _db;
    final comic = _comic;
    if (db == null || comic == null || _pages.isEmpty) return;
    final now = DateTime.now().millisecondsSinceEpoch;
    final fraction = (page + 1) / _pages.length;
    await db
        .into(db.readingProgress)
        .insertOnConflictUpdate(
          ReadingProgressCompanion.insert(
            comicId: Value(comic.id),
            pageIndex: Value(page),
            scrollOffset: Value(scrollOffset),
            percent: Value(fraction),
            completed: Value(page >= _pages.length - 1),
            lastReadAt: now,
            updatedAt: now,
          ),
        );
  }

  Future<void> _savePreference(String key, String value) async {
    final db = _db;
    if (db == null) return;
    await db
        .into(db.settings)
        .insertOnConflictUpdate(
          SettingsCompanion.insert(key: key, value: value),
        );
  }

  Future<void> _showReaderSettings() async {
    final result = await showModalBottomSheet<Map<String, Object>>(
      context: context,
      backgroundColor: const Color(0xFF171922),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Reading settings',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Continuous vertical scrolling',
                      style: TextStyle(color: Colors.white),
                    ),
                    value: _continuousScroll,
                    onChanged: (value) =>
                        setSheetState(() => _continuousScroll = value),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Page rotation',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      for (var angle in [0, 90, 180, 270])
                        ChoiceChip(
                          label: Text('$angle°'),
                          selected: _rotationQuarterTurns == angle ~/ 90,
                          onSelected: (_) => setSheetState(
                            () => _rotationQuarterTurns = angle ~/ 90,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Page fit',
                    style: TextStyle(color: Colors.white70),
                  ),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Fit screen'),
                        selected: _fit == BoxFit.contain,
                        onSelected: (_) =>
                            setSheetState(() => _fit = BoxFit.contain),
                      ),
                      ChoiceChip(
                        label: const Text('Fit width'),
                        selected: _fit == BoxFit.fitWidth,
                        onSelected: (_) =>
                            setSheetState(() => _fit = BoxFit.fitWidth),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Reader background',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 8,
                    children: [
                      ChoiceChip(
                        label: const Text('Gray'),
                        selected: _readerBackground == 'gray',
                        onSelected: (_) =>
                            setSheetState(() => _readerBackground = 'gray'),
                      ),
                      ChoiceChip(
                        label: const Text('Dark gray'),
                        selected: _readerBackground == 'darkGray',
                        onSelected: (_) =>
                            setSheetState(() => _readerBackground = 'darkGray'),
                      ),
                      ChoiceChip(
                        label: const Text('Black'),
                        selected: _readerBackground == 'black',
                        onSelected: (_) =>
                            setSheetState(() => _readerBackground = 'black'),
                      ),
                    ],
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text(
                      'Negative view (invert page colors)',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Invert page colors for a negative-style reading view',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    value: _negativeView,
                    onChanged: (value) =>
                        setSheetState(() => _negativeView = value),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(context, {
                        'scroll': _continuousScroll,
                        'rotation': _rotationQuarterTurns,
                        'fit': _fit == BoxFit.fitWidth ? 'width' : 'screen',
                        'background': _readerBackground,
                        'negative': _negativeView,
                      }),
                      child: const Text('Apply'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      _continuousScroll = result['scroll'] as bool;
      _rotationQuarterTurns = result['rotation'] as int;
      _fit = result['fit'] == 'width' ? BoxFit.fitWidth : BoxFit.contain;
      _readerBackground = result['background'] as String;
      _negativeView = result['negative'] as bool;
    });
    await _savePreference('reader.continuousScroll', '$_continuousScroll');
    await _savePreference('reader.rotation', '$_rotationQuarterTurns');
    await _savePreference('reader.fit', result['fit'] as String);
    await _savePreference('reader.background', _readerBackground);
    await _savePreference('reader.negativeView', '$_negativeView');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!_continuousScroll && _pageController.hasClients) {
        _pageController.jumpToPage(_pageIndex);
      } else if (_continuousScroll && _verticalController.hasClients) {
        final viewport = _verticalController.position.viewportDimension;
        _verticalController.jumpTo(
          (viewport * _pageIndex)
              .clamp(0.0, _verticalController.position.maxScrollExtent)
              .toDouble(),
        );
      }
    });
  }

  Widget _pageImage(int index, BuildContext context) {
    final image = Image.memory(
      _pages[index],
      fit: _fit,
      gaplessPlayback: true,
      cacheWidth:
          (MediaQuery.sizeOf(context).width *
                  MediaQuery.devicePixelRatioOf(context))
              .round()
              .clamp(320, 2400)
              .toInt(),
      errorBuilder: (_, _, _) => const Center(
        child: Text(
          'Unable to display this page',
          style: TextStyle(color: Colors.white70),
        ),
      ),
    );
    return _negativeView
        ? ColorFiltered(colorFilter: _negativeColorFilter, child: image)
        : image;
  }

  void _changePage(int next) {
    if (_pages.isEmpty) return;
    final value = next.clamp(0, _pages.length - 1).toInt();
    if (value == _pageIndex) return;
    setState(() => _pageIndex = value);
    if (!_continuousScroll && _pageController.hasClients) {
      _pageController.jumpToPage(value);
    }
    if (_continuousScroll && _verticalController.hasClients) {
      final viewport = _verticalController.position.viewportDimension;
      _verticalController.animateTo(
        (viewport * value)
            .clamp(0.0, _verticalController.position.maxScrollExtent)
            .toDouble(),
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    }
    _saveProgress(value);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final comic = _comic;
    return Shortcuts(
      shortcuts: const {
        SingleActivator(LogicalKeyboardKey.arrowRight): _NextPageIntent(),
        SingleActivator(LogicalKeyboardKey.arrowLeft): _PreviousPageIntent(),
      },
      child: Actions(
        actions: {
          _NextPageIntent: CallbackAction<_NextPageIntent>(
            onInvoke: (_) {
              _changePage(_pageIndex + 1);
              return null;
            },
          ),
          _PreviousPageIntent: CallbackAction<_PreviousPageIntent>(
            onInvoke: (_) {
              _changePage(_pageIndex - 1);
              return null;
            },
          ),
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF08090D),
          appBar: AppBar(
            backgroundColor: const Color(0xFF101116),
            foregroundColor: Colors.white,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 16),
                ),
                if (comic != null)
                  Text(
                    comic.chapterTitle ?? comic.fileName,
                    style: const TextStyle(fontSize: 11, color: Colors.white60),
                  ),
              ],
            ),
            actions: [
              IconButton(
                tooltip: 'Reading settings',
                onPressed: _showReaderSettings,
                icon: const Icon(Icons.tune_rounded),
              ),
              if (_chapters.length > 1)
                PopupMenuButton<int>(
                  tooltip: 'Choose chapter',
                  icon: const Icon(Icons.menu_book_rounded),
                  onSelected: (id) => _open(preferredComicId: id),
                  itemBuilder: (context) => [
                    for (final chapter in _chapters)
                      PopupMenuItem(
                        value: chapter.id,
                        child: Text(chapter.chapterTitle ?? chapter.fileName),
                      ),
                  ],
                ),
            ],
          ),
          body: _loading
              ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
              : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.menu_book_outlined,
                          color: Colors.white54,
                          size: 44,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => _open(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _isPdf && _comic != null
              ? ColoredBox(
                  color: _readerBackgroundColor,
                  child: _negativeView
                      ? ColorFiltered(
                          colorFilter: _negativeColorFilter,
                          child: PdfViewer.file(
                            _comic!.uri,
                            params: const PdfViewerParams(
                              scrollByMouseWheel: 0.2,
                              scaleEnabled: true,
                            ),
                          ),
                        )
                      : PdfViewer.file(
                          _comic!.uri,
                          params: const PdfViewerParams(
                            scrollByMouseWheel: 0.2,
                            scaleEnabled: true,
                          ),
                        ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ColoredBox(
                        color: _readerBackgroundColor,
                        child: _continuousScroll
                            ? NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  if (notification
                                          is ScrollUpdateNotification &&
                                      notification.metrics.viewportDimension >
                                          0) {
                                    final visiblePage =
                                        (notification.metrics.pixels /
                                                notification
                                                    .metrics
                                                    .viewportDimension)
                                            .floor()
                                            .clamp(0, _pages.length - 1)
                                            .toInt();
                                    if (visiblePage != _pageIndex) {
                                      setState(() => _pageIndex = visiblePage);
                                      _saveProgress(
                                        visiblePage,
                                        scrollOffset:
                                            notification.metrics.pixels,
                                      );
                                    }
                                  }
                                  return false;
                                },
                                child: ListView.builder(
                                  controller: _verticalController,
                                  itemCount: _pages.length,
                                  itemBuilder: (context, index) => GestureDetector(
                                    onTap: () {
                                      setState(() => _pageIndex = index);
                                      _saveProgress(
                                        index,
                                        scrollOffset:
                                            _verticalController.hasClients
                                            ? _verticalController
                                                  .position
                                                  .pixels
                                            : 0,
                                      );
                                    },
                                    child: Center(
                                      child: InteractiveViewer(
                                        minScale: 1,
                                        maxScale: 5,
                                        // A normal wheel scroll must not scale the page.
                                        trackpadScrollCausesScale: false,
                                        child: RotatedBox(
                                          quarterTurns: _rotationQuarterTurns,
                                          child: _pageImage(index, context),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : PageView.builder(
                                controller: _pageController,
                                itemCount: _pages.length,
                                onPageChanged: (index) {
                                  setState(() => _pageIndex = index);
                                  _saveProgress(index);
                                },
                                itemBuilder: (context, index) => Center(
                                  child: InteractiveViewer(
                                    minScale: 1,
                                    maxScale: 5,
                                    // A normal wheel scroll must not scale the page.
                                    trackpadScrollCausesScale: false,
                                    child: RotatedBox(
                                      quarterTurns: _rotationQuarterTurns,
                                      child: _pageImage(index, context),
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    SafeArea(
                      top: false,
                      child: Container(
                        color: const Color(0xFF101116),
                        padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: _pageIndex > 0
                                      ? () => _changePage(_pageIndex - 1)
                                      : null,
                                  color: Colors.white,
                                  disabledColor: Colors.white24,
                                  icon: const Icon(Icons.chevron_left_rounded),
                                ),
                                Expanded(
                                  child: Slider(
                                    value: _pageIndex.toDouble(),
                                    min: 0,
                                    max: (_pages.length - 1).toDouble(),
                                    onChanged: (value) =>
                                        _changePage(value.round()),
                                  ),
                                ),
                                IconButton(
                                  onPressed: _pageIndex < _pages.length - 1
                                      ? () => _changePage(_pageIndex + 1)
                                      : null,
                                  color: Colors.white,
                                  disabledColor: Colors.white24,
                                  icon: const Icon(Icons.chevron_right_rounded),
                                ),
                              ],
                            ),
                            Text(
                              'Page ${_pageIndex + 1} of ${_pages.length}  ·  ${((_pageIndex + 1) / _pages.length * 100).round()}%',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _NextPageIntent extends Intent {
  const _NextPageIntent();
}

class _PreviousPageIntent extends Intent {
  const _PreviousPageIntent();
}
