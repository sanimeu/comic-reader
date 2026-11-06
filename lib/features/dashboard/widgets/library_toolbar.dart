import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/design/glass.dart';
import '../../../core/design/tokens.dart';
import '../../../core/layout/layout_class.dart';
import '../../../data/db/database_provider.dart';
import '../../../domain/models.dart';
import '../import/comic_import_service.dart';
import '../providers.dart';
import 'filter_controls.dart';

class LibraryToolbar extends ConsumerStatefulWidget {
  const LibraryToolbar({super.key, required this.layoutClass});

  final LayoutClass layoutClass;

  @override
  ConsumerState<LibraryToolbar> createState() => _LibraryToolbarState();
}

class _LibraryToolbarState extends ConsumerState<LibraryToolbar> {
  late final TextEditingController _controller = TextEditingController(
    text: ref.read(libraryQueryProvider).search,
  );

  bool _importing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _importFolder() async {
    final folder = await FilePicker.getDirectoryPath(
      dialogTitle: 'Select your comic library folder',
    );

    if (!mounted || folder == null) return;
    await _runImport(() async {
      return ComicImportService(
        ref.read(appDatabaseProvider),
      ).scanFolder(folder);
    });
  }

  Future<void> _importFiles() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['cbz', 'zip', 'pdf'],
      dialogTitle: 'Select comic files',
    );

    if (!mounted || result.isEmpty) return;

    final paths = result.map((file) => file.path).whereType<String>().toList();

    await _runImport(() async {
      return ComicImportService(
        ref.read(appDatabaseProvider),
      ).importFiles(paths);
    });
  }

  Future<void> _runImport(Future<ComicImportResult> Function() action) async {
    if (_importing) return;

    setState(() => _importing = true);

    try {
      final result = await action();

      await ref.read(libraryItemsProvider.notifier).refresh();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Imported ${result.imported} comics'
            '${result.skipped > 0 ? ' • Skipped ${result.skipped} duplicates or invalid archives' : ''}',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Import failed: $error')));
    } finally {
      if (mounted) setState(() => _importing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(libraryQueryProvider.select((q) => q.search), (
      previous,
      next,
    ) {
      if (_controller.text != next) _controller.text = next;
    });

    final query = ref.watch(libraryQueryProvider);
    final layout = ref.watch(libraryLayoutProvider);
    final compact = widget.layoutClass == LayoutClass.compact;
    final notifier = ref.read(libraryQueryProvider.notifier);

    return GlassPanel(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  onChanged: notifier.setSearch,
                  style: AppText.body,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search title or author',
                    hintStyle: AppText.body.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.textSecondary,
                    ),
                    suffixIcon: query.search.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            icon: const Icon(
                              Icons.close_rounded,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () {
                              _controller.clear();
                              notifier.setSearch('');
                            },
                          ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    isDense: true,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Import comics',
                enabled: !_importing,
                icon: _importing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(
                        Icons.add_to_photos_rounded,
                        color: AppColors.textSecondary,
                      ),
                color: AppColors.charcoal2,
                onSelected: (value) {
                  if (value == 'folder') {
                    _importFolder();
                  } else if (value == 'files') {
                    _importFiles();
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'folder',
                    child: Row(
                      children: [
                        Icon(Icons.folder_open_rounded, size: 19),
                        SizedBox(width: 10),
                        Text('Scan folder'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'files',
                    child: Row(
                      children: [
                        Icon(Icons.file_open_rounded, size: 19),
                        SizedBox(width: 10),
                        Text('Choose comic files'),
                      ],
                    ),
                  ),
                ],
              ),
              PopupMenuButton<LibrarySort>(
                tooltip: 'Sort: ${query.sort.label}',
                icon: const Icon(
                  Icons.sort_rounded,
                  color: AppColors.textSecondary,
                ),
                color: AppColors.charcoal2,
                initialValue: query.sort,
                onSelected: notifier.setSort,
                itemBuilder: (context) => [
                  for (final s in LibrarySort.values)
                    PopupMenuItem<LibrarySort>(value: s, child: Text(s.label)),
                ],
              ),
              IconButton(
                tooltip: layout == LibraryLayout.grid
                    ? 'Switch to list'
                    : 'Switch to grid',
                onPressed: () =>
                    ref.read(libraryLayoutProvider.notifier).toggle(),
                icon: Icon(
                  layout == LibraryLayout.grid
                      ? Icons.view_list_rounded
                      : Icons.grid_view_rounded,
                  color: AppColors.textSecondary,
                ),
              ),
              if (compact)
                IconButton(
                  tooltip: 'Filters',
                  onPressed: () => showFilterSheet(context),
                  icon: Badge(
                    isLabelVisible: query.hasActiveFilters,
                    smallSize: 8,
                    backgroundColor: AppColors.accent,
                    child: const Icon(
                      Icons.tune_rounded,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
          if (!compact) ...[
            const SizedBox(height: AppSpacing.sm),
            const FilterControls(inline: true),
            const SizedBox(height: AppSpacing.xs),
          ],
        ],
      ),
    );
  }
}
