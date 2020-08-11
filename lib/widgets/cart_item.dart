import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String keyId;
  final String title;
  final String imgUrl;
  final double price;
  final int quantity;

  CartItem(
      {this.id, this.title, this.imgUrl, this.price, this.quantity, this.keyId});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(keyId);
      },
      background: Container(
        padding: EdgeInsets.only(right: 10),
        child: Icon(Icons.delete, size: 25, color: Colors.white,),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[
                  Color(0xff42275a),
                  Color(0xff734b6d),
                ])),
      ),
      confirmDismiss: (direction) {
        return showDialog(context: context, child: AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to remove this item from the cart?'),
          actions: [FlatButton(onPressed: (){
            Navigator.of(context).pop(true);
          }, child: Text('Yes')),
            FlatButton(onPressed: (){
              Navigator.of(context).pop(false);
            }, child: Text('No')), ],));
      },
      child: Card(
          elevation: 5,
          margin: EdgeInsets.all(10),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 10,),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(imgUrl),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Price per piece Rs.$price'),
                          SizedBox(
                            height: 5,
                          ),
                          Text('Total Rs.${(price * quantity)}',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  flex: 0,
                  child: Text('x$quantity',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),),
                ),
                SizedBox(width: 10,),
              ],
            ),
          )),
    );
  }
}
