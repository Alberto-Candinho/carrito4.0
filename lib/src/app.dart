import 'package:flutter/material.dart';
import 'package:market_categories_bloc/src/models/models.dart';
import 'package:market_categories_bloc/src/resources/market_cache.dart';
import 'package:market_categories_bloc/src/resources/market_client.dart';
import 'package:market_categories_bloc/src/resources/market_repository.dart';
import 'ui/shopping_lists_view.dart';
import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_categories_bloc/src/blocs/blocs.dart';
import 'package:market_categories_bloc/src/ui/views.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MarketRepository repository = new MarketRepository(new MarketClient(), new MarketCache());
    final ShoppingLists shoppingLists = new ShoppingLists();
    return MultiBlocProvider(
      providers: [
        BlocProvider<CatalogBloc>(
          create: (_) => CatalogBloc(marketRepository: repository),
        ),
        BlocProvider<ShoppingListsBloc>(
          create: (_) => ShoppingListsBloc(shoppingLists: shoppingLists),
        ),
      ],
      child: MaterialApp(
        title: 'Shopping Lists with Market Categories',
        //home: ShoppingListsView(),
        initialRoute: '/',
        routes: {
          '/': (context) => ShoppingListsView(),
          '/catalog': (context) => CatalogView(),
        },
      ),
    );
  }
}
