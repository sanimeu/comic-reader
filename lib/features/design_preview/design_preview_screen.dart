import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design/ambient_background.dart';
import '../../core/design/glass.dart';
import '../../core/design/glass_quality.dart';
import '../../core/design/tokens.dart';

/// Phase 1 visual check, kept (reachable from Settings > Design preview) so glass
/// quality and the approved tokens can still be judged on a real device.
/// Purpose: let you judge the glass on a real Windows window and Android device.
class DesignPreviewScreen extends ConsumerWidget {
  const DesignPreviewScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final q = ref.watch(glassQualityProvider);
    return Scaffold(
      body: AmbientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.floatingMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GlassPanel(
                  glow: true,
                  child: Row(
                    children: [
                      if (Navigator.of(context).canPop())
                        IconButton(
                          tooltip: 'Back',
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                      const Expanded(
                        child: Text('Design preview', style: AppText.title),
                      ),
                      SegmentedButton<GlassQuality>(
                        segments: const [
                          ButtonSegment(
                            value: GlassQuality.high,
                            label: Text('High'),
                          ),
                          ButtonSegment(
                            value: GlassQuality.low,
                            label: Text('Low'),
                          ),
                        ],
                        selected: {q},
                        onSelectionChanged: (s) => ref
                            .read(glassQualityOverrideProvider.notifier)
                            .set(s.first),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Expanded(
                  child: Row(
                    children: [
                      for (var i = 0; i < 3; i++) ...[
                        Expanded(
                          child: GlassPanel(
                            kind: GlassKind.card,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Solo Leveling',
                                  style: AppText.body,
                                ),
                                const SizedBox(height: 4),
                                const Text('Ch. 142', style: AppText.label),
                                const Spacer(),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: 0.78,
                                    minHeight: 4,
                                    color: AppColors.accent,
                                    backgroundColor: Colors.white12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (i < 2) const SizedBox(width: AppSpacing.lg),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
