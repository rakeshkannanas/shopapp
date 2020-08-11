import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_shop/providers/orders.dart' as OI;

class OrderItem extends StatefulWidget {
  final OI.OrderItem orders;
  OrderItem(this.orders);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: _isExpanded ? min(widget.orders.products.length * 20.0+124.0,300) : 115,
      alignment: Alignment.center,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            ListTile(title: Text('Rs. ${widget.orders.total}'),
              subtitle: Text(DateFormat('dd-MM-yyyy hh:mm').format(widget.orders.time)),
              trailing: IconButton(icon: Icon(_isExpanded ? Icons.expand_less:Icons.expand_more),onPressed: (){
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },),
             ),
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
                margin: EdgeInsets.all(10),
                height: _isExpanded ? widget.orders.products.length * 20.0+10.0 : 0,
                child: ListView(
                  children: widget.orders.products.map((e) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(e.title,style: TextStyle(
                        fontSize: 18,fontWeight: FontWeight.bold
                      ),),
                      Text('Rs. ${e.price} x ${e.quantity}',style: TextStyle(
                        fontSize: 18,color: Colors.grey
                      ),)
                    ],
                  )).toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
