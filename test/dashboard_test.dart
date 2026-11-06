import 'package:comic_reader/features/dashboard/widgets/glass_bottom_nav.dart';
import 'package:comic_reader/features/dashboard/widgets/right_panel.dart';
import 'package:comic_reader/features/dashboard/widgets/sidebar.dart';
import 'package:comic_reader/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pumpAt(WidgetTester t, Size size) async {
  await t.binding.setSurfaceSize(size);
  addTearDown(() => t.binding.setSurfaceSize(null));
  await t.pumpWidget(const ProviderScope(child: ComicReaderApp()));
  await t.pumpAndSettle();
}

void main() {
  testWidgets(
    'expanded (1280 wide): sidebar + right panel, no bottom nav, stats shown once',
    (t) async {
      await _pumpAt(t, const Size(1280, 800));
      expect(find.byType(Sidebar), findsOneWidget);
      expect(find.byType(RightPanel), findsOneWidget);
      expect(find.byType(GlassBottomNav), findsNothing);
      expect(find.text('Reading stats'), findsOneWidget);
      expect(t.takeException(), isNull);
    },
  );

  testWidgets('medium (900 wide): sidebar, no right panel, stats inline once', (
    t,
  ) async {
    await _pumpAt(t, const Size(900, 800));
    expect(find.byType(Sidebar), findsOneWidget);
    expect(find.byType(RightPanel), findsNothing);
    expect(find.byType(GlassBottomNav), findsNothing);
    expect(find.text('Reading stats'), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('compact (400 wide): bottom nav only, stats inline once', (
    t,
  ) async {
    await _pumpAt(t, const Size(400, 800));
    expect(find.byType(Sidebar), findsNothing);
    expect(find.byType(RightPanel), findsNothing);
    expect(find.byType(GlassBottomNav), findsOneWidget);
    expect(find.text('Reading stats'), findsOneWidget);
    expect(t.takeException(), isNull);
  });

  testWidgets('sample data is labelled as sample', (t) async {
    await _pumpAt(t, const Size(1280, 800));
    expect(find.text('Sample data'), findsOneWidget);
  });

  testWidgets(
    'Library: search with no match shows empty state, clearing restores the grid',
    (t) async {
      await _pumpAt(t, const Size(1280, 800));
      await t.tap(find.text('Library'));
      await t.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      // Newest-added sample item is first in the default sort, so it is on screen.
      expect(find.text('Orbit Street Blues'), findsOneWidget);

      await t.enterText(find.byType(TextField), 'zzzzzz');
      await t.pumpAndSettle();
      expect(find.text('No comics match your search'), findsOneWidget);
      expect(find.text('Orbit Street Blues'), findsNothing);

      await t.tap(find.text('Clear search & filters'));
      await t.pumpAndSettle();
      expect(find.text('Orbit Street Blues'), findsOneWidget);
      expect(
        t.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty,
      );
    },
  );

  testWidgets('Library (compact): filter button opens the filter sheet', (
    t,
  ) async {
    await _pumpAt(t, const Size(400, 800));
    await t.tap(find.text('Library'));
    await t.pumpAndSettle();
    await t.tap(find.byTooltip('Filters'));
    await t.pumpAndSettle();
    expect(find.text('Filters'), findsOneWidget);
    expect(find.text('Favourites only'), findsOneWidget);
    await t.tap(find.text('Done'));
    await t.pumpAndSettle();
    expect(find.text('Filters'), findsNothing);
  });

  testWidgets('Settings: Low removes every blur, High restores it', (t) async {
    await _pumpAt(t, const Size(1280, 800));
    expect(find.byType(BackdropFilter), findsWidgets);
    await t.tap(find.text('Settings'));
    await t.pumpAndSettle();
    expect(find.text('Glass quality'), findsOneWidget);
    await t.tap(find.text('Low'));
    await t.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsNothing);
    await t.tap(find.text('High'));
    await t.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsWidgets);
  });

  testWidgets('Settings: Open design preview works and back returns', (
    t,
  ) async {
    await _pumpAt(t, const Size(1280, 800));
    await t.tap(find.text('Settings'));
    await t.pumpAndSettle();
    await t.tap(find.text('Open'));
    await t.pumpAndSettle();
    expect(find.text('Design preview'), findsOneWidget);
    await t.tap(find.byTooltip('Back'));
    await t.pumpAndSettle();
    expect(find.text('Glass quality'), findsOneWidget);
  });

  testWidgets('every section opens without layout errors at all three widths', (
    t,
  ) async {
    for (final size in const [
      Size(400, 800),
      Size(900, 800),
      Size(1280, 800),
    ]) {
      await _pumpAt(t, size);
      final compact = size.width < 700;
      // Scope taps to the navigation widget so a stats row labelled the same cannot be hit by mistake.
      final nav = compact ? find.byType(GlassBottomNav) : find.byType(Sidebar);
      final labels = [
        'Library',
        'Collections',
        'History',
        'Favourites',
        'Home',
        if (!compact) 'Settings',
      ];
      for (final label in labels) {
        await t.tap(find.descendant(of: nav, matching: find.text(label)));
        await t.pumpAndSettle();
        expect(t.takeException(), isNull, reason: '$label at ${size.width}');
      }
    }
  });
}
