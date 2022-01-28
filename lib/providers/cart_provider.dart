import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem({@required this.id, @required this.title, @required this.quantity, @required this.price});

}

class Cart with ChangeNotifier{
    Map<String, CartItem> _items = {};
   Map<String, CartItem> get items{
    return {..._items};
  }
  int get itemsCount{
     return _items == null ? 0 : _items.length;
  }
  double get total{
    var total = 0.0;
    _items.forEach((key, CartItem){
      total += CartItem.price * CartItem.quantity;
    });
    return total;

  }

  void addItem(String productId, double price, String title){
    if (_items.containsKey(productId)){
        _items.update(productId, (existingCatrItem) => CartItem(id: existingCatrItem.id,
            title: existingCatrItem.title,
            price: existingCatrItem.price,
            quantity: existingCatrItem.quantity + 1));

    }else{
      _items.putIfAbsent(productId, () => CartItem(id: DateTime.now().toString(), title: title, price: price, quantity: 1));
    }
    notifyListeners();
}
    void removeCartItem(String productId){
     _items.remove(productId);
     notifyListeners();

    }
    void removeSingleItem(String productId) {
     if (!_items.containsKey(productId)){
       return;
     }

      if (_items[productId].quantity > 1){
       _items.update(productId, (existingCartItem) => CartItem(
         id: existingCartItem.id,
         title: existingCartItem.title,
         price: existingCartItem.price,
         quantity: existingCartItem.quantity - 1
       ));
     }else {
       _items.remove(productId);
     }
     notifyListeners();

    }
    void clear(){
     _items = {};
     notifyListeners();
    }

}