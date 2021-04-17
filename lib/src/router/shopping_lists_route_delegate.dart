import 'package:flutter/material.dart';
import 'package:market_categories_bloc/src/router/shopping_lists_route_path.dart';
import '../ui/views.dart';
import '../models/models.dart';

class ShoppingListsRouterDelegate extends RouterDelegate<ShoppingListsRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ShoppingListsRoutePath> {

  final GlobalKey<NavigatorState> navigatorKey;

  String _listName;
  bool showError = false;
  bool showCatalog = false;
  ShoppingList _catalogOriginList;

  ShoppingListsRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  ShoppingListsRoutePath get currentConfiguration {
    if (showError) {
      return ShoppingListsRoutePath.error();
    }
    else if(showCatalog){
      return ShoppingListsRoutePath.catalog();
    }
    return _listName == null
        ? ShoppingListsRoutePath.home()
        : ShoppingListsRoutePath.homeWithSharedList(_listName);
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(key: ValueKey('HomeView'), child: ShoppingListsView(sharedListName: _listName, onPressedCatalogButton: _catalogButtonTapped)),
        if (showError)
          MaterialPage(key: ValueKey('ErrorView'), child: ErrorView())
        else if(showCatalog)
          MaterialPage(key: ValueKey('CatalogView'), child: CatalogInfoView(list: _catalogOriginList))
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        else{
          _listName = null;
          showError = false;
          showCatalog = false;
          notifyListeners();
          return true;
        }
      },
    );
  }

  @override
  Future<void> setNewRoutePath(ShoppingListsRoutePath path) async {
    if (path.isNotValid) {
      _listName = null;
      showError = true;
      showCatalog = false;
      return;
    }
    else if(path.isHome) {
      _listName = null;
      showError = false;
      showCatalog = false;
      return;
    }
    else if(path.isHomeWithSharedList){
      _listName = path.listName;
      showError = false;
      showCatalog = false;
      return;
    }
    else if(path.isCatalog){
      _listName = null;
      showError = false;
      showCatalog = true;
      return;
    }
  }

  void _catalogButtonTapped(ShoppingList originList) {
    _catalogOriginList = originList;
    showCatalog = true;
    _listName = null;
    showError = false;
    notifyListeners();
  }
}