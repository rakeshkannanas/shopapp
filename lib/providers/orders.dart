import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem {
  final String id;
  final double total;
  final DateTime time;
  final List<CartItem> products;

  OrderItem(
      {@required this.id,
      @required this.total,
      @required this.time,
      @required this.products});
}

class Orders with ChangeNotifier {
  final authToken;
  final userId;
  List<OrderItem> _orders = [];

  Orders(this.authToken,this.userId,this._orders);

  int returnLength() {
    return _orders.length;
  }

  List<OrderItem> get getOrders {
    return [..._orders];
  }

  Future<void> getOrdersFromFB() async {
    final addProUrl = 'https://my-shop-app-bfd65.firebaseio.com/orders/$userId.json?auth=$authToken';
    final res = await http.get(addProUrl);
    print(jsonDecode(res.body));
    Map<String, dynamic> a = jsonDecode(res.body);
    List<OrderItem> listProds = [];
    if(a == null)
      {
        return;
      }
    a.forEach((key, value) {
      listProds.add(OrderItem(
          id: key,
          total: value['total'],
          time: DateTime.parse(value['time']),
          products: (value['products'] as List<dynamic>).map((e) => CartItem(
              id: e['id'],
              title: e['title'],
              price: e['price'],
              quantity: e['quantity'],
              imageUrl: e['imageUrl'])).toList()));
    });
    _orders = listProds.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrders(List<CartItem> products, double total) async {
    DateTime time = DateTime.now();
    final addProUrl = 'https://my-shop-app-bfd65.firebaseio.com/orders/$userId.json?auth=$authToken';
    final res = await http.post(addProUrl,
        body: jsonEncode({
          'total': total,
          'time': time.toIso8601String(),
          'products': products
              .map((e) => {
                    'id': e.id,
                    'title': e.title,
                    'imageUrl': e.imageUrl,
                    'price': e.price,
                    'quantity': e.quantity
                  })
              .toList()
        }));
    print(jsonDecode(res.body));
//    _orders.insert(0, OrderItem(id: jsonDecode(res.body)['name'],
//        total: total,
//        time: time,
//        products: products));
    notifyListeners();
  }
}
