import 'package:flutter/material.dart';
import 'package:my_shop/widgets/product_item.dart';
import 'package:provider/provider.dart';
import 'package:my_shop/providers/products_provider.dart';

class BuildGrid extends StatelessWidget {
  final isFav;

  BuildGrid(this.isFav);

  @override
  Widget build(BuildContext context) {
    final productsInstance = Provider.of<ProductsProvider>(context);
    final products = isFav ? productsInstance.getFavProducts : productsInstance.getProducts;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10),
      itemBuilder: (ctx, i) {
        return ChangeNotifierProvider.value(
          value: products[i],
          child: ProductItem(),
        );
      },
      itemCount: products.length,
    );
  }
}
