import 'package:flutter/foundation.dart';

class Product {
  String id;
  String name;
  String description;
  String brand;
  String imaxe;
  double unitPrice;
  bool _isSelected = false;
  double discount;
  bool granel;

  Product(
      {@required this.id,
      @required this.name,
      @required this.brand,
      @required this.imaxe,
      @required this.description,
      @required this.unitPrice,
      @required this.discount,
      @required this.granel});

  Product.fromProductJson(Map<String, dynamic> parsedJson) {
    for (int index = 0; index < parsedJson["info"].length; index++) {
      var productJson = Map<String, dynamic>.from(parsedJson["info"][index]);
      this.id = productJson["id"].toString();
      this.name = productJson["nome"];
      this.description = productJson["descripcion"];
      this.brand = productJson["brand"];
      this.unitPrice = productJson["precio"];
      this.imaxe = productJson["imaxe"];
      this.discount = productJson["desconto"];
      this.granel = productJson["granel"];
    }
  }

  String getName() {
    return this.name;
  }

  String getDescription() {
    return this.description;
  }

  String getBrand() {
    return this.brand;
  }

  String getImaxe() {
    return this.imaxe;
  }

  double getPrice() {
    print("PRECIO" + this.unitPrice.toString());
    return this.unitPrice;
  }

  void setIsSelected(bool isSelected) {
    this._isSelected = isSelected;
  }

  bool isSelected() {
    return this._isSelected;
  }

  bool aGranel() {
    return this.granel;
  }
}
