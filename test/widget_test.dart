// Smoke test: the real application root (ComicReaderApp, see lib/main.dart)
// starts inside a ProviderScope and shows the dashboard without errors.
// This replaces the counter test that `flutter create` generates (it referenced MyApp).
import 'package:comic_reader/features/dashboard/dashboard_shell.dart';
import 'package:comic_reader/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app starts on the dashboard without errors', (
    WidgetTester tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1280, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const ProviderScope(child: ComicReaderApp()));
    await tester.pumpAndSettle();

    expect(find.byType(ComicReaderApp), findsOneWidget);
    expect(find.byType(DashboardShell), findsOneWidget);
    expect(find.text('Comic Reader'), findsOneWidget); // sidebar brand
    expect(tester.takeException(), isNull);
  });
}
