import 'package:flutter/foundation.dart';

class Product {

  String id;
  String name;
  String description;
  String brand;
  double unitPrice;
  bool _isSelected = false;

  Product({@required this.id, @required this.name, @required this.description, @required this.brand, @required this.unitPrice});

  Product.fromProductJson(Map<String, dynamic> parsedJson){
    for (int index = 0; index < parsedJson["info"].length; index++) {
      var productJson = Map<String, dynamic>.from(parsedJson["info"][index]);
      this.id = productJson["id"].toString();
      this.name = productJson["nome"];
      this.description = productJson["descripcion"];
      this.brand = productJson["brand"];
      this.unitPrice = productJson["prezo"];
    }
  }

  String getName(){
    return this.name;
  }

  String getDescription(){
    return this.description;
  }

  String getBrand(){
    return this.brand;
  }

  double getPrice(){
    return this.unitPrice;
  }

  void setIsSelected(bool isSelected){
    this._isSelected = isSelected;
  }

  bool isSelected(){
    return this._isSelected;
  }

}