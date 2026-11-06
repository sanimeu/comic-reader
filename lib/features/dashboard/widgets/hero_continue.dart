import 'package:flutter/material.dart';
import '../../../core/design/glass.dart';
import '../../../core/design/tokens.dart';
import '../../../domain/models.dart';
import '../../../shared/widgets/accent_progress_bar.dart';
import '../../../shared/widgets/comic_cover.dart';
import 'reader_pending.dart';

/// Home hero: the most recently read series in progress. Accent glow, one blur layer.
class HeroContinue extends StatelessWidget {
  const HeroContinue({super.key, required this.item, required this.compact});
  final LibraryItem item;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final coverW = compact ? 96.0 : 124.0;
    final coverH = compact ? 144.0 : 186.0;
    return GlassPanel(
      glow: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: coverW,
            height: coverH,
            child: ComicCover(
              seed: item.coverSeed,
              title: item.title,
              path: item.coverCachePath,
            ),
          ),
          SizedBox(width: compact ? AppSpacing.lg : AppSpacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'CONTINUE READING',
                  style: AppText.label.copyWith(
                    color: AppColors.accent,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  item.title,
                  style: compact
                      ? AppText.title
                      : AppText.display.copyWith(fontSize: 26),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${item.type.label} · Chapter ${item.currentChapter} of ${item.totalChapters} · ${item.percent}%',
                  style: AppText.label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.md),
                AccentProgressBar(value: item.progress, height: 6),
                const SizedBox(height: AppSpacing.lg),
                FilledButton.icon(
                  onPressed: () => openComicReader(context, item),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Resume'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
