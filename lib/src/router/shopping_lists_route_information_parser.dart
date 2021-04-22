import 'package:flutter/material.dart';
import 'package:market_categories_bloc/src/router/shopping_lists_route_path.dart';

class ShoppingListsRouteInformationParser extends RouteInformationParser<ShoppingListsRoutePath> {
  @override
  Future<ShoppingListsRoutePath> parseRouteInformation(RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location);
    // Handle '/'
    if (uri.pathSegments.length == 0) {
      return ShoppingListsRoutePath.home();
    }
    // Handle '/list/:listName'
    else if (uri.pathSegments.length == 2) {
      if (uri.pathSegments[0] != 'list') return ShoppingListsRoutePath.error();
      String listName = uri.pathSegments[1];
      return ShoppingListsRoutePath.homeWithSharedList(listName);
    }
    else return ShoppingListsRoutePath.error();
  }

  @override
  RouteInformation restoreRouteInformation(ShoppingListsRoutePath path) {
    if (path.isError) {
      return RouteInformation(location: '/404');
    }
    if (path.isHome) {
      return RouteInformation(location: '/');
    }
    if (path.isHomeWithSharedList) {
      return RouteInformation(location: '/list/${path.listName}');
    }
    if (path.isCatalog){
      return RouteInformation(location: '/catalog');
    }
    return null;
  }
}