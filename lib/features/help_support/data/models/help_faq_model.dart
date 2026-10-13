class HelpFaqModel {
  final String question;
  final String answer;

  const HelpFaqModel({required this.question, required this.answer});

  bool matches(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;
    return question.toLowerCase().contains(q) ||
        answer.toLowerCase().contains(q);
  }
}
