import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/glass.dart';
import '../../../core/design/tokens.dart';
import '../../../domain/models.dart';
import '../providers.dart';
import 'nav_tile.dart';

/// Floating glass sidebar (medium + expanded). Settings is pinned to the bottom.
class Sidebar extends ConsumerWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(navSectionProvider);
    void go(NavSection s) => ref.read(navSectionProvider.notifier).select(s);
    return GlassPanel(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _Brand(),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (final s in NavSection.values)
                    if (s != NavSection.settings)
                      NavTile(
                        section: s,
                        selected: s == selected,
                        onTap: () => go(s),
                      ),
                ],
              ),
            ),
          ),
          NavTile(
            section: NavSection.settings,
            selected: selected == NavSection.settings,
            onTap: () => go(NavSection.settings),
          ),
        ],
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          borderRadius: AppRadii.controlR,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accent,
              AppColors.accent.withValues(alpha: 0.55),
            ],
          ),
        ),
        child: const Icon(
          Icons.auto_stories_rounded,
          size: 20,
          color: Colors.white,
        ),
      ),
      const SizedBox(width: AppSpacing.md),
      const Expanded(
        child: Text(
          'Comic Reader',
          style: AppText.body,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ],
  );
}
