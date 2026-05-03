EgyGo — Egypt Travel App

Quick summary
-------------
EgyGo is a Flutter application focused on travel and tourism inside Egypt. The app provides place
and attraction discovery, trip booking and details, payment handling, maps and location support,
live audio/video calls via Agora, and real-time communication using Socket.IO.

Key features
------------

- Browse places and attractions with categories and filters.
- Trip management: trip details, proposals, payment section, and status notifications.
- Payment integration: handles payment callbacks via deep links (success/cancel flows).
- Maps & location: Google Maps integration with Geolocator/Geocoding support.
- Live calls: Agora integration for in-trip audio/video calls.
- Real-time updates: Socket.IO for messaging and live updates.
- State management: `flutter_bloc` with some `get` usage and `get_it` for dependency injection.
- Local storage: `shared_preferences` via `CacheHelper` for session/data caching.
- Localization and fonts: Arabic-supporting fonts included (Cairo, Montserrat, Libre Baskerville,
  etc.).

Architecture & main technologies
--------------------------------

- Framework: Flutter (Dart). See `pubspec.yaml` for SDK compatibility (example: ^3.6.1).
- State management: Bloc (`flutter_bloc`) and `GetMaterialApp` for routing and lightweight
  navigation helpers.
- Project structure: feature-based under `lib/features/` and shared/core logic under `lib/core/`.
- Routing: configured in `lib/core/helper/one_generate_routes.dart` and used by `GetMaterialApp`.

Important files/locations
-------------------------

- `lib/main.dart`: app initialization, Bloc providers, deep link handling for payment callbacks.
- `lib/core/services/deep_link_service.dart`: parses deep links and extracts payment callback info.
- `lib/core/cache/cache_helper.dart`: initializes `SharedPreferences` and provides helpers to
  store/retrieve values.
- `lib/features/trip`: trip-related UI, trip details, payment return screen, and Agora call screens.
- `lib/features/places`: places listing and categorization logic.

Running the project (local)
---------------------------
Prerequisites:

- Flutter SDK matching the project config (see `pubspec.yaml`).
- Android/iOS toolchain set up (Android Studio / Xcode depending on your platform).

Basic commands:

```bash
flutter pub get
flutter run
```

Build release APK (Android):

```bash
flutter build apk --release
```

If you have questions or want to contribute, please open an issue.
