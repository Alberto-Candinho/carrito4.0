import 'package:flutter/material.dart';
import 'package:market_categories_bloc/src/models/models.dart';
import 'package:market_categories_bloc/src/mqtt/MQTTAppState.dart';
import 'package:market_categories_bloc/src/mqtt/MQTTManager.dart';
import 'package:market_categories_bloc/src/resources/market_cache.dart';
import 'package:market_categories_bloc/src/resources/market_client.dart';
import 'package:market_categories_bloc/src/resources/market_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_categories_bloc/src/blocs/blocs.dart';
import 'package:market_categories_bloc/src/shopping_lists_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class ShoppingListsApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShoppingListsAppState();
}

class _ShoppingListsAppState extends State<ShoppingListsApp> {

  MQTTManager _manager;
  final MQTTAppState _currentAppState = MQTTAppState();

  final MarketRepository _repository = new MarketRepository(new MarketClient(), new MarketCache());
  final ShoppingLists _shoppingLists = new ShoppingLists();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  ShoppingListBloc _shoppingListBloc;
  ShoppingListsBloc _shoppingListsBloc;
  CategoriesBloc _categoriesBloc;
  ProductsBloc _productsBloc;

  @override
  void initState() {
    super.initState();
    initMQTT();
    _shoppingListsBloc = new ShoppingListsBloc(shoppingLists: _shoppingLists, sharedPreferences: _prefs, mqttManager: _manager, marketRepository: _repository);
    _shoppingListBloc = new ShoppingListBloc(mqttManager: _manager);
    _categoriesBloc = new CategoriesBloc(marketRepository: _repository);
    _productsBloc = new ProductsBloc(marketRepository: _repository);
    getSavedLists();
    _manager.connect().then((value) => _subscribeToLists()).onError((error, stackTrace) => print("[MQTT] Couldn't connect to broker"));
  }

  @override
  void dispose() {
    for(ShoppingList list in _shoppingLists.props) _manager.unsubscribe(list.listId);
    _manager.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<CategoriesBloc>(
        create: (_) => _categoriesBloc,
      ),
      BlocProvider<ProductsBloc>(
        create: (_) => _productsBloc,
      ),
      BlocProvider<ShoppingListsBloc>(
        create: (_) => _shoppingListsBloc,
      ),
      BlocProvider<ShoppingListBloc>(
        create: (_) => _shoppingListBloc,
      )
    ], child: ShoppingListsRouter());
  }


  Future<void> getSavedLists() async {
    final SharedPreferences prefs = await _prefs;
    List<String> savedLists = prefs.containsKey("saved_lists") ? prefs.getStringList("saved_lists") : [];

    for(String listId in savedLists) _shoppingListsBloc.add(AddList(listId: listId));
  }

  void _onReceivedMqttMessage(String messageTopic, String messagePayload){
    for(ShoppingList list in _shoppingLists.props){
      if(list.listId == messageTopic) _processMqttMessage(list, messagePayload);
    }

  }

  void _processMqttMessage(ShoppingList affectedList, String messagePayload){
    var listInfo = Map<String, dynamic>.from(json.decode(messagePayload));
    String receivedListName = listInfo["nome"].toString();
    List<String> receivedProductsIdsList = List<String>.from(listInfo["productos"]);
    if(receivedProductsIdsList.toString() != affectedList.getProductsIds().toString()){
      List<Product> newProducts = [];
      for(int index = 0; index < receivedProductsIdsList.length; index++){
        Future<Product> newProduct = _repository.getProductInfo(receivedProductsIdsList[index].toString());
        newProduct.then((value) => newProducts.add(value)).onError((error, stackTrace) => print("Couldn't find info for product with id=" + receivedProductsIdsList[index]));
      }
      _shoppingListBloc.add(SetProductsToList(list: affectedList, productsSet: newProducts));

    }
    if(receivedListName != affectedList.listName) _shoppingListBloc.add(RenameList(list: affectedList, newName: receivedListName));
  }

  void initMQTT() async {
    _manager = MQTTManager("carrito4.duckdns.org", "test1", _currentAppState, _onReceivedMqttMessage);
    _manager.initMQTTClient();
  }

  void _subscribeToLists(){
    for(ShoppingList list in _shoppingLists.props){
      if(!list.isSubscribed()){
        try{
          _manager.subscribe(list.listId);
          list.setSubscribed(true);
        } on Exception catch (e) {
          print("[MQTT] Couldn't subscribe to list ${list.listId} => $e");

        }
      }
    }
  }


}
