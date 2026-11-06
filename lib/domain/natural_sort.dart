/// Natural ordering: "page2" < "page10"; case-insensitive; stable on ties.
int naturalCompare(String a, String b) {
  final ta = _tokens(a), tb = _tokens(b);
  final n = ta.length < tb.length ? ta.length : tb.length;
  for (var i = 0; i < n; i++) {
    final x = ta[i], y = tb[i];
    final xd = int.tryParse(x), yd = int.tryParse(y);
    int c;
    if (xd != null && yd != null) {
      c = xd.compareTo(yd);
      if (c == 0) c = x.length.compareTo(y.length); // "01" vs "1"
    } else {
      c = x.toLowerCase().compareTo(y.toLowerCase());
    }
    if (c != 0) return c;
  }
  return ta.length.compareTo(tb.length);
}

final _re = RegExp(r'(\d+|\D+)');
List<String> _tokens(String s) =>
    _re.allMatches(s).map((m) => m.group(0)!).toList();
