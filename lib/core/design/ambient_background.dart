import 'package:flutter/material.dart';
import 'tokens.dart';

/// Pure black canvas with faint charcoal lights and a soft accent bloom.
/// Glass blurs THIS, so it must sit behind every glass screen.
/// [artwork] optionally adds a heavily blurred cover backdrop (Home hero).
class AmbientBackground extends StatelessWidget {
  const AmbientBackground({super.key, required this.child, this.artwork});
  final Widget child;
  final ImageProvider? artwork;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: AppColors.canvas),
        if (artwork != null)
          Opacity(
            opacity: 0.35,
            child: Image(
              image: ResizeImage(artwork!, width: 64),
              fit: BoxFit.cover,
              filterQuality: FilterQuality.low,
            ),
          ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(-0.7, -0.8),
              radius: 1.1,
              colors: [
                AppColors.accent.withValues(alpha: 0.09),
                Colors.transparent,
              ],
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: const Alignment(0.9, 0.9),
              radius: 1.0,
              colors: [
                AppColors.charcoal3.withValues(alpha: 0.55),
                Colors.transparent,
              ],
            ),
          ),
        ),
        child,
      ],
    );
  }
}
