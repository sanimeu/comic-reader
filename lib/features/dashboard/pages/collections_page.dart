import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/glass.dart';
import '../../../core/design/tokens.dart';
import '../../../core/layout/layout_class.dart';
import '../../../domain/models.dart';
import '../../../shared/widgets/comic_cover.dart';
import '../providers.dart';

class CollectionsPage extends ConsumerWidget {
  const CollectionsPage({super.key, required this.layoutClass});
  final LayoutClass layoutClass;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsProvider);
    final byId = {for (final i in ref.watch(libraryItemsProvider)) i.id: i};
    final maxCovers = layoutClass == LayoutClass.compact ? 3 : 5;
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      itemCount: collections.length,
      separatorBuilder: (context, i) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, i) {
        final c = collections[i];
        final covers = [
          for (final id in c.itemIds.take(maxCovers))
            if (byId[id] != null) byId[id]!,
        ];
        return _CollectionCard(info: c, covers: covers);
      },
    );
  }
}

class _CollectionCard extends StatelessWidget {
  const _CollectionCard({required this.info, required this.covers});
  final CollectionInfo info;
  final List<LibraryItem> covers;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      kind: GlassKind.card,
      blurOverride: false,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  info.name,
                  style: AppText.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${info.count} series${info.isSmart ? ' · Smart (automatic)' : ''}',
                  style: AppText.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          for (final item in covers)
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: SizedBox(
                width: 36,
                height: 52,
                child: ComicCover(
                  seed: item.coverSeed,
                  title: item.title,
                  path: item.coverCachePath,
                  radius: BorderRadius.circular(6),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
