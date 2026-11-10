import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryRepository {
  static const _key = 'recent_searches';
  static const int maxItems = 5;

  Future<List<String>> getRecent() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<List<String>> add(String query) async {
    final text = query.trim();
    final recent = await getRecent();
    if (text.isEmpty) return recent;

    final updated = [
      text,
      ...recent.where((r) => r.toLowerCase() != text.toLowerCase()),
    ].take(maxItems).toList();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, updated);
    return updated;
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
