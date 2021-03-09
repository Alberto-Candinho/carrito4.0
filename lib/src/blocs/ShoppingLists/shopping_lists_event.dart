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

  final String listName;

  const RemoveList({this.listName});

  @override
  List<Object> get props => [listName];

}