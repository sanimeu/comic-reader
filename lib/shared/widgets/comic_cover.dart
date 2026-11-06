import 'dart:io';

import 'package:flutter/material.dart';

import '../../core/design/tokens.dart';
import 'cover_placeholder.dart';

/// Shows an extracted local cover when available and falls back to the
/// generated gradient cover if the cache file is missing or unreadable.
class ComicCover extends StatelessWidget {
  const ComicCover({
    super.key,
    required this.seed,
    required this.title,
    this.path,
    this.radius,
  });

  final int seed;
  final String title;
  final String? path;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    final fallback = CoverPlaceholder(seed: seed, title: title, radius: radius);
    final coverPath = path;
    if (coverPath == null || coverPath.isEmpty) return fallback;

    return ClipRRect(
      borderRadius: radius ?? AppRadii.coverR,
      child: Image.file(
        File(coverPath),
        fit: BoxFit.cover,
        cacheWidth: 600,
        errorBuilder: (context, error, stackTrace) => fallback,
      ),
    );
  }
}
