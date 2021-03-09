import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class ShoppingLists extends Equatable {
  List<String> _shoppingLists = [];

  void createList(String listName){
    if(!_shoppingLists.contains(listName)) {
      _shoppingLists.add(listName);
    }
  }

  void removeList(String listName){
    _shoppingLists.remove(listName);
  }

  @override
  // TODO: implement props
  List<String> get props => _shoppingLists;

}
