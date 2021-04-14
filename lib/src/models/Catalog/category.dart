import 'package:flutter/foundation.dart';

class Category {
  final String name;
  //final List<String> tags;

  //const Category({@required this.name, @required this.tags});
  const Category({@required this.name});

  String getName(){
    return this.name;
  }

  /*List<String> getTags(){
    return this.tags;
  }*/

  /*String toString(){
    return "NOMBRE: " + this.name + "\n" + "TAGS: " + this.tags.toString() + "\n";
  }*/

  String toString(){
    return "NOMBRE: " + this.name + "\n";
  }

}