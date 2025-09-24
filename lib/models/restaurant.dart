import 'package:equatable/equatable.dart';
import 'menu_item.dart';

class Restaurant extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<MenuItem> menu;
  const Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.menu,
  });

  @override
  List<Object?> get props => [id, name];
}
