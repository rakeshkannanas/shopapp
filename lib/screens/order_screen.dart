import 'package:flutter/material.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/order_item.dart' as OI;
import 'package:provider/provider.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = 'OrderScreen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  var isLoaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isLoaded =true;
    });
    Provider.of<Orders>(context,listen: false).getOrdersFromFB().then((value){
      setState(() {
        isLoaded =false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Orders',
          style: TextStyle(
            letterSpacing: 2,
          ),
        ),
      ),
      drawer: AppDrawer(),
      body: isLoaded ? Center(child: CircularProgressIndicator()) : ListView.builder(itemBuilder: (ctx,i){
        return OI.OrderItem(orderData.getOrders[i]);
      },itemCount: orderData.getOrders.length,),
    );
  }
}
