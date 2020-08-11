import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String imageUrl;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
    @required this.imageUrl,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems ={};

  Map<String, CartItem> get getCartItems{
    return {..._cartItems};
  }

  int get cartQuantity {
    return _cartItems.length;
  }
  double get totalPrice
  {
    double total =0.0;
    _cartItems.forEach((key, value) {
      total += value.price*value.quantity;
    });
    return total;
  }
  void removeCurrentlyAdded(String id)
  {
    if(!_cartItems.containsKey(id))
      {
        return;
      }
    if(_cartItems[id].quantity>1)
      {
        _cartItems.update(id, (value) => CartItem(id: value.id,
            title: value.title,
            price: value.price,
            quantity: value.quantity - 1,
            imageUrl: value.imageUrl));
      }
    else{
      _cartItems.remove(id);
    }
    notifyListeners();
  }
  void addToCart(String id, String title, double price,
      int quantity, String imgUrl) {
    if (_cartItems.containsKey(id)) {
      _cartItems.update(id, (value) =>
          CartItem(id: value.id,
              title: value.title,
              price: value.price,
              quantity: value.quantity + 1,
              imageUrl: value.imageUrl));
    }
    else {
      _cartItems.putIfAbsent(id, () => CartItem(id: DateTime.now().toString(), title: title, price: price, quantity: 1,imageUrl: imgUrl ));
    }
    notifyListeners();
  }

  void removeItem(String id)
  {
    _cartItems.remove(id);
    notifyListeners();
  }

  void clearCart()
  {
    _cartItems ={};
    notifyListeners();
  }
}
