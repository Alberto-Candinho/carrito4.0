import 'package:flutter/foundation.dart';
import '../models.dart';
import 'dart:convert';


class ShoppingList {
  String listName;
  String listId;
  bool _subscribed;
  bool inTrolley;
  List<Product> _products = [];

  ShoppingList.withName({@required this.listName, @required this.listId}) : _subscribed = false, inTrolley = false;

  ShoppingList({@required this.listId}) : _subscribed = false, listName = listId, inTrolley = false;

  ShoppingList.withInTrolleyBool({@required this.listId, @required this.inTrolley}) : _subscribed = false, listName = listId;

  bool isInTrolley(){
    return inTrolley;
  }

  void setInTrolley(bool inTrolley){
    this.inTrolley = inTrolley;
  }

  void addProduct(Product product){
    _products.add(product);
  }

  void removeProduct(Product product){
    _products.remove(product);
  }

  void setProducts(List<Product> newProducts){
    this._products = newProducts;
  }

  List<Product> getProducts(){
    return this._products;
  }

  bool hasProduct(Product product){
    return (_products.contains(product));
  }


  void setSubscribed(bool subscribed){
    this._subscribed = subscribed;
  }

  bool isSubscribed(){
    return this._subscribed;
  }

  String toJson(){
    Map<String, dynamic> listJson= {
      "nome" : this.listName,
      "productos" : this.getProductsIds()
    };
    return json.encode(listJson);

  }

  List<String> getProductsIds(){
    List<String> productsIds = [];
    for(Product product in _products) productsIds.add(product.id);
    return productsIds;

  }

  Product getProductById(String productId){
    for(Product product in _products){
      if(product.id == productId) return product;
    }
    return null;
  }





}