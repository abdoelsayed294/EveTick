/// Where the terms screen is opened from.
enum TermsMode {
  /// Opened from the sign up checkbox. The screen pops with `true` (agree)
  /// or `false` (decline) and nothing is saved yet (the account doesn't exist).
  signup,

  /// Opened from the profile. Acceptance is read from / saved to the user doc.
  profile,
}
