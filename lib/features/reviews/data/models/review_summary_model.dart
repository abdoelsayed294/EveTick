/// Number of reviews per star, and what is derived from it.
class ReviewSummary {
  const ReviewSummary({required this.counts});

  const ReviewSummary.empty() : counts = const {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

  /// star (1..5) -> number of reviews with that rating.
  final Map<int, int> counts;

  int get total => counts.values.fold(0, (sum, c) => sum + c);

  double get average {
    final count = total;
    if (count == 0) return 0;
    var stars = 0;
    counts.forEach((star, c) => stars += star * c);
    return stars / count;
  }

  String get averageText => average.toStringAsFixed(1);

  /// Stars to draw under the big number.
  int get roundedAverage => average.round().clamp(0, 5).toInt();

  /// 0..1, used for the width of the bar of [star].
  double fraction(int star) {
    final count = total;
    return count == 0 ? 0 : (counts[star] ?? 0) / count;
  }
}
