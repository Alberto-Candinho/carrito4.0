import 'package:flutter/foundation.dart';

class Product {

  final String name;
  final String description;
  final String brand;
  final double unitPrice;
  bool _isSelected = false;

  Product({@required this.name, @required this.description, @required this.brand, @required this.unitPrice});

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

  String toString(){
    return this.name + " " + this.brand + "\n" + this.description + "\n" + this.unitPrice.toString() + "\n";
  }

  void setIsSelected(bool isSelected){
    this._isSelected = isSelected;
  }

  bool isSelected(){
    return this._isSelected;
  }

}