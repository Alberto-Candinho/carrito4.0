import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market_categories_bloc/src/models/ShoppingLists/shopping_list.dart';
import 'package:market_categories_bloc/src/mqtt/MQTTManager.dart';
import 'package:meta/meta.dart';
import 'package:market_categories_bloc/src/models/models.dart';

part 'shopping_list_state.dart';
part 'shopping_list_event.dart';

class ShoppingListBloc extends Bloc<ShoppingListEvent, ShoppingListState> {

  final MQTTManager mqttManager;

  ShoppingListBloc({@required this.mqttManager}) : super(ShoppingListAvailable());

  @override
  Stream<ShoppingListState> mapEventToState(ShoppingListEvent event) async* {
    if(event is AddProductsToList){
      yield* _mapAddProductsToListToState(event.list, event.productsToAdd);
    }
    else if(event is RemoveProductOfList){
      yield* _mapRemoveProductOfListToState(event.list, event.productToRemove);
    }
    else if(event is RenameList){
      yield* _mapRenameListToState(event.list, event.newName);
    }
    else if(event is SetProductsToList){
      yield* _mapSetProductsToListToState(event.list, event.productsSet);
    }
  }
  
  Stream<ShoppingListState> _mapAddProductsToListToState(ShoppingList list, List<Product> productsToAdd) async* {
    yield ShoppingListLoading();
    for(Product product in productsToAdd) list.addProduct(product);
    mqttManager.publish(list.listId, list.toJson());

    yield ShoppingListAvailable();
  }

  Stream<ShoppingListState> _mapRemoveProductOfListToState(ShoppingList list, Product productToRemove) async* {
    yield ShoppingListLoading();
    list.removeProduct(productToRemove);
    mqttManager.publish(list.listId, list.toJson());
    yield ShoppingListAvailable();

  }

  Stream<ShoppingListState> _mapRenameListToState(ShoppingList list, String newName) async* {
    yield ShoppingListLoading();
    list.listName = newName;
    yield ShoppingListAvailable();
  }

  Stream<ShoppingListState> _mapSetProductsToListToState(ShoppingList list, List<Product> newProducts) async* {
    yield ShoppingListLoading();
    list.setProducts(newProducts);
    yield ShoppingListAvailable();
  }
  




}