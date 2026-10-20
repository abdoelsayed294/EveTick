/// Can the signed-in user write a review for this organizer?
enum OrganizerReviewEligibility {
  allowed,
  notAttended,
  alreadyReviewed,

  /// The signed-in user is the organizer being viewed.
  isOrganizer;

  /// Shown when the user taps "Write a Review" and is not allowed to.
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
