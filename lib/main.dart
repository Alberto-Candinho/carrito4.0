import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:market_categories_bloc/src/simple_bloc_observer.dart';
import 'src/app.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(App());
}
