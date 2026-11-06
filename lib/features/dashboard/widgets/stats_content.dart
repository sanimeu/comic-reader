import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/tokens.dart';
import '../providers.dart';

/// Reading statistics (computed by computeStats from the library items).
/// Shown in the right panel on expanded layouts, inline on Home otherwise.
class StatsContent extends ConsumerWidget {
  const StatsContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(statsProvider);
    final pct = (s.overallProgress * 100).round();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Reading stats', style: AppText.title),
        const SizedBox(height: AppSpacing.lg),
        Center(
          child: SizedBox(
            width: 104,
            height: 104,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: s.overallProgress.clamp(0.0, 1.0).toDouble(),
                  strokeWidth: 8,
                  strokeCap: StrokeCap.round,
                  color: AppColors.accent,
                  backgroundColor: Colors.white12,
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$pct%', style: AppText.title),
                      const Text('of chapters', style: AppText.label),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        _StatRow(label: 'Series', value: '${s.seriesCount}'),
        _StatRow(label: 'Reading', value: '${s.reading}'),
        _StatRow(label: 'Completed', value: '${s.completed}'),
        _StatRow(label: 'Unread', value: '${s.unread}'),
        _StatRow(label: 'Favourites', value: '${s.favourites}'),
        _StatRow(
          label: 'Chapters read',
          value: '${s.chaptersRead} / ${s.totalChapters}',
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
    child: Row(
      children: [
        Expanded(child: Text(label, style: AppText.label)),
        Text(value, style: AppText.numeric),
      ],
    ),
  );
}
