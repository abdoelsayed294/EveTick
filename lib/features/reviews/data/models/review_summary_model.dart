class ReviewSummary {
  const ReviewSummary({required this.counts});

  const ReviewSummary.empty() : counts = const {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

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

  int get roundedAverage => average.round().clamp(0, 5).toInt();

  double fraction(int star) {
    final count = total;
    return count == 0 ? 0 : (counts[star] ?? 0) / count;
  }
}
