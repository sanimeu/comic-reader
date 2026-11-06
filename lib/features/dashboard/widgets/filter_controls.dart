import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/glass.dart';
import '../../../core/design/tokens.dart';
import '../../../domain/models.dart';
import '../../../shared/widgets/glass_chip.dart';
import '../providers.dart';

/// Type / status / favourites (and optionally sort) chips.
/// [inline] = horizontal wrap under the toolbar; otherwise stacked for the bottom sheet.
class FilterControls extends ConsumerWidget {
  const FilterControls({
    super.key,
    required this.inline,
    this.includeSort = false,
  });
  final bool inline;
  final bool includeSort;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = ref.watch(libraryQueryProvider);
    final n = ref.read(libraryQueryProvider.notifier);

    Widget group(String label, List<Widget> chips) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppText.label),
        const SizedBox(height: AppSpacing.xs + 2),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: chips,
        ),
      ],
    );

    final groups = <Widget>[
      group('Type', [
        for (final t in ComicType.values)
          GlassChip(
            label: t.label,
            selected: q.types.contains(t),
            onTap: () => n.toggleType(t),
          ),
      ]),
      group('Status', [
        GlassChip(
          label: 'All',
          selected: q.status == null,
          onTap: () => n.setStatus(null),
        ),
        for (final s in ReadStatus.values)
          GlassChip(
            label: s.label,
            selected: q.status == s,
            onTap: () => n.setStatus(s),
          ),
      ]),
      group('Show', [
        GlassChip(
          label: 'Favourites only',
          icon: Icons.favorite_rounded,
          selected: q.favouritesOnly,
          onTap: () => n.setFavouritesOnly(!q.favouritesOnly),
        ),
      ]),
      if (includeSort)
        group('Sort by', [
          for (final s in LibrarySort.values)
            GlassChip(
              label: s.label,
              selected: q.sort == s,
              onTap: () => n.setSort(s),
            ),
        ]),
    ];

    if (inline) {
      return Wrap(
        spacing: AppSpacing.xl,
        runSpacing: AppSpacing.md,
        children: groups,
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final g in groups)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: g,
          ),
      ],
    );
  }
}

/// Bottom sheet used on compact layouts.
Future<void> showFilterSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) => const Padding(
        padding: EdgeInsets.all(AppSpacing.floatingMargin),
        child: GlassPanel(child: _FilterSheetBody()),
      ),
    );

class _FilterSheetBody extends ConsumerWidget {
  const _FilterSheetBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Expanded(child: Text('Filters', style: AppText.title)),
              TextButton(
                onPressed: () =>
                    ref.read(libraryQueryProvider.notifier).clearFilters(),
                child: const Text('Clear'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          const FilterControls(inline: false, includeSort: true),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
