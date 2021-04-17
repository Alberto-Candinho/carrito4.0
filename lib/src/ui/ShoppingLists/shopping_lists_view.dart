import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_categories_bloc/src/blocs/blocs.dart';
import 'package:market_categories_bloc/src/models/models.dart';
import 'package:market_categories_bloc/src/ui/ShoppingLists/shopping_list_view.dart';

class ShoppingListsView extends StatelessWidget {

  String sharedListName;
  final Function onPressedCatalogButton;

  ShoppingListsView(
      {@required this.sharedListName, @required this.onPressedCatalogButton});

  @override
  Widget build(BuildContext context) {
    if (sharedListName != null) {
      BlocProvider.of<ShoppingListsBloc>(context).add(
          CreateList(list: new ShoppingList(listName: sharedListName)));
      sharedListName = null;
    }

    return Scaffold(
        appBar: AppBar(title: const Text('Shopping Lists')),
        body: ColoredBox(
            color: Colors.yellow,
            child: Column(
                children: [
                  Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: _ShoppingLists(onPressedCatalogButton),
                      )
                  )
                ]
            )
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newListName = await _getNewListName(context);
            BlocProvider.of<ShoppingListsBloc>(context).add(
                CreateList(list: new ShoppingList(listName: newListName)));
          },
          tooltip: 'Create new list',
          child: Icon(Icons.add_circle),
        )
    );
  }


  Future<String> _getNewListName(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            content: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'List Name',
                    hintText: 'eg. list1'
                ),
                onSubmitted: (String value) {
                  Navigator.of(context, rootNavigator: true).pop(value);
                }
            )
        );
      },
    );
  }
}



class _ShoppingLists extends StatelessWidget {

  final Function onPressedCatalogButton;

  _ShoppingLists(this.onPressedCatalogButton);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListsBloc, ShoppingListsState>(builder: (context, state){
      if(state is ShoppingListsLoading){
        return Center(child: CircularProgressIndicator());
      }
      else if(state is ShoppingListsAvailable) {
        ShoppingLists shoppingLists = state.props.elementAt(0);
        return ListView.builder(
          itemCount: shoppingLists.props.length,
          itemBuilder: (context, index) {
            ShoppingList list = shoppingLists.props.elementAt(index);
            return ShoppingListView(list, onPressedCatalogButton,
              (){
                BlocProvider.of<ShoppingListsBloc>(context).add(RemoveList(list: list));
              }
            );
          }
        );
      }
      else{
        return Center(child: Text('You dont have any list'));
      }
    });
  }


}




