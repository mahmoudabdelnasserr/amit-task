import 'package:flutter/material.dart';
import 'package:new_app/providers/products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class Products with ChangeNotifier {
  List<Product> _items = [];

  final String authToken;
  final String userId;

  Products(this.authToken,this.userId,  this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavourite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }


  Future<void> fetchAndSetProduct([bool filterByUser = false]) async{
    final filterString = filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    var url = 'https://shop-app-16b6e-default-rtdb.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      url = 'https://shop-app-16b6e-default-rtdb.firebaseio.com/userFavorites/$userId.json.json?auth=$authToken';
      final favoriteResponse = await http.get(Uri.parse(url));
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: favoriteData == null ? false : favoriteData[prodId] ?? false,
          imageUrl: prodData['imageUrl']
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    }catch(error){
      throw error;
    }


  }

  Future <void> addProduct(Product product) async {
    final url = 'https://shop-app-16b6e-default-rtdb.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(Uri.parse(url), body: json.encode({
        'title': product.title,
        'description': product.description,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'creatorId': userId,
      }));
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      // _items.insert(0, newProduct); // at the start of the list
      notifyListeners();
    } catch(error){
      print(error);
      throw error;

    }




  }

  Future <void> updateProduct(String id, Product newProduct)async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://shop-app-16b6e-default-rtdb.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(Uri.parse(url), body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'price': newProduct.price,
        'imageUrl': newProduct.imageUrl,

      }) );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

   void deleteProduct(String id) {
    final url = 'https://shop-app-16b6e-default-rtdb.firebaseio.com/products/$id.json';
    final _existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var _existingProduct = _items[_existingProductIndex];
    _items.removeAt(_existingProductIndex);
    notifyListeners();
     http.delete(Uri.parse(url)).then((_){
       _existingProduct = null;

     }).catchError((_){
       _items.insert(_existingProductIndex, _existingProduct);
       notifyListeners();
    });

    
    _items.removeWhere((prod) => prod.id == id);

  }
}
