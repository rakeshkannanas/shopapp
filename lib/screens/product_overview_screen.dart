import 'package:flutter/material.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/badge.dart';
import 'package:my_shop/widgets/build_grid.dart';
import 'package:provider/provider.dart';

enum popupItems { favorites, allItems }

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  var _isFav = false;
  var _isLoaded = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _isLoaded = true;
    });
    Provider.of<ProductsProvider>(context,listen: false).getProdFromFB().then((value){
      setState(() {
        _isLoaded = false;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: Text(
          'Our Products',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
        ),
        flexibleSpace: Provider.of<ProductsProvider>(context).appBarColor(),
        actions: [
          Consumer<Cart>(
            builder: (_, cart, ch) {
              return Badge(
                  child:ch,
                  value: cart.cartQuantity.toString());
            },
            child: IconButton(
                icon: Icon(Icons.shopping_cart), onPressed: () {
                  Navigator.of(context).pushNamed(CartScreen.routeName);
            }),
          ),
          PopupMenuButton(
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: Text('Show Favorites'),
                  value: popupItems.favorites,
                ),
                PopupMenuItem(
                  child: Text('All Products'),
                  value: popupItems.allItems,
                ),
              ];
            },
            onSelected: (popupItems value) {
              setState(() {
                if (value == popupItems.allItems) {
                  _isFav = false;
                } else {
                  _isFav = true;
                }
              });
            },
          ),

        ],
      ),
      drawer: AppDrawer(),
      body: _isLoaded ? Center(child: CircularProgressIndicator()) : BuildGrid(_isFav),
    );
  }
}
