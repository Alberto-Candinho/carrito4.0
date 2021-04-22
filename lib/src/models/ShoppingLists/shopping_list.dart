import 'package:flutter/foundation.dart';
import '../models.dart';

class ShoppingList {
  String listName;
  String listId;
  List<Product> _products = [];

  ShoppingList.withId({@required this.listName, @required this.listId});

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

  /*Future<String> getId() async{
    String macAddress;
    try{
      macAddress = await GetMac.macAddress;
      return macAddress + "_" + listName;
    } on PlatformException {
      print("Platform exception: Failed to generate id of list");
      return "";
    }
  }*/


}