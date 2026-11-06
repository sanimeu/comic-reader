import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/tokens.dart';
import '../../../domain/models.dart';
import '../providers.dart';

class FavouriteButton extends ConsumerWidget {
  const FavouriteButton({super.key, required this.item});
  final LibraryItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Tooltip(
      message: item.isFavourite
          ? 'Remove from favourites'
          : 'Add to favourites',
      child: Material(
        color: Colors.black.withValues(alpha: 0.45),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () =>
              ref.read(libraryItemsProvider.notifier).toggleFavourite(item.id),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(
              item.isFavourite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              size: 16,
              color: item.isFavourite ? AppColors.accent : Colors.white70,
            ),
          ),
        ),
      ),
    );
  }
}
