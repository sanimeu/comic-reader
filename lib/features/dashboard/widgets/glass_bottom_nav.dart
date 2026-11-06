import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/glass.dart';
import '../../../core/design/tokens.dart';
import '../../../domain/models.dart';
import '../nav_icons.dart';
import '../providers.dart';

/// Compact (phone-width) navigation. Five destinations; Settings lives in the header.
class GlassBottomNav extends ConsumerWidget {
  const GlassBottomNav({super.key});

  static const destinations = [
    NavSection.home,
    NavSection.library,
    NavSection.collections,
    NavSection.history,
    NavSection.favourites,
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(navSectionProvider);
    return GlassPanel(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          for (final s in destinations)
            Expanded(
              child: _BottomItem(
                section: s,
                selected: s == selected,
                onTap: () => ref.read(navSectionProvider.notifier).select(s),
              ),
            ),
        ],
      ),
    );
  }
}

class _BottomItem extends StatelessWidget {
  const _BottomItem({
    required this.section,
    required this.selected,
    required this.onTap,
  });
  final NavSection section;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.accent : AppColors.textSecondary;
    return Semantics(
      button: true,
      selected: selected,
      label: section.label,
      excludeSemantics: true,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadii.controlR,
          child: AnimatedContainer(
            duration: AppMotion.fast,
            curve: AppMotion.curve,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              borderRadius: AppRadii.controlR,
              color: selected
                  ? AppColors.accent.withValues(alpha: 0.16)
                  : Colors.transparent,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(section.icon, size: 22, color: color),
                const SizedBox(height: 2),
                Text(
                  section.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppText.label.copyWith(fontSize: 11, color: color),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
