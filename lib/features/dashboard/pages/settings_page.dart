import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/glass.dart';
import '../../../core/design/glass_quality.dart';
import '../../../core/design/tokens.dart';
import '../../design_preview/design_preview_screen.dart';
import '../providers.dart';

/// One blurred panel holding all sections (keeps the blur budget at the sidebar + this + right panel).
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quality = ref.watch(glassQualityProvider);
    final override = ref.watch(glassQualityOverrideProvider);
    final hasSample = ref.watch(
      libraryItemsProvider.select((items) => items.any((i) => i.isSample)),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: GlassPanel(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Appearance', style: AppText.title),
            const SizedBox(height: AppSpacing.xs),
            const Text('Glass quality', style: AppText.body),
            const SizedBox(height: 2),
            const Text(
              'High blurs the background behind panels. Low skips the blur and is lighter on older devices.',
              style: AppText.label,
            ),
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerLeft,
              child: SegmentedButton<GlassQuality>(
                segments: const [
                  ButtonSegment(value: GlassQuality.high, label: Text('High')),
                  ButtonSegment(value: GlassQuality.low, label: Text('Low')),
                ],
                selected: {quality},
                onSelectionChanged: (s) => ref
                    .read(glassQualityOverrideProvider.notifier)
                    .set(s.first),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                if (override != null)
                  TextButton(
                    onPressed: () => ref
                        .read(glassQualityOverrideProvider.notifier)
                        .set(null),
                    child: const Text('Use automatic default'),
                  ),
              ],
            ),
            const Text(
              'Reader navigation, rotation and fit preferences are saved per device.',
              style: AppText.label,
            ),
            const _Divider(),
            const Text('Library', style: AppText.title),
            const SizedBox(height: AppSpacing.sm),
            const _InfoRow(
              icon: Icons.cloud_off_rounded,
              title: 'Stored on this device only',
              text:
                  'Your library lives locally. There are no accounts and no online features.',
            ),
            const SizedBox(height: AppSpacing.md),
            const _InfoRow(
              icon: Icons.folder_open_rounded,
              title: 'Library folders',
              text:
                  'Folder and file import support CBZ, ZIP and PDF. CBR and CB7 still need an additional RAR/7z archive backend.',
            ),
            const _Divider(),
            const Text('Design', style: AppText.title),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Design preview: the original glass test screen.',
                    style: AppText.label,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                OutlinedButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const DesignPreviewScreen(),
                    ),
                  ),
                  child: const Text('Open'),
                ),
              ],
            ),
            const _Divider(),
            const Text('About', style: AppText.title),
            const SizedBox(height: AppSpacing.sm),
            const Text('Comic Reader 0.1.0', style: AppText.body),
            if (hasSample) ...[
              const SizedBox(height: AppSpacing.xs),
              const Text(
                'The comics shown are fictional sample data with generated covers. They disappear once folder scanning exists.',
                style: AppText.label,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
    child: Container(height: 1, color: Colors.white.withValues(alpha: 0.08)),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.title, required this.text});
  final IconData icon;
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: 20, color: AppColors.accent),
      const SizedBox(width: AppSpacing.md),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppText.body),
            const SizedBox(height: 2),
            Text(text, style: AppText.label),
          ],
        ),
      ),
    ],
  );
}
