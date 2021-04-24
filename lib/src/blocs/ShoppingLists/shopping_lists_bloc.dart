import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market_categories_bloc/src/models/ShoppingLists/shopping_list.dart';
import 'package:market_categories_bloc/src/mqtt/MQTTAppState.dart';
import 'package:market_categories_bloc/src/mqtt/MQTTManager.dart';
import 'package:market_categories_bloc/src/resources/market_repository.dart';
import 'package:meta/meta.dart';
import 'package:market_categories_bloc/src/models/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'shopping_lists_state.dart';
part 'shopping_lists_event.dart';

class ShoppingListsBloc extends Bloc<ShoppingListsEvent, ShoppingListsState> {
  
  final ShoppingLists shoppingLists;
  final Future<SharedPreferences> sharedPreferences;
  final MQTTManager mqttManager;
  final MarketRepository marketRepository;
  
  ShoppingListsBloc({@required this.shoppingLists, @required this.sharedPreferences, @required this.mqttManager, @required this.marketRepository}) : super(ShoppingListsAvailable(shoppingLists));

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
    else if(event is AddList){
      yield* _mapAddListToState(event.listId);
    }

  }

  Stream<ShoppingListsState> _mapCreateListToState(String listName) async* {
    yield ShoppingListsLoading();

    SharedPreferences prefs;
    List<String> currentLists = [];
    String listId;
    ShoppingList newList;

    prefs = await sharedPreferences;
    listId = Uuid().v1();
    print("ID DA LISTA CON NOME $listName: $listId");

    newList = new ShoppingList.withName(listName: listName, listId: listId);
    shoppingLists.addList(newList);

    //Saving current lists in shared preferences
    for(ShoppingList list in shoppingLists.props) currentLists.add(list.listId);
    prefs.setStringList("saved_lists", currentLists);

    //Subscribe to this list topic
    if(mqttManager.getCurrentState().getAppConnectionState == MQTTAppConnectionState.connected){
      try{
        mqttManager.subscribe(newList.listId);
        newList.setSubscribed(true);
        mqttManager.publish(newList);
      } on Exception catch (e) {
        print("[MQTT] Couldn't subscribe to list ${newList.listId} => $e");

      }
    }

    yield ShoppingListsAvailable(shoppingLists);

  }

  Stream<ShoppingListsState> _mapRemoveListToState(ShoppingList list) async* {
    yield ShoppingListsLoading();

    SharedPreferences prefs = await sharedPreferences;
    List<String> currentLists = [];

    shoppingLists.removeList(list);
    for(ShoppingList list in shoppingLists.props) currentLists.add(list.listId);
    prefs.setStringList("saved_lists", currentLists);

    list.setProducts([]);
    mqttManager.publish(list);
    yield ShoppingListsAvailable(shoppingLists);

  }

  Stream<ShoppingListsState> _mapAddListToState(String listId) async* {
    yield ShoppingListsLoading();

    SharedPreferences prefs = await sharedPreferences;
    List<String> currentLists = [];
    ShoppingList newList;

    newList = new ShoppingList(listId: listId);
    shoppingLists.addList(newList);

    //Saving current lists in shared preferences
    for(ShoppingList list in shoppingLists.props) currentLists.add(list.listId);
    prefs.setStringList("saved_lists", currentLists);

    //Subscribe to this list topic
    if(mqttManager.getCurrentState().getAppConnectionState == MQTTAppConnectionState.connected){
      try{
        mqttManager.subscribe(newList.listId);
        newList.setSubscribed(true);
      } on Exception catch (e) {
        print("[MQTT] Couldn't subscribe to list ${newList.listId} => $e");

      }
    }

    yield ShoppingListsAvailable(shoppingLists);


  }

}