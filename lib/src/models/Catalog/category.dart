import 'package:flutter/foundation.dart';

class Category {
  final String name;

  const Category({@required this.name});

  String getName(){
    return this.name;
  }

  String toString(){
    return "NOMBRE: " + this.name + "\n";
  }

}