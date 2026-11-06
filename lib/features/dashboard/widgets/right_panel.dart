import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/glass.dart';
import '../../../core/design/tokens.dart';
import '../providers.dart';
import 'stats_content.dart';

/// Expanded-layout only (>= 1100): reading stats + collection overview.
class RightPanel extends ConsumerWidget {
  const RightPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsProvider);
    return GlassPanel(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const StatsContent(),
            const SizedBox(height: AppSpacing.xl),
            Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
            const SizedBox(height: AppSpacing.lg),
            const Text('Collections', style: AppText.title),
            const SizedBox(height: AppSpacing.md),
            for (final c in collections)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        c.name,
                        style: AppText.body,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text('${c.count}', style: AppText.numeric),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
