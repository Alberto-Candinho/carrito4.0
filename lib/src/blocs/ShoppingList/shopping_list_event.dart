part of 'shopping_list_bloc.dart';

@immutable
abstract class ShoppingListEvent extends Equatable {
  const ShoppingListEvent();
}

class AddProductsToList extends ShoppingListEvent{

  final ShoppingList list;
  final List<Product> productsToAdd;

  const AddProductsToList({this.list, this.productsToAdd});

  @override
  List<Object> get props => [list, productsToAdd];

}

class SetProductsToList extends ShoppingListEvent{

  final ShoppingList list;
  final List<Product> productsSet;

  const SetProductsToList({this.list, this.productsSet});

  @override
  List<Object> get props => [list, productsSet];

}

class RemoveProductOfList extends ShoppingListEvent{

  final ShoppingList list;
  final Product productToRemove;

  const RemoveProductOfList({this.list, this.productToRemove});

  @override
  List<Object> get props => [list, productToRemove];

}

class RenameList extends ShoppingListEvent{

  final ShoppingList list;
  final String newName;

  const RenameList({this.list, this.newName});

  @override
  List<Object> get props => [list, newName];

}
