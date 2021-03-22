import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market_categories_bloc/src/models/ShoppingLists/shopping_list.dart';
import 'package:meta/meta.dart';
import 'package:market_categories_bloc/src/models/models.dart';

part 'shopping_lists_state.dart';
part 'shopping_lists_event.dart';

class ShoppingListsBloc extends Bloc<ShoppingListsEvent, ShoppingListsState> {
  final ShoppingLists shoppingLists;
  ShoppingListsBloc({@required this.shoppingLists}) : super(NoShoppingLists());

  @override
  Stream<ShoppingListsState> mapEventToState(
      ShoppingListsEvent event,
      ) async* {
    if (event is CreateList) {
      yield* _mapCreateListToState(event.list);
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
    for(int index = 0; index < productsToAdd.length; index++){
      list.addProduct(productsToAdd[index]);
    }
    yield ShoppingListsAvailable(shoppingLists);
  }

  Stream<ShoppingListsState> _mapCreateListToState(ShoppingList list) async* {
    yield ShoppingListsLoading();
    shoppingLists.addList(list);
    yield ShoppingListsAvailable(shoppingLists);
  }

  Stream<ShoppingListsState> _mapRemoveListToState(ShoppingList list) async* {
    yield ShoppingListsLoading();
    shoppingLists.removeList(list);
    if(shoppingLists.props.isNotEmpty)
      yield ShoppingListsAvailable(shoppingLists);
    else yield NoShoppingLists();
  }
}