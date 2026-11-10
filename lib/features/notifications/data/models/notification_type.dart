enum NotificationType {
  hotDeal('hot_deal'),
  newEvent('new_event'),
  ticketConfirmed('ticket_confirmed'),
  profileUpdated('profile_updated'),
  artistFollowed('artist_followed'),

  general('general');

  const NotificationType(this.value);

  final String value;

  static NotificationType fromValue(String? value) {
    for (final type in NotificationType.values) {
      if (type.value == value) return type;
    }
    return NotificationType.general;
  }

  bool get isEvent =>
      this == NotificationType.hotDeal || this == NotificationType.newEvent;

  bool get isTicket => this == NotificationType.ticketConfirmed;
}
