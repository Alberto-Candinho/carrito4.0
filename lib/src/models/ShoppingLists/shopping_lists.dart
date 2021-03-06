import 'package:equatable/equatable.dart';
import 'package:market_categories_bloc/src/models/ShoppingLists/shopping_list.dart';
import '../models.dart';

//@immutable
class ShoppingLists extends Equatable {
  List<ShoppingList> _shoppingLists = [];

  void addList(ShoppingList list){
    if(!_shoppingLists.contains(list)) {
      _shoppingLists.add(list);
    }
  }

  void removeList(ShoppingList list){
    _shoppingLists.remove(list);
  }

  @override
  List<ShoppingList> get props => _shoppingLists;

}
