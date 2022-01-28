import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import 'cart_provider.dart';
class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({@required this.id, @required this.amount, @required this.products, @required this.dateTime});

}
class Orders with ChangeNotifier{
  List<OrderItem> _orders = [];
  final String token;
  final String userId;

  Orders(this.token, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }
  Future<void> setAndFetch()async{
    final url = 'https://shop-app-16b6e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
    final response = await http.get(Uri.parse(url));
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null){
      return;
    }
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderItem(id: orderId, amount: orderData['amount'],
            products: (orderData['products'] as List<dynamic>).map((item) =>
                CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                )).toList(),
            dateTime: DateTime.parse(orderData['dateTime'])));
      });
      _orders = loadedOrders;
      notifyListeners();

  }

  Future  <void> addOrder(List<CartItem> cartProducts, double total)async{
    final timestamp = DateTime.now();
    final url = 'https://shop-app-16b6e-default-rtdb.firebaseio.com/orders/$userId.json?auth=$token';
    final response = await http.post(Uri.parse(url), body: json.encode({
      'amount': total,
      'datetime': timestamp.toIso8601String(),
      'products': cartProducts.map((cp) => {
        'id': cp.id,
        'title': cp.title,
        'quantity': cp.quantity,
        'price': cp.price,
      }).toList(),

    }));
    _orders.insert(0, OrderItem(id: json.decode(response.body)['name'].toString()
        , amount: total,
        dateTime: timestamp,
        products: cartProducts));

    notifyListeners();
  }

}