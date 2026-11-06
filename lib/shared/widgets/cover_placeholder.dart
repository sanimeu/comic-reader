import 'package:flutter/material.dart';
import '../../core/design/tokens.dart';

/// Generated cover (no network, no image files): a dark two-tone gradient whose
/// hue comes from [seed], with the title's first letter as a quiet watermark.
/// Replaced by real cached covers in Phase 3; this stays as the fallback.
class CoverPlaceholder extends StatelessWidget {
  const CoverPlaceholder({
    super.key,
    required this.seed,
    required this.title,
    this.radius,
  });
  final int seed;
  final String title;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    final hue = ((seed.abs() * 47) % 360).toDouble();
    final top = HSLColor.fromAHSL(1, hue, 0.42, 0.30).toColor();
    final bottom = HSLColor.fromAHSL(1, (hue + 48) % 360, 0.40, 0.14).toColor();
    final letter = title.isEmpty
        ? '?'
        : String.fromCharCode(title.runes.first).toUpperCase();
    return ClipRRect(
      borderRadius: radius ?? AppRadii.coverR,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [top, bottom],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                letter,
                style: AppText.display.copyWith(
                  fontSize: 44,
                  color: Colors.white.withValues(alpha: 0.35),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
