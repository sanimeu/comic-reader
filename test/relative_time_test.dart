import 'package:comic_reader/core/format/relative_time.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 6, 15, 12);
  String f(Duration ago) => formatRelative(now.subtract(ago), now);

  test('buckets', () {
    expect(f(const Duration(seconds: 20)), 'Just now');
    expect(f(const Duration(minutes: 5)), '5 min ago');
    expect(f(const Duration(hours: 3)), '3 h ago');
    expect(f(const Duration(hours: 30)), 'Yesterday');
    expect(f(const Duration(days: 3)), '3 days ago');
    expect(f(const Duration(days: 7)), '1 week ago');
    expect(f(const Duration(days: 15)), '2 weeks ago');
  });

  test('older than 30 days shows an ISO date; future times are "Just now"', () {
    expect(formatRelative(DateTime(2026, 1, 5), now), '2026-01-05');
    expect(formatRelative(now.add(const Duration(hours: 1)), now), 'Just now');
  });
}
