/// 850 -> "850", 12400 -> "12.4k", 1200000 -> "1.2M"
String formatCount(int value) {
  if (value >= 1000000) return '${_trim(value / 1000000)}M';
  if (value >= 1000) return '${_trim(value / 1000)}k';
  return '$value';
}

/// "12.0" -> "12", "12.4" -> "12.4"
String _trim(double v) {
  final text = v.toStringAsFixed(1);
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}

/// "1 follower" / "0 followers" / "12.4k followers"
String followersLabel(int count) =>
    '${formatCount(count)} ${count == 1 ? 'follower' : 'followers'}';
