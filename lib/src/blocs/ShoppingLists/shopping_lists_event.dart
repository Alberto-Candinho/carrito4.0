part of 'shopping_lists_bloc.dart';

@immutable
abstract class ShoppingListsEvent extends Equatable {
  const ShoppingListsEvent();
}

class CreateList extends ShoppingListsEvent{

  final ShoppingList list;

  const CreateList({@required this.list});

  @override
  List<Object> get props => [list];

}

class RemoveList extends ShoppingListsEvent{

  final ShoppingList list;

  const RemoveList({this.list});

  @override
  List<Object> get props => [list];

}

class AddProductsToList extends ShoppingListsEvent{

  final ShoppingList list;
  final List<Product> productsToAdd;

  const AddProductsToList({this.list, this.productsToAdd});

  @override
  List<Object> get props => [list, productsToAdd];

}