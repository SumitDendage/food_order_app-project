import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/order_bloc.dart';
import '../models/menu_item.dart';
import '../models/order.dart';

class FlowScreen extends StatelessWidget {
  const FlowScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state.loadingRestaurants) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.error != null) {
            return Center(child: Text('Error: ${state.error}'));
          }
          // if no restaurant selected show list
          if (state.selectedRestaurant == null) {
            return _restaurantList(context, state);
          }
          // if order confirmed
          if (state.order.status == OrderStatus.confirmed) {
            return _confirmationView(context, state);
          }
          // main menu and cart view
          return _menuAndCart(context, state);
        },
      )),
    );
  }

  Widget _restaurantList(BuildContext context, OrderState state) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text('Nearby Restaurants', style: Theme.of(context).textTheme.headline5),
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.restaurants.length,
            separatorBuilder: (_,__) => Divider(),
            itemBuilder: (context, idx) {
              final r = state.restaurants[idx];
              return ListTile(
                title: Text(r.name),
                subtitle: Text(r.description),
                trailing: Icon(Icons.chevron_right),
                onTap: () => context.read<OrderBloc>().add(SelectRestaurant(r)),
              );
            },
          ),
        )
      ],
    );
  }

  Widget _menuAndCart(BuildContext context, OrderState state) {
    final r = state.selectedRestaurant!;
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: [
              BackButton(onPressed: () => context.read<OrderBloc>().add(ResetOrder())),
              SizedBox(width: 8),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(r.name, style: Theme.of(context).textTheme.headline6),
                Text(r.description, style: Theme.of(context).textTheme.caption),
              ])
            ],
          ),
        ),
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(12),
                child: Text('Menu', style: Theme.of(context).textTheme.subtitle1),
              ),
              ...r.menu.map((m) => ListTile(
                title: Text(m.name),
                subtitle: Text(m.description),
                trailing: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text('\$${m.price.toStringAsFixed(2)}'),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: () => context.read<OrderBloc>().add(AddItem(m)),
                    )
                  ],
                ),
              )),
              Divider(),
              Padding(
                padding: EdgeInsets.all(12),
                child: Text('Cart', style: Theme.of(context).textTheme.subtitle1),
              ),
              if (state.order.items.isEmpty)
                Padding(padding: EdgeInsets.all(16), child: Text('Your cart is empty — add items to continue.')),
              ...state.order.items.map((oi) => ListTile(
                title: Text(oi.item.name),
                subtitle: Text('Qty: ${oi.qty}'),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text('\$${(oi.item.price * oi.qty).toStringAsFixed(2)}'),
                  IconButton(icon: Icon(Icons.remove_circle_outline), onPressed: () => context.read<OrderBloc>().add(RemoveItem(oi.item))),
                ]),
              )),
              SizedBox(height: 12),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: ElevatedButton(
                  onPressed: state.order.items.isEmpty ? null : () => _showCheckoutSheet(context, state),
                  child: state.placing ? CircularProgressIndicator(color: Colors.white) : Text('Checkout'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCheckoutSheet(BuildContext context, OrderState state) {
    final addrCtl = TextEditingController(text: state.order.address ?? '');
    String payment = state.order.paymentMethod ?? 'Card';
    showModalBottomSheet(context: context, isScrollControlled: true, builder: (ctx) {
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text('Checkout', style: Theme.of(ctx).textTheme.headline6),
            SizedBox(height: 8),
            TextField(controller: addrCtl, decoration: InputDecoration(labelText: 'Delivery address')),
            SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: payment,
              items: ['Card', 'UPI', 'Cash'].map((p) => DropdownMenuItem(child: Text(p), value: p)).toList(),
              onChanged: (v) { if (v!=null) payment = v; },
              decoration: InputDecoration(labelText: 'Payment'),
            ),
            SizedBox(height: 12),
            Row(children: [
              Expanded(child: OutlinedButton(onPressed: () => Navigator.of(ctx).pop(), child: Text('Cancel'))),
              SizedBox(width: 8),
              Expanded(child: ElevatedButton(onPressed: () {
                final address = addrCtl.text.trim();
                if (address.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter delivery address')));
                  return;
                }
                Navigator.of(ctx).pop();
                context.read<OrderBloc>().add(PlaceOrder(address: address, paymentMethod: payment));
              }, child: Text('Place order'))),
            ])
          ]),
        ),
      );
    });
  }

  Widget _confirmationView(BuildContext context, OrderState state) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.check_circle_outline, size: 84, color: Colors.green),
          SizedBox(height: 12),
          Text('Order Confirmed!', style: Theme.of(context).textTheme.headline6),
          SizedBox(height: 8),
          Text('Order ID: ${state.order.id}'),
          SizedBox(height: 16),
          ElevatedButton(onPressed: () => context.read<OrderBloc>().add(ResetOrder()), child: Text('Start new order')),
        ]),
      ),
    );
  }
}
