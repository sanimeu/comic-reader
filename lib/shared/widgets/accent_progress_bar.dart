import 'package:flutter/material.dart';
import '../../core/design/tokens.dart';

class AccentProgressBar extends StatelessWidget {
  const AccentProgressBar({super.key, required this.value, this.height = 4});
  final double value; // 0.0 to 1.0
  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(height / 2),
    child: LinearProgressIndicator(
      value: value.clamp(0.0, 1.0).toDouble(),
      minHeight: height,
      color: AppColors.accent,
      backgroundColor: Colors.white12,
    ),
  );
}
