import '../models/restaurant.dart';
import '../models/menu_item.dart';
import '../models/order.dart';

abstract class Repository {
  Future<List<Restaurant>> fetchRestaurants();
  Future<String> placeOrder(Order order);
}
