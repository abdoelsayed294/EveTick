enum ReviewEligibility {
  allowed,
  notAttended,
  alreadyReviewed;

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
