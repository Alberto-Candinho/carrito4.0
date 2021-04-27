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
    _trolleyBloc = new TrolleyBloc(trolley: _trolley, marketRepository: _repository, sharedPreferences: _prefs);
    readSharedPreferences();
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


  Future<void> readSharedPreferences() async{
    final SharedPreferences prefs = await _prefs;
    getSavedLists(prefs);
    getSavedTrolley(prefs);
  }
  void getSavedLists(SharedPreferences prefs) async {
    List<String> savedLists = prefs.containsKey("saved_lists") ? prefs.getStringList("saved_lists") : [];

    for(String listId in savedLists) _shoppingListsBloc.add(AddList(listId: listId));
  }

  void getSavedTrolley(SharedPreferences prefs) async {
    if(prefs.containsKey("listInTrolley")){
      String listId = prefs.getString("listInTrolley");
      ShoppingList listInTrolley = _shoppingLists.getListFromId(listId);
      listInTrolley.setInTrolley(true);
      if(listInTrolley != null) _trolleyBloc.add(LoadList(listProducts: listInTrolley.getProducts(), listId: listInTrolley.listId));

      else print("[Trolley] Erro. Habia unha lista cargada no carro que xa non existe na aplicación");
    }
    if(prefs.containsKey("products_in_trolley") && prefs.containsKey("quantities_in_trolley")){
      List<String> productsIds = prefs.getStringList("products_in_trolley");
      List<String> quantities = prefs.getStringList("quantities_in_trolley");
      if(productsIds.length == quantities.length){
        for(int index = 0; index < productsIds.length; index++)
          _trolleyBloc.add(NewProduct(productId: productsIds[index], quantity: int.parse(quantities[index])));
      }
      else print("[Trolley] Erro. Non hai a mesma cantidade de productos almacenados que de cantidades dos mesmos");
    }

  }

  void _onReceivedMqttMessage(String messageTopic, String messagePayload){
    for(ShoppingList list in _shoppingLists.props){
      if(list.listId == messageTopic) _processListMessage(list, messagePayload);
      else if(list.listId + "/trolley" == messageTopic) _processTrolleyMessage(list, messagePayload);
    }

  }

  void _processTrolleyMessage(ShoppingList list, String messagePayload){

    if(!list.isInTrolley()) {
      list.setInTrolley(true);
      _trolleyBloc.add(LoadList(listProducts: list.getProducts(), listId: list.listId));
    }
    try {
      var trolleyInfo = Map<String, dynamic>.from(json.decode(messagePayload));
      if (trolleyInfo.containsKey("engadir")) {
        String receivedProductId = trolleyInfo["engadir"].toString();
        _trolleyBloc.add(NewProduct(productId: receivedProductId, quantity: 1));
      }
      else if (trolleyInfo.containsKey("sacar")) {
        String receivedProductId = trolleyInfo["sacar"].toString();
        _trolleyBloc.add(RemovedProduct(productId: receivedProductId));
      }
    }catch(e){print(e);}
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
        if(currentProductsIds.contains(receivedProductId)) newProducts.add(affectedList.getProductById(receivedProductId));
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
      if(affectedList.isInTrolley()) _trolleyBloc.add(LoadList(listProducts: newProducts, listId: affectedList.listId));

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
