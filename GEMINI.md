# Intranet of Schools (INS) Project Context

This document provides essential context for the "Intranet of Schools" Flutter project to aid in development and maintenance.

## 1. Project Overview

- **Name:** `ins` (Intranet of Schools)
- **Description:** A responsive Flutter application providing a user interface for the Intranet of Schools platform. It's designed for managing user accounts, interacting with platform features, and accessing school-related information across mobile, web, and desktop.
- **Target Platforms:** Android, iOS, Linux, macOS, Windows, and Web.

## 2. Project Structure

The project follows a standard Flutter structure.

- `lib/`: Main application source code.
    - `main.dart`: Application entry point.
    - `app.dart`: Root application widget and setup.
    - `appstate.dart`: Manages global application state (session, user data) likely using `provider`.
    - `backend.dart`: Contains hooks and functions for communicating with the backend API.
    - `models/`: Data models for entities like `User`, `School`, `Session`, `ChatMessage`, etc.
    - `pages/`: UI screens for different parts of the app (e.g., `home`, `signin`, `dashboard`).
    - `widgets/`: Reusable UI components (e.g., `locale_chooser`, `loading`).
    - `utils/`: Utility functions (e.g., `logger`, `email_validator`).
    - `theme.dart`: Application-wide theme and styling.
    - `l10n/`: Localization files.
- `assets/`: Static assets.
    - `assets/icon/`: Application icons.
- `test/`: Widget and unit tests.
- Platform-specific directories: `android/`, `ios/`, `linux/`, `macos/`, `windows/`, `web/`.

## 3. Dependencies

Key dependencies from `pubspec.yaml`:

- **State Management:**
    - `provider`: For managing application state.
- **UI & UX:**
    - `google_fonts`: For custom fonts.
    - `cupertino_icons`: iOS style icons.
    - `flutter_markdown`: To render Markdown content.
    - `cached_network_image`: To display and cache network images.
    - `transparent_image`: For placeholder images.
    - `intl_phone_number_input`: For formatted phone number input.
- **Networking & Backend:**
    - `http`: For making HTTP requests to the backend.
- **Storage:**
    - `shared_preferences`: For simple key-value storage.
- **Utilities:**
    - `url_launcher`: To launch URLs.
    - `logger`: For application logging.
- **Localization:**
    - `flutter_localizations` & `intl`: For internationalization and localization.

## 4. Code Style and Linting

- The project uses the standard `package:flutter_lints/flutter.yaml` ruleset.
- Custom linting rules can be configured in `analysis_options.yaml`.

## 5. Localization (l10n)

- **Configuration:** `l10n.yaml`
- **Source Directory:** `lib/l10n`
- **Template File:** `app_en.arb` (English)
- **Process:** The app supports internationalization. New translations should be added as `.arb` files in `lib/l10n/` and code generation must be run to update localizations.

## 6. Build & Deployment

- **Firebase Hosting:** The project is configured to deploy the web build to Firebase Hosting.
    - The public directory is `build/web`.
    - Configuration is in `firebase.json`.
- **CI/CD:** A GitHub Actions workflow is set up in `.github/workflows/firebase-hosting-pull-request.yml`.
    - **Trigger:** On pull requests to the main repository.
    - **Job:** It builds the Flutter web application (`flutter build web`) and deploys it to a Firebase Hosting preview channel.
    - **Secrets:** Requires `FIREBASE_SERVICE_ACCOUNT_INTRANET_OF_SCHOOLS` for deployment.

## 7. Application Startup Flow

1.  The app starts via `main.dart`.
2.  The global `AppState` is loaded from `appstate.dart`, which likely restores session/user data from `shared_preferences`.
3.  If a user is not logged in, they are directed to the sign-in/sign-up pages (`lib/pages/sign/`).
4.  Upon successful login, a session and user object are created and stored in `AppState`.
5.  The user is then navigated to the appropriate dashboard (`lib/pages/dashboard/`) based on their role and school association.