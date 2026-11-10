# EveTick

EveTick is a Flutter mobile app for discovering events and booking tickets. Attendees can browse and search events, pick tickets and seats, pay online, and keep their QR tickets in the app. The UI is fully available in **Arabic and English** with light and dark themes.

<img width="375" height="812" alt="home" src="https://github.com/user-attachments/assets/2074f4e6-a599-4e2b-a3dc-2fcc93567e55" />
<img width="1500" height="3256" alt="landing page for event" src="https://github.com/user-attachments/assets/65a6ac6c-9174-4484-8be6-31887981ad6b" />
<img width="375" height="812" alt="select chair" src="https://github.com/user-attachments/assets/80cecf2c-f4fc-46dd-8a84-95ad76a44b8d" />
<img width="375" height="812" alt="your ticket" src="https://github.com/user-attachments/assets/4d4b2b7e-2ff7-4b3a-b18f-ea47cdbe18ab" />


## Features

- **Auth:** email/password sign-up and login, Google Sign-In, email verification, forgot password, and account deletion with re-authentication.
- **Discovery:** home feed with featured carousel, popular events, and category chips.
- **Search:** recent searches, trending section, quick filters, a filter panel, and sorting (featured and compact result layouts).
- **Event details:** photo gallery, expandable description, map preview, organizer card, and a high-demand badge.
- **Booking flow:** ticket selection, seat selection, checkout, online payment through Paymob (hosted checkout in a WebView), confirmation, and a QR ticket.
- **My tickets:** tickets grouped by phase (upcoming, past) with status badges and QR view.
- **Reviews:** event reviews and organizer reviews with ratings, photos, anonymous posting, eligibility checks, and pagination.
- **Organizers:** organizer profiles with stats and event tabs, plus following/unfollowing.
- **Favorites** and **notifications** (push via Firebase Cloud Messaging, with filters and unread state).
- **Location:** set your location and pick a place on Google Maps.
- **Profile and settings:** edit profile, theme switcher, language switcher, help and support (FAQ and contact form with attachments), terms and conditions.
- **Onboarding** and an animated custom bottom navigation bar.

## Tech stack

| Area | Choice |
| --- | --- |
| Framework | Flutter / Dart |
| State management | `flutter_bloc` (Cubit) with `freezed` states |
| Navigation | `go_router` |
| Dependency injection | `get_it` |
| Backend | Firebase: Auth, Cloud Firestore, Storage, Cloud Messaging |
| Payments | Paymob unified checkout, with payment sessions created by a Cloud Function |
| Maps and location | `google_maps_flutter`, `geolocator`, `geocoding` |
| Networking | `dio` |
| UI | `flutter_screenutil`, `flutter_svg`, `cached_network_image`, `qr_flutter`, `pin_code_fields` |
| Localization | Flutter `gen-l10n` (`app_en.arb`, `app_ar.arb`) |

## Architecture

The app is organized by feature. Each feature is split into three layers:

```
lib/
├── core/            # routing, DI, theming, shared widgets, services, helpers
│   ├── config/      # payment configuration
│   ├── di/          # get_it setup
│   ├── routing/     # go_router routes and navigation helpers
│   ├── services/    # Result/Failure types, Firebase error handling, push notifications, toasts
│   ├── theming/     # light/dark themes, colors, text styles
│   └── widgets/     # reusable UI components
├── features/
│   └── <feature>/
│       ├── data/    # models, repositories, data sources
│       ├── logic/   # Cubits and freezed states
│       └── ui/      # screens and widgets
├── l10n/            # generated localizations (en, ar)
└── main.dart
```

Errors are modeled with a `Result` type and typed `Failure` classes (including Firebase-specific failures), so Cubits handle success and failure explicitly instead of catching exceptions in the UI.

## Getting started

### Prerequisites

- Flutter SDK (stable channel) and a configured Android/iOS toolchain
- A Firebase project (Auth, Firestore, Storage, and Cloud Messaging enabled)
- A Google Maps API key for Android and iOS
- A Paymob account (test mode is fine) and a deployed Cloud Function that creates payment sessions

### Setup

1. Clone the repository and install dependencies:

   ```bash
   git clone https://github.com/abdoelsayed294/EveTick.git
   cd EveTick
   flutter pub get
   ```

2. Connect your own Firebase project and regenerate `lib/firebase_options.dart`:

   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```

3. Add your Google Maps API key to the Android and iOS native configuration.

4. Set your Paymob public key and Cloud Function URL in `lib/core/config/paymob_config.dart`. Keep the Paymob **secret** key on the server only, inside the Cloud Function. Never put it in the app.

5. Generate code (freezed and localizations) and run:

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   flutter run
   ```

## Payment flow

1. The app asks the Cloud Function to create a payment session, authenticating with the user's Firebase ID token.
2. The function returns a `clientSecret`.
3. The app opens Paymob's hosted checkout in a WebView using the public key and the `clientSecret`.
4. After payment, the app shows a confirmation screen and issues the QR ticket.

