import 'package:flutter/material.dart';
import '../../../core/design/tokens.dart';

/// Shown whenever the library contains sample items, so nobody mistakes them for real files.
class SampleBadge extends StatelessWidget {
  const SampleBadge({super.key});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.xs + 2,
    ),
    decoration: BoxDecoration(
      borderRadius: AppRadii.controlR,
      color: AppColors.accent.withValues(alpha: 0.16),
      border: Border.all(color: AppColors.accent.withValues(alpha: 0.5)),
    ),
    child: Text(
      'Sample data',
      style: AppText.label.copyWith(color: AppColors.textPrimary),
    ),
  );
}
