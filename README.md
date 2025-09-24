# Food Order App (Flutter) - Single Workflow

This repository contains a Flutter app demonstrating a single realistic food-ordering workflow (no auth) using **BLoC** architecture, SOLID principles, error handling, and unit tests.

## Features
- Browse local restaurants (mocked)
- View menu and add items to cart
- Checkout with address & payment selection (mock)
- Order confirmation and simulated tracking
- Robust error handling
- BLoC-based state management (flutter_bloc)
- Unit tests for the main BLoC

## Screenshot
A placeholder screenshot is included at `assets/screenshot.png`. Replace it with your own screenshot.

## How to run
1. Ensure you have Flutter installed (2.10+ recommended).
2. Clone or download the project.
3. From the project root:
```bash
flutter pub get
flutter run
```

## Running tests
```bash
flutter test
```

## Notes
- This is a local, offline demo. Replace `lib/repository/mock_repository.dart` with real APIs for production.
- The project structure emphasizes clean architecture and SOLID principles.

