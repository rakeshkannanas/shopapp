import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Products(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.price,
      this.isFavorite = false});

  Future<void> toggleFav(String token,String userid) async
  {
    var fav = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final addProUrl =
        'https://my-shop-app-bfd65.firebaseio.com/userFavorites/$userid/$id.json?auth=$token';
    try {
     final res = await http.put(addProUrl, body: jsonEncode(
     isFavorite
      ));
      print('response ${jsonDecode(res.body)}');
    }
    catch(error)
    {
      isFavorite = fav;
      notifyListeners();
      throw error;
    }

  }
}
