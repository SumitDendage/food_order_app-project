part of 'order_bloc.dart';

abstract class OrderEvent {}

class LoadRestaurants extends OrderEvent {}

class SelectRestaurant extends OrderEvent {
  final Restaurant restaurant;
  SelectRestaurant(this.restaurant);
}

class AddItem extends OrderEvent {
  final MenuItem item;
  AddItem(this.item);
}

class RemoveItem extends OrderEvent {
  final MenuItem item;
  RemoveItem(this.item);
}

class StartCheckout extends OrderEvent {
  final String address;
  final String paymentMethod;
  StartCheckout({required this.address, required this.paymentMethod});
}

class PlaceOrder extends OrderEvent {
  final String address;
  final String paymentMethod;
  PlaceOrder({required this.address, required this.paymentMethod});
}

class ResetOrder extends OrderEvent {}
