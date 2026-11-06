import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/db/database_provider.dart';
import '../providers.dart';
import '../../../core/design/glass.dart';
import '../../../core/design/tokens.dart';
import '../../../domain/models.dart';
import '../../../shared/widgets/accent_progress_bar.dart';
import '../../../shared/widgets/comic_cover.dart';
import '../item_labels.dart';
import 'favourite_button.dart';
import 'reader_pending.dart';

/// Grid / shelf card. Cards never blur (D4): they live in scrolling lists.
/// Needs a bounded height from its parent (grid tile or SizedBox).
class ComicGridCard extends StatelessWidget {
  const ComicGridCard({super.key, required this.item});
  final LibraryItem item;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      kind: GlassKind.card,
      blurOverride: false,
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadii.cardR,
          onTap: () => openComicReader(context, item),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      ComicCover(
                        seed: item.coverSeed,
                        title: item.title,
                        path: item.coverCachePath,
                      ),
                      Positioned(
                        left: 6,
                        top: 6,
                        child: _TypePill(type: item.type),
                      ),
                      Positioned(
                        right: 6,
                        top: 6,
                        child: FavouriteButton(item: item),
                      ),
                      Positioned(
                        right: 4,
                        bottom: 4,
                        child: _LibraryItemMenu(item: item),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  item.title,
                  style: AppText.body.copyWith(fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  progressLabel(item),
                  style: AppText.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.sm),
                AccentProgressBar(value: item.progress),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TypePill extends StatelessWidget {
  const _TypePill({required this.type});
  final ComicType type;
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
    decoration: BoxDecoration(
      color: Colors.black.withValues(alpha: 0.45),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(
      type.label,
      style: AppText.label.copyWith(fontSize: 10, color: Colors.white70),
    ),
  );
}

/// List-layout row. [note] replaces the progress caption (History uses it for "Read 3 h ago").
class ComicListTile extends StatelessWidget {
  const ComicListTile({super.key, required this.item, this.note});
  final LibraryItem item;
  final String? note;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      kind: GlassKind.card,
      blurOverride: false,
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: AppRadii.cardR,
          onTap: () => openComicReader(context, item),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                SizedBox(
                  width: 56,
                  height: 80,
                  child: ComicCover(
                    seed: item.coverSeed,
                    title: item.title,
                    path: item.coverCachePath,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.title,
                        style: AppText.body.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${item.type.label} · ${item.author}',
                        style: AppText.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Row(
                        children: [
                          Expanded(
                            child: AccentProgressBar(value: item.progress),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Text('${item.percent}%', style: AppText.numeric),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        note ?? progressLabel(item),
                        style: AppText.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                FavouriteButton(item: item),
                _LibraryItemMenu(item: item),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LibraryItemMenu extends ConsumerWidget {
  const _LibraryItemMenu({required this.item});
  final LibraryItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (item.isSample) return const SizedBox.shrink();
    return PopupMenuButton<String>(
      tooltip: 'Library item actions',
      icon: const Icon(
        Icons.more_vert_rounded,
        color: Colors.white70,
        size: 20,
      ),
      onSelected: (value) async {
        if (value != 'remove') return;
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('Remove from library?'),
            content: Text(
              '“${item.title}” will be removed from your Comic Reader library. The original comic files on your PC will not be deleted.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('Cancel'),
              ),
              FilledButton.tonal(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('Remove'),
              ),
            ],
          ),
        );
        if (confirmed != true || !context.mounted) return;
        final seriesId = int.tryParse(item.id);
        if (seriesId == null) return;
        try {
          final db = ref.read(appDatabaseProvider);
          await db.transaction(() async {
            // Deleting comic rows cascades reading progress and bookmarks.
            await (db.delete(
              db.comics,
            )..where((row) => row.seriesId.equals(seriesId))).go();
            await (db.delete(
              db.series,
            )..where((row) => row.id.equals(seriesId))).go();
          });
          await ref.read(libraryItemsProvider.notifier).refresh();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Removed from library. Original files were kept.',
                ),
              ),
            );
          }
        } catch (error) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Could not remove item: $error')),
            );
          }
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem<String>(
          value: 'remove',
          child: Row(
            children: [
              Icon(Icons.delete_outline_rounded, size: 18),
              SizedBox(width: 8),
              Text('Remove from library'),
            ],
          ),
        ),
      ],
    );
  }
}
