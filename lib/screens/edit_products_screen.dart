import 'package:flutter/material.dart';
import 'package:my_shop/providers/products.dart';
import 'package:my_shop/providers/products_provider.dart';
import 'package:provider/provider.dart';

class EditProductsScreen extends StatefulWidget {
  static const routeName = 'EditProductsScreen';

  @override
  _EditProductsScreenState createState() => _EditProductsScreenState();
}

class _EditProductsScreenState extends State<EditProductsScreen> {
  final _priceNode = FocusNode();
  final _desNode = FocusNode();
  final _urlController = TextEditingController();
  final _urlNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  var _productsAdd =
      Products(id: null, title: '', description: '', imageUrl: '', price: 0);

  var didChangeCheck = false;
  var isSaved = false;
  String title = '', description = '', price = '', imgUrl = '';

  @override
  void initState() {
    // TODO: implement initState
    _urlNode.addListener(focusChange);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (!didChangeCheck) {
      final prodId = ModalRoute.of(context).settings.arguments as String;
      if (prodId != null) {
        _productsAdd = Provider.of<ProductsProvider>(context, listen: false)
            .findById(prodId);
        title = _productsAdd.title;
        description = _productsAdd.description;
        price = _productsAdd.price.toString();
        imgUrl = _productsAdd.imageUrl;
        _urlController.text = imgUrl;
      }
      didChangeCheck = true;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _urlNode.removeListener(focusChange);
    _urlNode.dispose();
    _urlController.dispose();
    _priceNode.dispose();
    _desNode.dispose();
  }

  void focusChange() {
    if (!_urlNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> saveForm() async {
    final valid = _formKey.currentState.validate();
    if (!valid) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      isSaved = true;
    });
    FocusScope.of(context).unfocus();
    if (_productsAdd.id != null) {
     await Provider.of<ProductsProvider>(context, listen: false)
          .updateProducts(_productsAdd.id, _productsAdd);

    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProducts(_productsAdd);
      } catch (error) {
        await showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Error!'),
                content: Text('Something went wrong'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            });
      }
//      finally {
//        setState(() {
//          isSaved = false;
//        });
//        Navigator.of(context).pop();
//      }
    }
    setState(() {
      isSaved = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Form(
          key: _formKey,
          child: Container(
            margin: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Title',
                        ),
                        initialValue: title,
                        cursorColor: Colors.grey,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_priceNode);
                        },
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Provide title for the product';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _productsAdd = Products(
                              id: _productsAdd.id,
                              isFavorite: _productsAdd.isFavorite,
                              title: val,
                              description: _productsAdd.description,
                              imageUrl: _productsAdd.imageUrl,
                              price: _productsAdd.price);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Price',
                        ),
                        initialValue: price,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Provide price for the product';
                          }
                          if (double.tryParse(val) == null) {
                            return 'Enter valid price';
                          }
                          if (double.parse(val) <= 0) {
                            return 'Price should not be zero';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _productsAdd = Products(
                              id: _productsAdd.id,
                              isFavorite: _productsAdd.isFavorite,
                              title: _productsAdd.title,
                              description: _productsAdd.description,
                              imageUrl: _productsAdd.imageUrl,
                              price: double.parse(val));
                        },
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        focusNode: _priceNode,
                        cursorColor: Colors.grey,
                        onFieldSubmitted: (value) {
                          FocusScope.of(context).requestFocus(_desNode);
                        },
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        initialValue: description,
                        validator: (val) {
                          if (val.isEmpty) {
                            return 'Provide description for the product';
                          }
                          if (val.length < 10) {
                            return 'Description should be more than 10 characters';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          _productsAdd = Products(
                              id: _productsAdd.id,
                              isFavorite: _productsAdd.isFavorite,
                              title: _productsAdd.title,
                              description: val,
                              imageUrl: _productsAdd.imageUrl,
                              price: _productsAdd.price);
                        },
                        maxLines: 3,
                        cursorColor: Colors.grey,
                        focusNode: _desNode,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 150,
                            height: 150,
                            margin: EdgeInsets.only(top: 10, right: 10),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey)),
                            child: _urlController.text.isEmpty
                                ? Center(
                                    child: Text(
                                    'No Image available',
                                    textAlign: TextAlign.center,
                                  ))
                                : Image.network(
                                    _urlController.text,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                            child: TextFormField(
                              decoration:
                                  InputDecoration(labelText: 'Enter URL'),
                              cursorColor: Colors.grey,
                              validator: (val) {
                                if (val.isEmpty) {
                                  return 'Add image for the product';
                                }
                                return null;
                              },
                              onSaved: (val) {
                                _productsAdd = Products(
                                    id: _productsAdd.id,
                                    isFavorite: _productsAdd.isFavorite,
                                    title: _productsAdd.title,
                                    description: _productsAdd.description,
                                    imageUrl: val,
                                    price: _productsAdd.price);
                              },
                              textInputAction: TextInputAction.done,
                              keyboardType: TextInputType.url,
                              controller: _urlController,
                              focusNode: _urlNode,
                              onFieldSubmitted: (_) {
                                saveForm();
                              },
                            ),
                          )
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 50),
                        child: RaisedButton(
                          onPressed: () {
                            saveForm();
                          },
                          elevation: 3,
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                          color: Theme.of(context).primaryColor,
                        ),
                      )
                    ],
                  ),
                  Positioned.fill(
                    child: Align(
                      child:
                          isSaved ? CircularProgressIndicator() : Container(),
                      alignment: Alignment.center,
                    ),
                  )
                ],
              ),
            ),
          )),
    );
  }
}
