import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design/ambient_background.dart';
import '../../core/design/tokens.dart';
import '../../core/layout/layout_class.dart';
import '../../domain/models.dart';
import 'pages/collections_page.dart';
import 'pages/favourites_page.dart';
import 'pages/history_page.dart';
import 'pages/home_page.dart';
import 'pages/library_page.dart';
import 'pages/settings_page.dart';
import 'providers.dart';
import 'widgets/glass_bottom_nav.dart';
import 'widgets/right_panel.dart';
import 'widgets/sample_badge.dart';
import 'widgets/sidebar.dart';

/// Responsive frame, decided by WIDTH (not platform), see layout_class.dart:
///   compact  (< 700):   content + floating bottom glass nav
///   medium   (700-1099): floating sidebar + content
///   expanded (>= 1100):  floating sidebar + content + right panel
class DashboardShell extends ConsumerWidget {
  const DashboardShell({super.key});

  static const double sidebarWidth = 208;
  static const double rightPanelWidth = 320;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final section = ref.watch(navSectionProvider);
    const m = AppSpacing.floatingMargin;
    return Scaffold(
      body: AmbientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final lc = classifyWidth(constraints.maxWidth);
              final content = _Content(section: section, layoutClass: lc);
              return switch (lc) {
                LayoutClass.compact => Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(m, m, m, 0),
                        child: content,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(m),
                      child: GlassBottomNav(),
                    ),
                  ],
                ),
                LayoutClass.medium => Padding(
                  padding: const EdgeInsets.all(m),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(width: sidebarWidth, child: Sidebar()),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(child: content),
                    ],
                  ),
                ),
                LayoutClass.expanded => Padding(
                  padding: const EdgeInsets.all(m),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(width: sidebarWidth, child: Sidebar()),
                      const SizedBox(width: AppSpacing.lg),
                      Expanded(child: content),
                      const SizedBox(width: AppSpacing.lg),
                      const SizedBox(
                        width: rightPanelWidth,
                        child: RightPanel(),
                      ),
                    ],
                  ),
                ),
              };
            },
          ),
        ),
      ),
    );
  }
}

class _Content extends ConsumerWidget {
  const _Content({required this.section, required this.layoutClass});
  final NavSection section;
  final LayoutClass layoutClass;

  Widget _page() => switch (section) {
    NavSection.home => HomePage(layoutClass: layoutClass),
    NavSection.library => LibraryPage(layoutClass: layoutClass),
    NavSection.collections => CollectionsPage(layoutClass: layoutClass),
    NavSection.history => const HistoryPage(),
    NavSection.favourites => const FavouritesPage(),
    NavSection.settings => const SettingsPage(),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compact = layoutClass == LayoutClass.compact;
    final hasSample = ref.watch(
      libraryItemsProvider.select((items) => items.any((i) => i.isSample)),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                section.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: compact
                    ? AppText.title
                    : AppText.display.copyWith(fontSize: 28),
              ),
            ),
            if (hasSample) const SampleBadge(),
            if (compact && section != NavSection.settings) ...[
              const SizedBox(width: AppSpacing.xs),
              IconButton(
                tooltip: 'Settings',
                onPressed: () => ref
                    .read(navSectionProvider.notifier)
                    .select(NavSection.settings),
                icon: const Icon(
                  Icons.settings_rounded,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: AnimatedSwitcher(
            duration: AppMotion.base,
            switchInCurve: AppMotion.curve,
            layoutBuilder: (current, previous) =>
                Stack(fit: StackFit.expand, children: [...previous, ?current]),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.012),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: KeyedSubtree(key: ValueKey(section), child: _page()),
          ),
        ),
      ],
    );
  }
}
