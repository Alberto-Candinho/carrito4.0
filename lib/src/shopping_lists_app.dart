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
  final Trolley _trolley = new Trolley();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  TrolleyBloc _trolleyBloc;
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
    _trolleyBloc = new TrolleyBloc(trolley: _trolley, marketRepository: _repository);
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
      ),
      BlocProvider<TrolleyBloc>(
        create: (_) => _trolleyBloc
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
      if(list.listId == messageTopic) _processListMessage(list, messagePayload);
      else if(list.listId + "/trolley" == messageTopic) _processTrolleyMessage(list, messagePayload);
    }

  }

  void _processTrolleyMessage(ShoppingList list, String messagePayload){
    if(messagePayload == "conexion establecida"){
      _trolleyBloc.add(LoadListProducts(listProducts: list.getProducts()));
      list.setInTrolley(true);
    }
    else{
      var trolleyInfo = Map<String, dynamic>.from(json.decode(messagePayload));
      if(trolleyInfo.containsKey("engadir")){
        String receivedProductId = trolleyInfo["engadir"].toString();
        _trolleyBloc.add(NewProduct(productId: receivedProductId));
      }
      else if(trolleyInfo.containsKey("sacar")){
        String receivedProductId = trolleyInfo["sacar"].toString();
        _trolleyBloc.add(RemovedProduct(productId: receivedProductId));
      }
    }
  }

  void _processListMessage(ShoppingList affectedList, String messagePayload) async {
    var listInfo = Map<String, dynamic>.from(json.decode(messagePayload));
    String receivedListName = listInfo["nome"].toString();
    List<String> receivedProductsIds = List<String>.from(listInfo["productos"]);
    List<String> currentProductsIds = affectedList.getProductsIds();
    print("[${affectedList.listName}] Mensaxe mqtt recibido. Nome de lista recibido: $receivedListName. Productos recibidos: ${receivedProductsIds.toString()}");
    if(receivedProductsIds.toString() != currentProductsIds.toString()){
      List<Product> newProducts = [];
      List<Future<Product>> futureProducts = [];
      for(String receivedProductId in receivedProductsIds){
        if(currentProductsIds.contains(receivedProductId)){
          newProducts.add(affectedList.getProductById(receivedProductId));
        }
        else{
          Future<Product> futureProduct = _repository.getProductInfo(receivedProductId);
          futureProducts.add(futureProduct);
        }
      }
      for(Future<Product> futureProduct in futureProducts){
        Product newProduct = await futureProduct;
        newProducts.add(newProduct);
      }
      _shoppingListBloc.add(SetProductsToList(list: affectedList, productsSet: newProducts));
      if(affectedList.isInTrolley()) _trolleyBloc.add(LoadListProducts(listProducts: newProducts));
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
          _manager.subscribe(list.listId + "/trolley");
          list.setSubscribed(true);
        } on Exception catch (e) {
          print("[MQTT] Couldn't subscribe to list ${list.listId} => $e");

        }
      }
    }
  }


}
