import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/order_bloc.dart';
import 'repository/mock_repository.dart';
import 'screens/flow_screen.dart';

void main() {
  final repository = MockRepository();
  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final MockRepository repository;
  const MyApp({required this.repository, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      child: BlocProvider(
        create: (_) => OrderBloc(repository: repository)..add(LoadRestaurants()),
        child: MaterialApp(
          title: 'Food Order Demo',
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FlowScreen(),
        ),
      ),
    );
  }
}
