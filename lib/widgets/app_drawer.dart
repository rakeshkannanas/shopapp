import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:my_shop/screens/order_screen.dart';
import 'package:my_shop/screens/your_products_screen.dart';
import 'package:provider/provider.dart';


class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('My Shop'),
            automaticallyImplyLeading: false,
          ),
          ListTile(leading: Icon(Icons.shop),title: Text('Shop'),onTap: (){
            Navigator.of(context).pushReplacementNamed('/');
          },),
          Divider(),
          ListTile(leading: Icon(Icons.payment),title: Text('My Orders'),onTap: (){
            Navigator.of(context).pushReplacementNamed(OrderScreen.routeName);
          },),
          Divider(),
          ListTile(leading: Icon(Icons.edit),title: Text('Manage Products'),onTap: (){
            Navigator.of(context).pushReplacementNamed(YourProductsScreen.routeName);
          },),
          Divider(),
          ListTile(leading: Icon(Icons.exit_to_app),title: Text('Logout'),onTap: (){
            Navigator.of(context).pop();
            Provider.of<Auth>(context,listen: false).logout();
          },),
          Divider(),
        ],
      ),
    );
  }
}
