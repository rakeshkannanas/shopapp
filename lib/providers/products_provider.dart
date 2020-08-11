import 'package:flutter/material.dart';
import 'package:my_shop/models/http_exception.dart';
import 'dart:convert';
import 'package:my_shop/providers/products.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  final authToken;
  final userid;
  List<Products> _items = [];

  ProductsProvider(this.authToken,this.userid,this._items);

  List<Products> get getProducts {
    return [..._items];
  }

  List<Products> get getFavProducts {
    return _items.where((element) => element.isFavorite == true).toList();
  }

  Container appBarColor() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
            Color(0xff42275a),
            Color(0xff734b6d),
          ])),
    );
  }

  Products findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addProducts(Products products) async {
    final addProUrl = 'https://my-shop-app-bfd65.firebaseio.com/products.json?auth=$authToken';
    try {
      final value = await http.post(addProUrl,
          body: jsonEncode({
            'title': products.title,
            'price': products.price,
            'description': products.description,
            'imgUrl': products.imageUrl,
            'creatorId':userid
          }));
      print(jsonDecode(value.body)['name']);
      var finalProds = Products(
          id: jsonDecode(value.body)['name'],
          title: products.title,
          description: products.description,
          imageUrl: products.imageUrl,
          price: products.price);
      _items.add(finalProds);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getProdFromFB([bool filterUser = false]) async {
    var urlString ='';
    filterUser ? urlString = '&orderBy="creatorId"&equalTo="$userid"' : '';
    var addProUrl = 'https://my-shop-app-bfd65.firebaseio.com/products.json?auth=$authToken$urlString';
    try {
      final res = await http.get(addProUrl);
      print(jsonDecode(res.body));
       addProUrl =
          'https://my-shop-app-bfd65.firebaseio.com/userFavorites/$userid.json?auth=$authToken';
       print(userid);
      final resFav = await http.get(addProUrl);
      final fav = jsonDecode(resFav.body);
      Map<String, dynamic> a = jsonDecode(res.body);
      List<Products> listProds = [];
      a.forEach((key, value) {
        listProds.add(Products(
            id: key,
            title: value['title'],
            description: value['description'],
            imageUrl: value['imgUrl'],
            price: value['price'],
            isFavorite: fav == null ? false : fav[key] ?? false));

      });
      _items = listProds;
    } catch (error) {}
    notifyListeners();
  }

  Future<void> updateProducts(String id, Products products) async {
    int index = _items.indexWhere((element) => element.id == id);
    _items[index] = products;
    final addProUrl =
        'https://my-shop-app-bfd65.firebaseio.com/products/$id.json?auth=$authToken';
   final res = await http.patch(addProUrl,
        body: jsonEncode({
          'title': products.title,
          'description': products.description,
          'imgUrl': products.imageUrl,
          'price': products.price
        }));
   print('response ${jsonDecode(res.body)}');
    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    var index = _items.indexWhere((element) => element.id == id);
    var products = _items[index];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    final addProUrl =
        'https://my-shop-app-bfd65.firebaseio.com/products/$id.json?auth=$authToken';
    final res = await http.delete(addProUrl);
    if(res.statusCode >= 400)
      {
        _items.insert(index, products);
        notifyListeners();
        throw HttpException('Error');
      }
        products =null;
  }
}
