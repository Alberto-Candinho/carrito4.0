import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market_categories_bloc/src/models/ShoppingLists/shopping_list.dart';
import 'package:meta/meta.dart';
import 'package:market_categories_bloc/src/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shopping_lists_state.dart';
part 'shopping_lists_event.dart';

class ShoppingListsBloc extends Bloc<ShoppingListsEvent, ShoppingListsState> {
  final ShoppingLists shoppingLists;
  final Future<SharedPreferences> sharedPreferences;

  ShoppingListsBloc({@required this.shoppingLists, @required this.sharedPreferences}) : super(ShoppingListsAvailable(shoppingLists));

  @override
  Stream<ShoppingListsState> mapEventToState(
      ShoppingListsEvent event,
      ) async* {
    if (event is CreateList) {
      yield* _mapCreateListToState(event.listName);
    }
    else if(event is RemoveList){
      yield* _mapRemoveListToState(event.list);
    }
    else if(event is AddProductsToList){
      yield* _mapAddProductsToListToState(event.list, event.productsToAdd);
    }
  }

  Stream<ShoppingListsState> _mapAddProductsToListToState(ShoppingList list, List<Product> productsToAdd) async* {
    yield ShoppingListsLoading();
    for(Product product in productsToAdd){
      list.addProduct(product);
    }
    yield ShoppingListsAvailable(shoppingLists);
  }

  Stream<ShoppingListsState> _mapCreateListToState(String listName) async* {
    yield ShoppingListsLoading();

    SharedPreferences prefs;
    List<String> currentLists = [];
    String listId;
    ShoppingList newList;

    prefs = await sharedPreferences;
    listId = listName;
    newList = new ShoppingList.withId(listName: listName, listId: listId);
    shoppingLists.addList(newList);

    for(ShoppingList list in shoppingLists.props) currentLists.add(list.listName);
    prefs.setStringList("saved_lists", currentLists);
    yield ShoppingListsAvailable(shoppingLists);

  }

  Stream<ShoppingListsState> _mapRemoveListToState(ShoppingList list) async* {
    yield ShoppingListsLoading();

    SharedPreferences prefs = await sharedPreferences;
    List<String> currentLists = [];

    shoppingLists.removeList(list);
    for(ShoppingList list in shoppingLists.props) currentLists.add(list.listId);
    prefs.setStringList("saved_lists", currentLists);
    yield ShoppingListsAvailable(shoppingLists);

  }

}