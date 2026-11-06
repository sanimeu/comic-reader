import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/glass.dart';
import '../../../core/design/tokens.dart';
import '../../../core/layout/layout_class.dart';
import '../../../shared/widgets/empty_state.dart';
import '../providers.dart';
import '../widgets/hero_continue.dart';
import '../widgets/shelf.dart';
import '../widgets/stats_content.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key, required this.layoutClass});
  final LayoutClass layoutClass;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final all = ref.watch(libraryItemsProvider);
    if (all.isEmpty) {
      return const EmptyState(
        icon: Icons.auto_stories_rounded,
        title: 'Your library is empty',
        message: 'Adding folders to scan arrives in a later phase.',
      );
    }
    final reading = ref.watch(continueReadingProvider);
    final added = ref.watch(recentlyAddedProvider);
    final compact = layoutClass == LayoutClass.compact;
    // Expanded layouts show stats in the right panel; otherwise show them inline (exactly once either way).
    final inlineStats = layoutClass != LayoutClass.expanded;

    return ListView(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      children: [
        if (reading.isNotEmpty)
          HeroContinue(item: reading.first, compact: compact),
        if (inlineStats) ...[
          const SizedBox(height: AppSpacing.lg),
          const GlassPanel(
            kind: GlassKind.card,
            blurOverride: false,
            child: StatsContent(),
          ),
        ],
        if (reading.length > 1) ...[
          const SectionTitle('Continue reading'),
          HorizontalShelf(items: reading.skip(1).toList()),
        ],
        const SectionTitle('Recently added'),
        HorizontalShelf(items: added),
      ],
    );
  }
}
