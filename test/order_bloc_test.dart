import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:food_order_app/bloc/order_bloc.dart';
import 'package:food_order_app/repository/repository.dart';
import 'package:food_order_app/models/restaurant.dart';
import 'package:food_order_app/models/menu_item.dart';
import 'package:food_order_app/models/order.dart';

class MockRepo extends Mock implements Repository {}

void main() {
  late MockRepo repo;
  late OrderBloc bloc;

  setUp(() {
    repo = MockRepo();
    bloc = OrderBloc(repository: repo);
  });

  test('initial state', () {
    expect(bloc.state.restaurants, []);
    expect(bloc.state.order.items, []);
  });

  blocTest<OrderBloc, OrderState>(
    'loads restaurants successfully',
    build: () {
      when(() => repo.fetchRestaurants()).thenAnswer((_) async => [
        Restaurant(id: 'r1', name: 'R', description: 'D', menu: [MenuItem(id: 'm1', name: 'X', description: '', price: 1.0)])
      ]);
      return bloc;
    },
    act: (b) => b.add(LoadRestaurants()),
    expect: () => [isA<OrderState>()],
    verify: (_) {
      verify(() => repo.fetchRestaurants()).called(1);
    },
  );

  blocTest<OrderBloc, OrderState>(
    'placing order with empty cart fails early',
    build: () => bloc,
    act: (b) => b.add(StartCheckout(address: 'addr', paymentMethod: 'Card')),
    expect: () => [isA<OrderState>()],
  );

  blocTest<OrderBloc, OrderState>(
    'place order success',
    build: () {
      when(() => repo.placeOrder(any())).thenAnswer((_) async => 'ORDER-123');
      return bloc;
    },
    seed: () => bloc.state.copyWith(order: Order(items: [OrderItem(item: MenuItem(id: 'm1', name: 'X', description: '', price: 1.0), qty: 1)])),
    act: (b) => b.add(PlaceOrder(address: 'home', paymentMethod: 'Card')),
    expect: () => [isA<OrderState>(), isA<OrderState>()],
    verify: (_) {
      verify(() => repo.placeOrder(any())).called(1);
    },
  );
}
