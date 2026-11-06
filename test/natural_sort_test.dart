import 'package:comic_reader/domain/natural_sort.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('sorts numerically, not lexically', () {
    final l = ['page10.jpg', 'page2.jpg', 'page1.jpg']..sort(naturalCompare);
    expect(l, ['page1.jpg', 'page2.jpg', 'page10.jpg']);
  });
  test('case-insensitive', () {
    final l = ['B2.png', 'a10.png', 'A2.png']..sort(naturalCompare);
    expect(l, ['A2.png', 'a10.png', 'B2.png']);
  });
  test('mixed chapter names', () {
    final l = ['Ch 100', 'Ch 9', 'Ch 10']..sort(naturalCompare);
    expect(l, ['Ch 9', 'Ch 10', 'Ch 100']);
  });
}
