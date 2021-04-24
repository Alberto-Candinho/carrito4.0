import 'package:flutter/foundation.dart';
import '../models.dart';
import 'dart:convert';


class ShoppingList {
  String listName;
  String listId;
  bool _subscribed;
  List<Product> _products = [];

  ShoppingList.withName({@required this.listName, @required this.listId}) : _subscribed = false;

  ShoppingList({@required this.listId}) : _subscribed = false, listName = listId;

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





}