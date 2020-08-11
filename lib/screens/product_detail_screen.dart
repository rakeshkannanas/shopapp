import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product_detail_screen';
  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context).settings.arguments;
   Products data =  Provider.of<ProductsProvider>(context).findById(id);
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        flexibleSpace: Provider.of<ProductsProvider>(context).appBarColor(),
        title: Text(data.title,style: TextStyle(
          letterSpacing: 2,
        ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Hero(tag: data.id,child: Image.network(data.imageUrl,fit: BoxFit.cover,)),
            ),
            SizedBox(height: 10,),
            Text('Rs. ${data.price}',style: TextStyle(fontSize: 20,color: Colors.grey),),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${data.description}',style: TextStyle(fontSize: 18,),softWrap: true,textAlign: TextAlign.center,),
            )
          ],
        ),
      ),
    );
  }
}
