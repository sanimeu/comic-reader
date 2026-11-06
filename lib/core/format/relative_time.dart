/// Short human-readable "time since" text for History rows.
/// Pure function (takes [now]) so it is deterministic and unit-testable.
/// "Yesterday" means 24 to 47 hours ago, not calendar-yesterday.
String formatRelative(DateTime then, DateTime now) {
  final diff = now.difference(then);
  if (diff.isNegative || diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
  if (diff.inHours < 24) return '${diff.inHours} h ago';
  if (diff.inDays == 1) return 'Yesterday';
  if (diff.inDays < 7) return '${diff.inDays} days ago';
  if (diff.inDays < 30) {
    final w = diff.inDays ~/ 7;
    return w == 1 ? '1 week ago' : '$w weeks ago';
  }
  final m = then.month.toString().padLeft(2, '0');
  final d = then.day.toString().padLeft(2, '0');
  return '${then.year}-$m-$d';
}
