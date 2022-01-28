
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:new_app/providers/order_provider.dart';
import 'package:new_app/widgets/app_drawer.dart';
import 'package:new_app/widgets/order_item.dart' as ord;
import 'package:provider/provider.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  @override

  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async{
     await Provider.of<Orders>(context, listen: false).setAndFetch();

    });
    super.initState();

  }



  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body:  ListView.builder(itemCount:
      ordersData.orders.length,
      itemBuilder: (ctx, i) => ord.OrderItem(ordersData.orders[i]),)
    );
  }
}
