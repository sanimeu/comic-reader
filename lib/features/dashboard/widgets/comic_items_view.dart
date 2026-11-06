import 'package:flutter/material.dart';
import '../../../core/design/tokens.dart';
import '../../../domain/models.dart';
import 'comic_cards.dart';

/// Grid or list of items. [empty] is shown when [items] is empty.
class ComicItemsView extends StatelessWidget {
  const ComicItemsView({
    super.key,
    required this.items,
    required this.layout,
    required this.empty,
  });
  final List<LibraryItem> items;
  final LibraryLayout layout;
  final Widget empty;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return empty;
    const bottom = EdgeInsets.only(bottom: AppSpacing.lg);
    if (layout == LibraryLayout.grid) {
      return GridView.builder(
        padding: bottom,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 190,
          mainAxisExtent: 290,
          crossAxisSpacing: AppSpacing.lg,
          mainAxisSpacing: AppSpacing.lg,
        ),
        itemCount: items.length,
        itemBuilder: (context, i) =>
            ComicGridCard(key: ValueKey(items[i].id), item: items[i]),
      );
    }
    return ListView.separated(
      padding: bottom,
      itemCount: items.length,
      separatorBuilder: (context, i) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, i) =>
          ComicListTile(key: ValueKey(items[i].id), item: items[i]),
    );
  }
}
