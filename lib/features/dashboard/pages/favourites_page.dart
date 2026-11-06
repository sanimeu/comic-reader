import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/empty_state.dart';
import '../providers.dart';
import '../widgets/comic_items_view.dart';

class FavouritesPage extends ConsumerWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ComicItemsView(
      items: ref.watch(favouritesProvider),
      layout: ref.watch(libraryLayoutProvider),
      empty: const EmptyState(
        icon: Icons.favorite_border_rounded,
        title: 'No favourites yet',
        message: 'Tap the heart on any comic to add it here.',
      ),
    );
  }
}
