part of 'shopping_lists_bloc.dart';

@immutable
abstract class ShoppingListsState extends Equatable {
  const ShoppingListsState();

  @override
  List<Object> get props => [];
}

class ShoppingListsLoading extends ShoppingListsState {}

class ShoppingListsAvailable extends ShoppingListsState {
  const ShoppingListsAvailable(this.shoppingLists);

  final ShoppingLists shoppingLists;

  @override
  List<Object> get props => [shoppingLists];
}
