String formatCount(int value) {
  if (value >= 1000000) return '${_trim(value / 1000000)}M';
  if (value >= 1000) return '${_trim(value / 1000)}k';
  return '$value';
}

String _trim(double v) {
  final text = v.toStringAsFixed(1);
  return text.endsWith('.0') ? text.substring(0, text.length - 2) : text;
}

String followersLabel(int count) =>
    '${formatCount(count)} ${count == 1 ? 'follower' : 'followers'}';
