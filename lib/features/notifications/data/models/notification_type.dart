/// What the notification is about. Saved in the document as `type`.
enum NotificationType {
  hotDeal('hot_deal'),
  newEvent('new_event'),
  ticketConfirmed('ticket_confirmed'),
  profileUpdated('profile_updated'),
  artistFollowed('artist_followed'),

  /// Any type this version of the app does not know yet.
  general('general');

  const NotificationType(this.value);

  final String value;

  static NotificationType fromValue(String? value) {
    for (final type in NotificationType.values) {
      if (type.value == value) return type;
    }
    return NotificationType.general;
  }

  /// Shown under the "Events" chip.
  bool get isEvent =>
      this == NotificationType.hotDeal || this == NotificationType.newEvent;

  /// Shown under the "Tickets" chip.
  bool get isTicket => this == NotificationType.ticketConfirmed;
}
