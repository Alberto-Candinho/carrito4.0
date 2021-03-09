import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
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
      yield* _mapCreateListToState(event.listName);
    }
    else if(event is RemoveList){
      yield* _mapRemoveListToState(event.listName);
    }
  }

  Stream<ShoppingListsState> _mapCreateListToState(String listName) async* {
    yield ShoppingListsLoading();
    shoppingLists.createList(listName);
    yield ShoppingListsAvailable(shoppingLists);
  }

  Stream<ShoppingListsState> _mapRemoveListToState(String listName) async* {
    yield ShoppingListsLoading();
    shoppingLists.removeList(listName);
    if(shoppingLists.props.isNotEmpty)
      yield ShoppingListsAvailable(shoppingLists);
    else yield NoShoppingLists();
  }
}