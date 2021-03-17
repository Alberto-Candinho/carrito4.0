import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_categories_bloc/src/blocs/blocs.dart';

class ShoppingListsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ShoppingListsBloc shoppingListsBloc =
        BlocProvider.of<ShoppingListsBloc>(context, listen: true);
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
                child: _ShoppingLists(shoppingListsBloc),
              ))
            ])),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final newListName =
                await _getNewListName(context /*, shoppingListsBloc*/) ?? '';
            if (newListName != "") {
              shoppingListsBloc.add(CreateList(listName: newListName));
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
  final ShoppingListsBloc shoppingListsBloc;

  _ShoppingLists(this.shoppingListsBloc);
  @override
  Widget build(BuildContext context) {
    if (shoppingListsBloc.state is ShoppingListsLoading) {
      return Center(child: CircularProgressIndicator());
    } else if (shoppingListsBloc.state is ShoppingListsAvailable) {
      return ListView.builder(
          itemCount: shoppingListsBloc.shoppingLists.props.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                leading: IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () {
                      _showCatalog(
                          context,
                          shoppingListsBloc.shoppingLists.props
                              .elementAt(index));
                    }),
                title: Text(
                    shoppingListsBloc.shoppingLists.props.elementAt(index)),
                trailing: IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: () {
                      shoppingListsBloc.add(RemoveList(
                          listName: shoppingListsBloc.shoppingLists.props
                              .elementAt(index)));
                    }),
              ),
            );
          });
    } else {
      // return Center(
      //   child: Text('You dont have any list'),
      // );
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
    //}
    //);
  }

  void _showCatalog(BuildContext context, String listName) {
    Navigator.pushNamed(context, '/catalog', arguments: listName);
    /*Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CatalogView(listName)
      ),
    );*/
  }
}
