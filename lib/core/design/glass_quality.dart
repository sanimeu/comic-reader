import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GlassQuality { high, low }

/// Chooses a default when the user has not picked one.
/// Windows: High. Android: Low on low-RAM / old devices, otherwise High.
/// The Android signal comes from a tiny platform channel (see
/// platform_snippets/MainActivity_device_info.kt); if it is unavailable we
/// fall back to High and the user can switch manually in Appearance.
class GlassQualityResolver {
  static const _ch = MethodChannel('comic_reader/device');

  static Future<GlassQuality> autoDefault() async {
    if (!Platform.isAndroid) return GlassQuality.high;
    try {
      final info = await _ch.invokeMapMethod<String, dynamic>('perfClass');
      final lowRam = info?['isLowRamDevice'] == true;
      final memMb = (info?['memoryClassMb'] as int?) ?? 256;
      final sdk = (info?['sdkInt'] as int?) ?? 30;
      if (lowRam || memMb < 192 || sdk < 28) return GlassQuality.low;
      return GlassQuality.high;
    } on MissingPluginException {
      return GlassQuality.high;
    } catch (e) {
      debugPrint('GlassQualityResolver failed: $e');
      return GlassQuality.high;
    }
  }
}

/// null override => use auto default. Persisted by the settings repository (Phase 2).
/// Notifier (not StateProvider) so this compiles on Riverpod 2.x and 3.x.
class GlassQualityOverride extends Notifier<GlassQuality?> {
  @override
  GlassQuality? build() => null;
  void set(GlassQuality? quality) => state = quality;
}

final glassQualityOverrideProvider =
    NotifierProvider<GlassQualityOverride, GlassQuality?>(
      GlassQualityOverride.new,
    );

final glassQualityAutoProvider = FutureProvider<GlassQuality>(
  (_) => GlassQualityResolver.autoDefault(),
);

final glassQualityProvider = Provider<GlassQuality>((ref) {
  final override = ref.watch(glassQualityOverrideProvider);
  if (override != null) return override;
  final auto = ref.watch(glassQualityAutoProvider);
  return switch (auto) {
    AsyncData(:final value) => value,
    _ => GlassQuality.high,
  };
});
