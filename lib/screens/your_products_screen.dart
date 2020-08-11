import 'package:flutter/material.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:my_shop/screens/edit_products_screen.dart';
import 'package:my_shop/widgets/app_drawer.dart';
import 'package:my_shop/widgets/your_products_item.dart';
import 'package:provider/provider.dart';

class YourProductsScreen extends StatefulWidget {
  static const routeName = 'YourProductsScreen';

  @override
  _YourProductsScreenState createState() => _YourProductsScreenState();
}

class _YourProductsScreenState extends State<YourProductsScreen> {
  var isLoading =false;
  Future<void> refreshProds(BuildContext context) async
  {
    setState(() {
      isLoading=true;
    });
    await Provider.of<ProductsProvider>(context,listen: false).getProdFromFB(true);
    setState(() {
      isLoading=false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refreshProds(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(icon: Icon(Icons.add,color: Colors.white,),onPressed: (){
            Navigator.of(context).pushNamed(EditProductsScreen.routeName);
          },)
        ],
      ),
      drawer: AppDrawer(),
      body:isLoading ? Center(child: CircularProgressIndicator(),) : RefreshIndicator(
        onRefresh: (){
         return refreshProds(context);
        },
        child: Consumer<ProductsProvider>(
          builder: (ctx,products,_)=> Container(
            child: ListView.builder(itemBuilder: (ctx,index){
              return YourProductsItem(products.getProducts[index].id,products.getProducts[index].title, products.getProducts[index].imageUrl);
            },itemCount: products.getProducts.length,),
          ),
        ),
      ),
    );
  }
}
