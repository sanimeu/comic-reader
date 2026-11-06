import 'package:flutter/material.dart';
import '../../../core/design/tokens.dart';
import '../../../domain/models.dart';
import 'comic_cards.dart';

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(2, AppSpacing.xl, 0, AppSpacing.md),
    child: Text(text, style: AppText.title),
  );
}

/// Horizontal row of grid cards (Home shelves).
class HorizontalShelf extends StatelessWidget {
  const HorizontalShelf({super.key, required this.items});
  final List<LibraryItem> items;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 250,
    child: ListView.separated(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      itemCount: items.length,
      separatorBuilder: (context, i) => const SizedBox(width: AppSpacing.lg),
      itemBuilder: (context, i) => SizedBox(
        width: 150,
        child: ComicGridCard(key: ValueKey(items[i].id), item: items[i]),
      ),
    ),
  );
}
