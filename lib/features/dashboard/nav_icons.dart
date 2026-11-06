import 'package:flutter/material.dart';
import '../../domain/models.dart';

extension NavSectionIcon on NavSection {
  IconData get icon => switch (this) {
    NavSection.home => Icons.home_rounded,
    NavSection.library => Icons.collections_bookmark_rounded,
    NavSection.collections => Icons.folder_special_rounded,
    NavSection.history => Icons.history_rounded,
    NavSection.favourites => Icons.favorite_rounded,
    NavSection.settings => Icons.settings_rounded,
  };
}
