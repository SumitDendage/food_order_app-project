import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/order.dart';
import '../models/menu_item.dart';
import '../models/restaurant.dart';
import '../repository/repository.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final Repository repository;
  OrderBloc({required this.repository}) : super(OrderState.initial()) {
    on<LoadRestaurants>(_onLoadRestaurants);
    on<SelectRestaurant>(_onSelectRestaurant);
    on<AddItem>(_onAddItem);
    on<RemoveItem>(_onRemoveItem);
    on<StartCheckout>(_onStartCheckout);
    on<PlaceOrder>(_onPlaceOrder);
    on<ResetOrder>(_onResetOrder);
  }

  Future<void> _onLoadRestaurants(LoadRestaurants e, Emitter<OrderState> emit) async {
    emit(state.copyWith(loadingRestaurants: true, error: null));
    try {
      final restaurants = await repository.fetchRestaurants();
      emit(state.copyWith(loadingRestaurants: false, restaurants: restaurants));
    } catch (ex) {
      emit(state.copyWith(loadingRestaurants: false, error: ex.toString()));
    }
  }

  void _onSelectRestaurant(SelectRestaurant e, Emitter<OrderState> emit) {
    emit(state.copyWith(selectedRestaurant: e.restaurant, order: Order(items: [])));
  }

  void _onAddItem(AddItem e, Emitter<OrderState> emit) {
    final current = List<OrderItem>.from(state.order.items);
    final idx = current.indexWhere((it) => it.item.id == e.item.id);
    if (idx >= 0) {
      final existing = current[idx];
      current[idx] = OrderItem(item: existing.item, qty: existing.qty + 1);
    } else {
      current.add(OrderItem(item: e.item, qty: 1));
    }
    emit(state.copyWith(order: state.order.copyWith(items: current)));
  }

  void _onRemoveItem(RemoveItem e, Emitter<OrderState> emit) {
    final current = List<OrderItem>.from(state.order.items);
    final idx = current.indexWhere((it) => it.item.id == e.item.id);
    if (idx >= 0) {
      final existing = current[idx];
      if (existing.qty > 1) {
        current[idx] = OrderItem(item: existing.item, qty: existing.qty - 1);
      } else {
        current.removeAt(idx);
      }
      emit(state.copyWith(order: state.order.copyWith(items: current)));
    }
  }

  void _onStartCheckout(StartCheckout e, Emitter<OrderState> emit) {
    if (state.order.items.isEmpty) {
      emit(state.copyWith(order: state.order.copyWith(status: OrderStatus.failed, errorMessage: 'Cannot checkout with empty cart')));
      return;
    }
    emit(state.copyWith(order: state.order.copyWith(status: OrderStatus.checkingOut, address: e.address, paymentMethod: e.paymentMethod)));
  }

  Future<void> _onPlaceOrder(PlaceOrder e, Emitter<OrderState> emit) async {
    emit(state.copyWith(order: state.order.copyWith(status: OrderStatus.placing), placing: true, error: null));
    try {
      final id = await repository.placeOrder(state.order.copyWith(address: e.address, paymentMethod: e.paymentMethod));
      emit(state.copyWith(placing: false, order: state.order.copyWith(status: OrderStatus.confirmed, id: id)));
    } catch (ex) {
      emit(state.copyWith(placing: false, order: state.order.copyWith(status: OrderStatus.failed, errorMessage: ex.toString()), error: ex.toString()));
    }
  }

  void _onResetOrder(ResetOrder e, Emitter<OrderState> emit) {
    emit(OrderState.initial());
  }
}
