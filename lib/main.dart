import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth.dart';

import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/orders.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:my_shop/screens/auth_screen.dart';
import 'package:my_shop/screens/cart_screen.dart';
import 'package:my_shop/screens/edit_products_screen.dart';
import 'package:my_shop/screens/order_screen.dart';
import 'package:my_shop/screens/splash_screen.dart';
import 'package:my_shop/screens/your_products_screen.dart';
import 'package:provider/provider.dart';
import 'package:my_shop/screens/product_detail_screen.dart';
import 'package:my_shop/screens/product_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          update: (context, auth, previousData) => ProductsProvider(
              auth.token,
              auth.userId,
              previousData == null ? [] : previousData.getProducts),
        ),
        ChangeNotifierProvider(
          create: (context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (context, auth, oldOrderData) => Orders(auth.token,
              auth.userId, oldOrderData == null ? [] : oldOrderData.getOrders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepPurple,
            accentColor: Colors.orange,
            scaffoldBackgroundColor: Color(0xffEFE5C1),
            fontFamily: 'Lato',
          ),
          home: auth.isAuth
              ? ProductOverviewScreen()
              : FutureBuilder(
                  future: auth.checkLogin(),
                  builder: (ctx, snapshot) =>
                      snapshot.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen()),
//          home: auth.isAuth
//              ? ProductOverviewScreen()
//              : auth.checkLogin().then((value) {
//                  value ? ProductOverviewScreen() : AuthScreen();
//                }),
          routes: {
            //'/' : (context){return AuthScreen();},
            ProductDetailScreen.routeName: (context) {
              return ProductDetailScreen();
            },
            CartScreen.routeName: (context) {
              return CartScreen();
            },
            OrderScreen.routeName: (context) {
              return OrderScreen();
            },
            YourProductsScreen.routeName: (context) => YourProductsScreen(),
            EditProductsScreen.routeName: (context) => EditProductsScreen(),
          },
        ),
      ),
    );
  }
}
