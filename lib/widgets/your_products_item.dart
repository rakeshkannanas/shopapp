import 'package:flutter/material.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:my_shop/screens/edit_products_screen.dart';
import 'package:provider/provider.dart';

class YourProductsItem extends StatelessWidget {
  final String title;
  final String imgUrl;
  final String id;

  YourProductsItem(this.id,this.title, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 5,
      child: ListTile(
        title: Text(title),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imgUrl),
        ),
        trailing: Container(
          width: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(icon: Icon(Icons.edit,), onPressed: (){
                Navigator.of(context).pushNamed(EditProductsScreen.routeName,arguments: id);
              }),
              IconButton(icon: Icon(Icons.delete,color: Theme.of(context).errorColor,), onPressed: () async {
                try{
                 await Provider.of<ProductsProvider>(context,listen: false).removeProduct(id);
                }
                catch(error)
                {
                  scaffold.showSnackBar(SnackBar(content: Text('Deletion failed')));
                }

              }),
            ],
          ),
        ),
      ),
    );
  }
}
