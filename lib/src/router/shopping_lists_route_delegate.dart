import 'package:flutter/material.dart';
import 'package:market_categories_bloc/src/router/shopping_lists_route_path.dart';
import '../ui/views.dart';
import '../models/models.dart';

class ShoppingListsRouterDelegate extends RouterDelegate<ShoppingListsRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<ShoppingListsRoutePath> {

  final GlobalKey<NavigatorState> navigatorKey;

  String _listId;
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
    return _listId == null
        ? ShoppingListsRoutePath.home()
        : ShoppingListsRoutePath.homeWithSharedList(_listId);
  }

  @override
  Widget build(BuildContext context) {
    String newSharedListId = _listId;
    _listId = null;
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(key: ValueKey('HomeView'), child: ShoppingListsView(sharedListId: newSharedListId, onPressedCatalogButton: _catalogButtonTapped)),
        if (showError)
          MaterialPage(key: ValueKey('ErrorView'), child: ErrorView())
        else if(showCatalog)
          MaterialPage(key: ValueKey('CatalogView'), child: CatalogInfoView(list: _catalogOriginList))
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        else{
          _listId = null;
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
    if (path.isError) {
      _listId = null;
      showError = true;
      showCatalog = false;
      return;
    }
    else if(path.isHome) {
      _listId = null;
      showError = false;
      showCatalog = false;
      return;
    }
    else if(path.isHomeWithSharedList){
      _listId = path.listId;
      showError = false;
      showCatalog = false;
      return;
    }
    else if(path.isCatalog){
      _listId = null;
      showError = false;
      showCatalog = true;
      return;
    }
  }

  void _catalogButtonTapped(ShoppingList originList) {
    _catalogOriginList = originList;
    showCatalog = true;
    _listId = null;
    showError = false;
    notifyListeners();
  }
}