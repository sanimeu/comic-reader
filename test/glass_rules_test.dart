import 'package:comic_reader/core/design/glass.dart';
import 'package:comic_reader/core/design/glass_quality.dart';
import 'package:comic_reader/core/design/tokens.dart';
import 'package:comic_reader/features/design_preview/design_preview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _host(Widget child, {GlassQuality? quality}) => ProviderScope(
  overrides: [
    if (quality != null)
      glassQualityOverrideProvider.overrideWith(() => _Fixed(quality)),
  ],
  child: MaterialApp(
    home: Scaffold(body: Center(child: child)),
  ),
);

class _Fixed extends GlassQualityOverride {
  _Fixed(this.q);
  final GlassQuality q;
  @override
  GlassQuality? build() => q;
}

void main() {
  test('approved radii are inside the approved ranges', () {
    expect(AppRadii.panel, inInclusiveRange(20, 28));
    expect(AppRadii.card, inInclusiveRange(14, 20));
  });

  test('accent is the approved cool purple', () {
    expect(AppColors.accent, const Color(0xFF8B6CF6));
  });

  testWidgets('High quality: panel and card use backdrop blur', (t) async {
    await t.pumpWidget(
      _host(
        const Column(
          children: [
            GlassPanel(child: Text('p')),
            GlassPanel(kind: GlassKind.card, child: Text('c')),
          ],
        ),
        quality: GlassQuality.high,
      ),
    );
    expect(find.byType(BackdropFilter), findsNWidgets(2));
  });

  testWidgets('Low quality: no blur anywhere', (t) async {
    await t.pumpWidget(
      _host(
        const Column(
          children: [
            GlassPanel(child: Text('p')),
            GlassPanel(kind: GlassKind.card, child: Text('c')),
          ],
        ),
        quality: GlassQuality.low,
      ),
    );
    expect(find.byType(BackdropFilter), findsNothing);
  });

  testWidgets('Reader chrome never blurs, even on High', (t) async {
    await t.pumpWidget(
      _host(
        const GlassPanel(kind: GlassKind.readerChrome, child: Text('r')),
        quality: GlassQuality.high,
      ),
    );
    expect(find.byType(BackdropFilter), findsNothing);
  });

  testWidgets('blurOverride:false drops blur for cards in lists', (t) async {
    await t.pumpWidget(
      _host(
        const GlassPanel(
          kind: GlassKind.card,
          blurOverride: false,
          child: Text('c'),
        ),
        quality: GlassQuality.high,
      ),
    );
    expect(find.byType(BackdropFilter), findsNothing);
  });

  testWidgets('Design preview: toggling Low removes blur, High restores it', (
    t,
  ) async {
    await t.binding.setSurfaceSize(const Size(1280, 800));
    addTearDown(() => t.binding.setSurfaceSize(null));
    await t.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const DesignPreviewScreen(),
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsWidgets);
    await t.tap(find.text('Low'));
    await t.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsNothing);
    await t.tap(find.text('High'));
    await t.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsWidgets);
  });
}
