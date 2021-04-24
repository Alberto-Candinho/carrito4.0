part of 'shopping_lists_bloc.dart';

@immutable
abstract class ShoppingListsEvent extends Equatable {
  const ShoppingListsEvent();
}

class CreateList extends ShoppingListsEvent{

  final String listName;

  const CreateList({@required this.listName});

  @override
  List<Object> get props => [listName];
}

class RemoveList extends ShoppingListsEvent{

  final ShoppingList list;

  const RemoveList({this.list});

  @override
  List<Object> get props => [list];

}

class AddList extends ShoppingListsEvent{

  final String listId;

  const AddList({@required this.listId});

  @override
  List<Object> get props => [listId];

}
