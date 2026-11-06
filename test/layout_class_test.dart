import 'package:comic_reader/core/layout/layout_class.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test(
    'thresholds: 700 and 1100 are the lower bounds of medium and expanded',
    () {
      expect(classifyWidth(320), LayoutClass.compact);
      expect(classifyWidth(699.9), LayoutClass.compact);
      expect(classifyWidth(700), LayoutClass.medium);
      expect(classifyWidth(1099.9), LayoutClass.medium);
      expect(classifyWidth(1100), LayoutClass.expanded);
      expect(classifyWidth(1920), LayoutClass.expanded);
    },
  );
}
