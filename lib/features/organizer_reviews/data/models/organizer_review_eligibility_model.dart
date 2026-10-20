enum OrganizerReviewEligibility {
  allowed,
  notAttended,
  alreadyReviewed,

  isOrganizer;

  String get message {
    switch (this) {
      case OrganizerReviewEligibility.allowed:
        return '';
      case OrganizerReviewEligibility.notAttended:
        return 'Only attendees of this organizer’s events can review them';
      case OrganizerReviewEligibility.alreadyReviewed:
        return 'You already reviewed this organizer';
      case OrganizerReviewEligibility.isOrganizer:
        return 'You can’t review your own organizer account';
    }
  }
}
