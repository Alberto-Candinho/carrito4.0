import 'package:flutter/material.dart';
import 'router/router.dart';

class ShoppingListsApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShoppingListsAppState();
}

class _ShoppingListsAppState extends State<ShoppingListsApp> {
  ShoppingListsRouterDelegate _routerDelegate = ShoppingListsRouterDelegate();
  ShoppingListsRouteInformationParser _routeInformationParser = ShoppingListsRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Shopping Lists App',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}