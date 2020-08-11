import 'package:flutter/material.dart';
import 'package:my_shop/providers/auth.dart';
import 'package:my_shop/providers/cart.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Products>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    final auth = Provider.of<Auth>(context, listen: false);
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailScreen.routeName, arguments: product.id);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: GridTile(
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage(
                'assets/images/product-placeholder.png',
              ),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          footer: GridTileBar(
            leading: IconButton(
              icon: product.isFavorite
                  ? Icon(Icons.favorite)
                  : Icon(Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () async {
                final snackBar = SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text(product.isFavorite
                      ? '${product.title} removed from your favorites'
                      : '${product.title} added to your favorites'),
                  action: SnackBarAction(
                    label: 'Ok',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(snackBar);
                try {
                  await product.toggleFav(auth.token, auth.userId);
                } catch (error) {
                  final snackBar = SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text('Error!! Try Again'),
                    action: SnackBarAction(
                      label: 'Ok',
                      onPressed: () {
                        // Some code to undo the change.
                      },
                    ),
                  );
                  Scaffold.of(context).hideCurrentSnackBar();
                  Scaffold.of(context).showSnackBar(snackBar);
                }
              },
            ),
            title: Text(product.title),
            trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Theme.of(context).accentColor,
              onPressed: () {
                cart.addToCart(product.id, product.title, product.price, 1,
                    product.imageUrl);
                final snackBar = SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text('${product.title} added to your cart'),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.removeCurrentlyAdded(product.id);
                    },
                  ),
                );
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(snackBar);
              },
            ),
            backgroundColor: Colors.black54,
          ),
        ),
      ),
    );
  }
}
