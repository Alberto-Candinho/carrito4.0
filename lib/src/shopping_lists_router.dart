import 'package:flutter/material.dart';
import 'router/router.dart';

class ShoppingListsRouter extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShoppingListsRouterState();
}

class _ShoppingListsRouterState extends State<ShoppingListsRouter> {
  ShoppingListsRouterDelegate _routerDelegate = ShoppingListsRouterDelegate();
  ShoppingListsRouteInformationParser _routeInformationParser =
      ShoppingListsRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Shopping Lists App',
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}
