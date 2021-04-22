import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:market_categories_bloc/src/simple_bloc_observer.dart';
import 'src/shopping_lists_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = SimpleBlocObserver();
  runApp(ShoppingListsApp());
}
