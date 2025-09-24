part of 'order_bloc.dart';

class OrderState {
  final bool loadingRestaurants;
  final List<Restaurant> restaurants;
  final Restaurant? selectedRestaurant;
  final Order order;
  final bool placing;
  final String? error;

  OrderState({
    required this.loadingRestaurants,
    required this.restaurants,
    required this.selectedRestaurant,
    required this.order,
    required this.placing,
    required this.error,
  });

  factory OrderState.initial() => OrderState(
    loadingRestaurants: false,
    restaurants: const [],
    selectedRestaurant: null,
    order: Order(),
    placing: false,
    error: null,
  );

  OrderState copyWith({
    bool? loadingRestaurants,
    List<Restaurant>? restaurants,
    Restaurant? selectedRestaurant,
    Order? order,
    bool? placing,
    String? error,
  }) {
    return OrderState(
      loadingRestaurants: loadingRestaurants ?? this.loadingRestaurants,
      restaurants: restaurants ?? this.restaurants,
      selectedRestaurant: selectedRestaurant ?? this.selectedRestaurant,
      order: order ?? this.order,
      placing: placing ?? this.placing,
      error: error,
    );
  }
}
