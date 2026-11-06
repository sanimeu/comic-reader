import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/tokens.dart';
import '../../../core/layout/layout_class.dart';
import '../../../shared/widgets/empty_state.dart';
import '../providers.dart';
import '../widgets/comic_items_view.dart';
import '../widgets/library_toolbar.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key, required this.layoutClass});
  final LayoutClass layoutClass;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(visibleItemsProvider);
    final total = ref.watch(libraryItemsProvider).length;
    final layout = ref.watch(libraryLayoutProvider);
    final query = ref.watch(libraryQueryProvider);
    final filtered = query.hasActiveFilters || query.search.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LibraryToolbar(layoutClass: layoutClass),
        const SizedBox(height: AppSpacing.md),
        Padding(
          padding: const EdgeInsets.only(left: 2),
          child: Text(
            'Showing ${items.length} of $total series',
            style: AppText.label,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: ComicItemsView(
            items: items,
            layout: layout,
            empty: total == 0
                ? const EmptyState(
                    icon: Icons.auto_stories_rounded,
                    title: 'Your library is empty',
                    message: 'Adding folders to scan arrives in a later phase.',
                  )
                : EmptyState(
                    icon: Icons.search_off_rounded,
                    title: 'No comics match your search',
                    message: 'Try different words or remove some filters.',
                    actionLabel: filtered ? 'Clear search & filters' : null,
                    onAction: filtered
                        ? () =>
                              ref.read(libraryQueryProvider.notifier).clearAll()
                        : null,
                  ),
          ),
        ),
      ],
    );
  }
}
