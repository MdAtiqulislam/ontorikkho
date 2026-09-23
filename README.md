# Ontorikkho (ontorikkho)

A Flutter community/commerce app — posts, directory, announcements, cart and checkout in one app.

[![Google Play](https://img.shields.io/badge/Google_Play-Download-414141?style=for-the-badge&logo=google-play&logoColor=white)](https://play.google.com/store/apps/details?id=com.ontorikkho.ontorikkho)


## Features

- Posts: create, edit and browse community posts
- Directory and announcements sections
- Cart and checkout flow
- Auth: OTP and password flows
- FAQ, app version check, bottom navigation with custom app bar

## Tech Stack

- Flutter (Dart)
- GetX for state management and routing
- REST API backend

## Getting Started

```bash
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── app/modules/   # Posts, directory, cart/checkout, auth, announcements
├── models/        # Data models
├── services/      # API and platform services
├── stores/        # Local stores
├── theme/         # App theme
└── main.dart      # App entry point
```

## Notes

- App label: "Ontorikkho" (Android)
- No secrets or keystores are committed to this repository.
