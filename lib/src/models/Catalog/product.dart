import 'package:flutter/foundation.dart';

class Product {
  final int id;
  final String name;
  final double unitPrice;
  bool _isSelected = false;

  Product({@required this.id, @required this.name, @required this.unitPrice});

  int getId(){
    return this.id;
  }

  String getName(){
    return this.name;
  }

  double getPrice(){
    return this.unitPrice;
  }

  String toString(){
    return this.id.toString() + "\n" + this.name + "\n" + this.unitPrice.toString() + "\n";
  }

  void setIsSelected(bool isSelected){
    this._isSelected = isSelected;
  }

  bool isSelected(){
    return this._isSelected;
  }

}