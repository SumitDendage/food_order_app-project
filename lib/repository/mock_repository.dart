import 'dart:async';
import '../models/restaurant.dart';
import '../models/menu_item.dart';
import '../models/order.dart';
import 'repository.dart';

class MockRepository implements Repository {
  @override
  Future<List<Restaurant>> fetchRestaurants() async {
    // Simulate latency
    await Future.delayed(Duration(milliseconds: 600));
    // Return mocked restaurants with menu
    return [
      Restaurant(
        id: 'r1',
        name: 'Spice Corner',
        description: 'Tasty Indian & fusion dishes',
        menu: [
          MenuItem(id: 'm1', name: 'Butter Chicken', description: 'Creamy tomato', price: 7.99),
          MenuItem(id: 'm2', name: 'Paneer Tikka', description: 'Smoky & spicy', price: 6.49),
        ],
      ),
      Restaurant(
        id: 'r2',
        name: 'Green Bowl',
        description: 'Healthy bowls & salads',
        menu: [
          MenuItem(id: 'm3', name: 'Quinoa Bowl', description: 'Protein-rich', price: 8.99),
          MenuItem(id: 'm4', name: 'Falafel Wrap', description: 'Crunchy & fresh', price: 5.49),
        ],
      ),
    ];
  }

  @override
  Future<String> placeOrder(Order order) async {
    // Simulate network call and random failure
    await Future.delayed(Duration(seconds: 1));
    if (order.items.isEmpty) {
      throw Exception('Cart is empty');
    }
    // For demonstration fail if address contains 'fail'
    if ((order.address ?? '').toLowerCase().contains('fail')) {
      throw Exception('Invalid address provided');
    }
    // Return a fake order ID
    return 'ORDER-${DateTime.now().millisecondsSinceEpoch}';
  }
}
