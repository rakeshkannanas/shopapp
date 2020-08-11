import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:my_shop/widgets/cart_item.dart' as CI;
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  static const routeName = 'CartScreen';

  @override
  Widget build(BuildContext context) {
    final data = Provider.of<ProductsProvider>(context, listen: false);
    final total = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Cart',
          style: TextStyle(letterSpacing: 2),
        ),
        flexibleSpace: data.appBarColor(),
      ),
      body: Column(
        children: [
          Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Total:',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Chip(
                    label: Text(
                      'Rs.${total.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  Spacer(),
                  addOrder(total: total)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Text(
              'Items in your cart !',
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) {
                return CI.CartItem(
                  id: total.getCartItems.values.toList()[i].id,
                  title: total.getCartItems.values.toList()[i].title,
                  imgUrl: total.getCartItems.values.toList()[i].imageUrl,
                  price: total.getCartItems.values.toList()[i].price,
                  quantity: total.getCartItems.values.toList()[i].quantity,
                  keyId: total.getCartItems.keys.toList()[i],
                );
              },
              itemCount: total.cartQuantity,
            ),
          )
        ],
      ),
    );
  }
}

class addOrder extends StatefulWidget {
  const addOrder({
    Key key,
    @required this.total,
  }) : super(key: key);

  final Cart total;


  @override
  _addOrderState createState() => _addOrderState();
}

class _addOrderState extends State<addOrder> {
  var isLoading = false;
  @override
  Widget build(BuildContext context) {
    return isLoading ? Container( width:150,child: Center(child: CircularProgressIndicator())) : RaisedButton(
        onPressed:widget.total.getCartItems.length <= 0 ? null : () async {
          setState(() {
            isLoading =true;
          });
         await Provider.of<Orders>(context,listen: false).addOrders(widget.total.getCartItems.values.toList(), widget.total.totalPrice);
          widget.total.clearCart();
          final snackBar = SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Order placed successfully'),
            action: SnackBarAction(
              label: 'Ok',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(snackBar);
          setState(() {
            isLoading =false;
          });
        },
        child: Text(
          'PLACE ORDER',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ));
  }
}
