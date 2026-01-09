# BloodConnect

A Flutter app that connects blood donors and health workers. Donors can register, pass a health questionnaire, view and respond to urgent blood requests, schedule donation appointments, and track eligibility. Health workers can manage incoming requests, verify donations, and search donor lists. The app uses Firebase (Auth + Firestore), Google Places, and Bloc with dependency injection via `get_it`.

## Demo

<video controls width="640" style="max-width: 100%; height: auto;">
  <source src="https://github.com/palpatel224/BloodConnect/raw/main/demo.mp4" type="video/mp4" />
  Your browser does not support inline video. [Watch the demo](https://github.com/palpatel224/BloodConnect/raw/main/demo.mp4).
</video>

> If the player does not appear on GitHub, use the direct link: https://github.com/palpatel224/BloodConnect/raw/main/demo.mp4

## Featuress

- **Authentication**: Email/password and Google sign-in backed by Firebase Auth, with role-aware routing after login.
- **Role chooser**: Pick Donor or Health Worker; returns users to their role home if already registered.
- **Donor experience**:
  - Complete donor profile and health questionnaire before accessing the home screen.
  - Discover urgent blood requests, search/filter requests by blood group and hospital (Google Places autocomplete), request blood, and schedule donation appointments.
  - Track upcoming appointments, recent donations, donation eligibility, credits, and total donations.
- **Health worker experience**:
  - Manage blood requests (review, update status, delete) and view pending counts/units needed.
  - Verify donation appointments and browse/search donor lists by name and blood type.
- **Location services**: Google Places autocomplete and details via `.env`-provided API key.
- **Theming**: Light/dark mode toggle persisted with `SharedPreferences`.

## Tech Stack

- Flutter 3.6.2, Dart
- Firebase Auth, Cloud Firestore, Firebase Core
- Bloc (`flutter_bloc`), `get_it`, `provider`
- Google Places (`google_places_flutter`, `http`, `uuid`, `flutter_dotenv`)
- Geolocator/Geocoding, Lottie, Flutter SVG, Maps Launcher

## Project Structure (high level)

- `lib/main.dart` – app entry, DI setup, theme, routes (`/` splash → `/auth`).
- `lib/service_locator.dart` – registers datasources, repositories, use cases, blocs.
- `lib/core/` – colors, errors, location/places services, utilities.
- `lib/login/` – clean-architecture folders (`0_data`, `1_domain`, `2_application`) for auth flows.
- `lib/donor_finder/` – donor features (home, appointments, find requests, donor info, health questionnaire, request screen).
- `lib/health_worker/` – health worker features (home, manage requests, donor list, donation appointments, worker info).
- `assets/` – app images, SVGs, Lottie, etc.

## Prerequisites

- Flutter SDK installed and on PATH
- A Firebase project with Firestore and Authentication enabled
- Google Places API key
- Platform configs added:
  - `android/app/google-services.json`
  - `ios/Runner/GoogleService-Info.plist`

## Environment Variables

Create a `.env` file in the project root:

```env
GOOGLE_MAPS_KEY=your_places_api_key
```

## Setup

1. Install dependencies:
   ```bash
   flutter pub get
   ```
2. iOS only: install pods once after config files are added:
   ```bash
   cd ios && pod install && cd ..
   ```
3. (Optional) Enable dark mode persistence by granting storage permissions if prompted on Android.

## Running the App

```bash
flutter run
```

- Use `flutter run -d <device_id>` to target a specific simulator/emulator.

## Notes

- The app uses clean architecture naming (`0_data`, `1_domain`, `2_application`) per feature.
- Google Places requests require the `.env` key and network access.
- Firestore collections in use include `Donor_Finder`, `Health_Worker`, and blood request/appointment collections referenced by the feature modules.
