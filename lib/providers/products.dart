import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;


  bool isFavourite;

  Product({@required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavourite = false, isFavorite
  });


  Future <void> toggleIsFavourite(String token, String userId)async{
    final url = 'https://shop-app-16b6e-default-rtdb.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();

   try{
     await http.put(Uri.parse(url), body: json.encode(
        isFavourite,
     ));
   } catch (error){
     isFavourite = oldStatus;
     notifyListeners();
   }
  }


}

