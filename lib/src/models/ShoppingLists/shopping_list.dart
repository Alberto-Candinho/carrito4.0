import 'package:flutter/foundation.dart';
import '../models.dart';

//@immutable
class ShoppingList {
  String listName;
  List<Product> _products = [];

  ShoppingList({@required this.listName});

  void addProduct(Product product){
    _products.add(product);
  }

  void removeProduct(Product product){
    _products.remove(product);
  }

  List<Product> getProducts(){
    return this._products;
  }

  void getQRCode(){

  }

  void share(){

  }


}