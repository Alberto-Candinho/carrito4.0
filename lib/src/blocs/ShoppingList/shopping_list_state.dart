part of 'shopping_list_bloc.dart';

@immutable
abstract class ShoppingListState extends Equatable {
  const ShoppingListState();

  @override
  List<Object> get props => [];
}

class ShoppingListLoading extends ShoppingListState {}

class ShoppingListAvailable extends ShoppingListState {}