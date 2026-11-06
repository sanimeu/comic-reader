import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'glass_quality.dart';
import 'tokens.dart';

enum GlassKind { panel, card, readerChrome }

/// The signature surface. Layers (bottom to top):
/// soft shadow -> (blur | opaque-ish fill) -> tint fill -> inner top highlight -> gradient glass border.
/// readerChrome NEVER blurs (performance rule), regardless of quality setting.
class GlassPanel extends ConsumerWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.kind = GlassKind.panel,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.glow = false,
    this.blurOverride, // set false inside scrolling lists to drop per-card blur
  });

  final Widget child;
  final GlassKind kind;
  final EdgeInsetsGeometry padding;
  final bool glow;
  final bool? blurOverride;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quality = ref.watch(glassQualityProvider);
    final isPanel = kind == GlassKind.panel || kind == GlassKind.readerChrome;
    final radius = isPanel ? AppRadii.panelR : AppRadii.cardR;

    final wantsBlur =
        kind != GlassKind.readerChrome &&
        quality == GlassQuality.high &&
        (blurOverride ?? true);

    final double fillAlpha;
    if (kind == GlassKind.readerChrome) {
      fillAlpha = AppGlass.readerChromeFillAlpha;
    } else if (wantsBlur) {
      fillAlpha = isPanel ? AppGlass.panelFillAlpha : AppGlass.cardFillAlpha;
    } else {
      fillAlpha = isPanel
          ? AppGlass.lowPanelFillAlpha
          : AppGlass.lowCardFillAlpha;
    }
    final sigma = isPanel ? AppGlass.panelSigma : AppGlass.cardSigma;

    final fillColor = kind == GlassKind.readerChrome
        ? AppColors.charcoal1.withValues(alpha: fillAlpha)
        : Colors.white.withValues(alpha: fillAlpha);

    Widget surface = DecoratedBox(
      decoration: BoxDecoration(color: fillColor, borderRadius: radius),
      child: Padding(padding: padding, child: child),
    );
    if (wantsBlur) {
      surface = BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: surface,
      );
    }

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          ...(isPanel ? AppGlass.panelShadow : AppGlass.cardShadow),
          if (glow) ...AppGlass.accentGlow(),
        ],
      ),
      child: CustomPaint(
        foregroundPainter: _GlassBorderPainter(radius: radius.topLeft.x),
        child: ClipRRect(borderRadius: radius, child: surface),
      ),
    );
  }
}

class _GlassBorderPainter extends CustomPainter {
  _GlassBorderPainter({required this.radius});
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = RRect.fromRectAndRadius(
      (Offset.zero & size).deflate(0.5),
      Radius.circular(radius),
    );
    // Gradient glass border: bright top-left, faint bottom-right.
    final border = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: AppGlass.borderTopLeftAlpha),
          Colors.white.withValues(alpha: AppGlass.borderBottomRightAlpha),
        ],
      ).createShader(Offset.zero & size);
    canvas.drawRRect(rrect, border);

    // Inner top highlight: 1px line just inside the top edge.
    final hl = Paint()
      ..color = Colors.white.withValues(alpha: AppGlass.innerHighlightAlpha)
      ..strokeWidth = 1;
    canvas.drawLine(Offset(radius, 1.5), Offset(size.width - radius, 1.5), hl);
  }

  @override
  bool shouldRepaint(_GlassBorderPainter old) => old.radius != radius;
}
