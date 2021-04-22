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

class ShoppingListsApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShoppingListsAppState();
}

class _ShoppingListsAppState extends State<ShoppingListsApp> {
  MQTTManager manager;
  final MQTTAppState currentAppState = MQTTAppState();
  final MarketRepository repository =
      new MarketRepository(new MarketClient(), new MarketCache());
  final ShoppingLists shoppingLists = new ShoppingLists();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    getSavedLists();
    initMQTT();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider<CategoriesBloc>(
        create: (_) => CategoriesBloc(marketRepository: repository),
      ),
      BlocProvider<ProductsBloc>(
        create: (_) => ProductsBloc(marketRepository: repository),
      ),
      BlocProvider<ShoppingListsBloc>(
        create: (_) => ShoppingListsBloc(
            shoppingLists: shoppingLists, sharedPreferences: _prefs),
      ),
    ], child: ShoppingListsRouter());
  }

  Future<void> getSavedLists() async {
    final SharedPreferences prefs = await _prefs;
    List<String> savedLists = prefs.containsKey("saved_lists")
        ? prefs.getStringList("saved_lists")
        : [];

    for (String listName in savedLists)
      shoppingLists.addList(new ShoppingList(listName: listName));
  }

  Future<void> initMQTT() async {
    manager = MQTTManager("carrito4.duckdns.org", "test1", currentAppState);
    manager.initMQTTClient();
    await manager.connect();
    manager.subscribe("test");
    manager.publish("test", "test from flutter");
  }
}
