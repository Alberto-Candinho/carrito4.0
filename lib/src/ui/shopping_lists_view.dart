import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_categories_bloc/src/blocs/blocs.dart';
import 'package:market_categories_bloc/src/ui/shopping_list_view.dart';

class ShoppingListsView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final ShoppingListsBloc shoppingListsBloc = BlocProvider.of<ShoppingListsBloc>(context, listen: true);
    return Scaffold(
        appBar: AppBar(title: const Text('Shopping Lists')),
        body: ColoredBox(
          color: Colors.yellow,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: _ShoppingLists(shoppingListsBloc),
                )
              )
            ]
          )
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final newListName = await _getNewListName(context/*, shoppingListsBloc*/);
              shoppingListsBloc.add(CreateList(listName: newListName));
            },
            tooltip: 'Create new list',
            child: Icon(Icons.add_circle),
        )
    );
  }

  Future<String> _getNewListName(BuildContext context/*, ShoppingListsBloc shoppingListsBloc*/) {
    return showDialog (
      context: context,
      builder: (context){
        return AlertDialog(
          content: new TextField(
            autofocus: true,
            decoration: new InputDecoration(
              labelText: 'List Name',
              hintText: 'eg. list1'
            ),
            onSubmitted: (String value) {
              //shoppingListsBloc.add(CreateList(listName: value));
              Navigator.of(context, rootNavigator: true).pop(value);
            }
          )
        );
      },
    );
  }

}

class _ShoppingLists extends StatelessWidget {

  final ShoppingListsBloc shoppingListsBloc;

  _ShoppingLists(this.shoppingListsBloc);
  @override
  Widget build(BuildContext context) {
    if(shoppingListsBloc.state is ShoppingListsLoading){
      return Center(child: CircularProgressIndicator());
    }
    else if(shoppingListsBloc.state is ShoppingListsAvailable) {
      return ListView.builder(
        itemCount: shoppingListsBloc.shoppingLists.props.length,
        itemBuilder: (context, index) {
          return ShoppingListView(
            shoppingListsBloc.shoppingLists.props.elementAt(index),
            (){
              _showCatalog(context, shoppingListsBloc.shoppingLists.props.elementAt(index));
            },
            (){
              _launchRemoveListEvent(shoppingListsBloc.shoppingLists.props.elementAt(index));
            }
          );
        }
      );
    }
    else{
      return Center(
        child: Text('You dont have any list'),
      );
    }
  }

  void _showCatalog(BuildContext context, String listName){
    Navigator.pushNamed(
      context,
      '/catalog',
      arguments: listName
    );
  }

  void _launchRemoveListEvent(String listName){
    shoppingListsBloc.add(RemoveList(listName: listName));
  }

}




