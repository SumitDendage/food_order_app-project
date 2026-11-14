# Food Order App (Flutter + BLoC)

A Flutter app that walks through one complete food-ordering flow — browse restaurants, pick dishes, manage the cart, check out and get an order confirmation — built to show clean **BLoC** state management, SOLID structure and unit-tested business logic.

![Flutter](https://img.shields.io/badge/Flutter-3-02569B?logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-2.18+-0175C2?logo=dart&logoColor=white)
![BLoC](https://img.shields.io/badge/state-flutter__bloc-6A1B9A)

## The flow

```text
Restaurants ──select──> Menu + cart ──checkout──> Address & payment ──place order──> Confirmation
     ▲                                                                                   │
     └──────────────────────────────── reset order ─────────────────────────────────────┘
```

- Nearby restaurants load from a repository (mocked with simulated network latency).
- Add and remove items; quantities and the total update live.
- Checkout with an address and a payment option (mocked).
- Confirmation screen with simulated order tracking.
- Loading and error states are handled throughout.

## Architecture

```text
lib/
├── main.dart                    # app setup, BlocProvider
├── bloc/                        # OrderBloc, events, state
├── models/                      # Restaurant, MenuItem, Order/OrderItem
├── repository/
│   ├── repository.dart          # Repository interface (dependency inversion)
│   └── mock_repository.dart     # in-memory data with simulated latency
├── screens/flow_screen.dart     # one screen that renders each step from state
└── widgets/simple_error_widget.dart
test/order_bloc_test.dart        # BLoC unit tests (bloc_test + mocktail)
```

`OrderBloc` handles `LoadRestaurants`, `SelectRestaurant`, `AddItem`, `RemoveItem`, `StartCheckout`, `PlaceOrder` and `ResetOrder` and emits immutable `OrderState` snapshots (Equatable). The UI depends only on the `Repository` interface, so the mock can be swapped for a real API client without touching the BLoC or the screens.

## Run it

```bash
git clone https://github.com/SumitDendage/food_order_app-project.git
cd food_order_app-project
flutter create .        # generates android/ios/web platform folders if missing
flutter pub get
flutter run
flutter test            # BLoC unit tests
```

## Author

**Sumit Dendage** · [GitHub](https://github.com/SumitDendage) · [LinkedIn](https://www.linkedin.com/in/sumit-dendage-636a50201) · [Medium](https://dendagesumitbalkrishna123.medium.com)
