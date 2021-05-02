import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_categories_bloc/src/blocs/blocs.dart';
import 'package:market_categories_bloc/src/models/models.dart';
import 'package:market_categories_bloc/src/ui/ShoppingLists/shopping_list_view.dart';

class ShoppingListsView extends StatelessWidget {
  final String sharedListId;
  final Function onPressedCatalogButton;

  const ShoppingListsView(
      {@required this.sharedListId, @required this.onPressedCatalogButton});

  @override
  Widget build(BuildContext context) {
    if (sharedListId != null)
      BlocProvider.of<ShoppingListsBloc>(context)
          .add(AddList(listId: sharedListId));
    //BlocProvider.of<ShoppingListsBloc>(context).add(CreateList(listName: sharedListName));

    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'Listas da compra',
            style: TextStyle(color: Color(0xFFf0f0f1), fontSize: 25),
          ),
          backgroundColor: Color(0xFF5bb580),
        ),
        body: ColoredBox(
            color: Color(0xFFf3f3f3),
            child: Column(children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(32),
                child: _ShoppingLists(onPressedCatalogButton),
              ))
            ])),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newListName = await _getNewListName(context) ?? '';
            if (newListName != "") {
              BlocProvider.of<ShoppingListsBloc>(context)
                  .add(CreateList(listName: newListName.toString()));
            }
          },
          tooltip: 'Create new list',
          backgroundColor: Color(0xFFf1471d),
          child: Icon(
            Icons.add_circle,
          ),
        ));
  }

  Future<String> _getNewListName(
      BuildContext context /*, ShoppingListsBloc shoppingListsBloc*/) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            title: Text("Introduza o nome da lista"),
            content: new TextField(
                autofocus: true,
                decoration: new InputDecoration(hintText: 'eg. lista compra'),
                onSubmitted: (String value) {
                  Navigator.of(context, rootNavigator: true).pop(value);
                  //shoppingListsBloc.add(CreateList(listName: value));
                }));
      },
    );
  }
}

class _ShoppingLists extends StatelessWidget {
  final Function onPressedCatalogButton;

  _ShoppingLists(this.onPressedCatalogButton);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ShoppingListsBloc, ShoppingListsState>(
        builder: (context, state) {
      if (state is ShoppingListsLoading) {
        return Center(child: CircularProgressIndicator());
      } else {
        ShoppingLists shoppingLists = state.props.elementAt(0);
        if (shoppingLists.props.isNotEmpty) {
          return ListView.builder(
              itemCount: shoppingLists.props.length,
              itemBuilder: (context, index) {
                ShoppingList list = shoppingLists.props.elementAt(index);
                return ShoppingListView(list, onPressedCatalogButton, () {
                  BlocProvider.of<ShoppingListsBloc>(context)
                      .add(RemoveList(list: list));
                });
              });
        } else {
          return Stack(
            children: [
              Container(
                height: 425,
                decoration: new BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/img/cesta.png"),
                        fit: BoxFit.scaleDown)),
              ),
              Container(
                alignment: Alignment(0, 0.25),
                child: Text(
                  "Non ten ningunha lista",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Color(0xFFf1471d),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment(0, 0.40),
                child: Text(
                  "Cree a súa lista e engada os productors para unha mellor experiencia de compra",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black38, fontSize: 15),
                ),
              )
            ],
          );
        }
      }
    });
  }
}
