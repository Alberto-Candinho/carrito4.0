import 'package:flutter/material.dart';
import 'package:market_categories_bloc/src/models/models.dart';
import 'package:market_categories_bloc/src/resources/market_cache.dart';
import 'package:market_categories_bloc/src/resources/market_client.dart';
import 'package:market_categories_bloc/src/resources/market_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_categories_bloc/src/blocs/blocs.dart';
import 'package:market_categories_bloc/src/shopping_lists_app.dart';

class App extends StatelessWidget {

  final MarketRepository repository = new MarketRepository(new MarketClient(), new MarketCache());
  final ShoppingLists shoppingLists = new ShoppingLists();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CategoriesBloc>(
          create: (_) => CategoriesBloc(marketRepository: repository),
        ),
        BlocProvider<ProductsBloc>(
          create: (_) => ProductsBloc(marketRepository: repository),
        ),
        BlocProvider<ShoppingListsBloc>(
          create: (_) => ShoppingListsBloc(shoppingLists: shoppingLists),
        ),
      ],

      child: ShoppingListsApp()

    );
  }
}
