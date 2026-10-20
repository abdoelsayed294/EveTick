/// Can the signed-in user write a review for this event?
enum ReviewEligibility {
  allowed,
  notAttended,
  alreadyReviewed;

  /// Shown when the user taps "Write a Review" and is not allowed to.
  String get message {
    switch (this) {
      case ReviewEligibility.allowed:
        return '';
      case ReviewEligibility.notAttended:
        return 'Only attendees with a ticket can review this event';
      case ReviewEligibility.alreadyReviewed:
        return 'You already reviewed this event';
    }
  }
}
