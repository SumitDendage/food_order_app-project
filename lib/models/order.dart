import 'package:equatable/equatable.dart';
import 'menu_item.dart';

enum OrderStatus { selecting, checkingOut, placing, confirmed, failed }

class OrderItem extends Equatable {
  final MenuItem item;
  final int qty;
  const OrderItem({required this.item, required this.qty});

  @override
  List<Object?> get props => [item, qty];
}

class Order extends Equatable {
  final String? id;
  final List<OrderItem> items;
  final String? address;
  final String? paymentMethod;
  final OrderStatus status;
  final String? errorMessage;

  const Order({
    this.id,
    this.items = const [],
    this.address,
    this.paymentMethod,
    this.status = OrderStatus.selecting,
    this.errorMessage,
  });

  Order copyWith({
    String? id,
    List<OrderItem>? items,
    String? address,
    String? paymentMethod,
    OrderStatus? status,
    String? errorMessage,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      address: address ?? this.address,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [id, items, address, paymentMethod, status, errorMessage];
}
