import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/tokens.dart';
import '../../../core/format/relative_time.dart';
import '../../../shared/widgets/empty_state.dart';
import '../providers.dart';
import '../widgets/comic_cards.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(historyProvider);
    if (items.isEmpty) {
      return const EmptyState(
        icon: Icons.history_rounded,
        title: 'Nothing read yet',
        message: 'Series you read will appear here, most recent first.',
      );
    }
    final now = DateTime.now();
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      itemCount: items.length,
      separatorBuilder: (context, i) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, i) {
        final item = items[i];
        return ComicListTile(
          key: ValueKey(item.id),
          item: item,
          note: 'Read ${formatRelative(item.lastReadAt!, now).toLowerCase()}',
        );
      },
    );
  }
}
