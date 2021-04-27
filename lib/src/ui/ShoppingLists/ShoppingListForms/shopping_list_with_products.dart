import 'package:flutter/material.dart';
import 'package:market_categories_bloc/src/models/models.dart';
import 'package:share/share.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_categories_bloc/src/blocs/blocs.dart';




class ShoppingListWithProducts extends StatelessWidget {

  final ShoppingList list;
  final Function onPressedAddButton;
  final Function onPressedRemoveButton;
  final Function onPressedQrButton;
  final Function onPressedProductsButton;

  const ShoppingListWithProducts({@required this.list, @required this.onPressedAddButton, @required this.onPressedRemoveButton, @required this.onPressedQrButton, @required this.onPressedProductsButton});

  @override
  Widget build(BuildContext context) {

    return Container(
        color: Colors.white,
        child: Column(
            children:[
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.add_shopping_cart),
                    onPressed: () => onPressedAddButton(list),
                  ),
                  Expanded(
                      child: GestureDetector(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: BlocBuilder<ShoppingListBloc, ShoppingListState>(
                            builder: (context, state) {
                              return Text(
                                (state is ShoppingListAvailable)? list.listName : "Loading lists info",
                                style: TextStyle(fontWeight: FontWeight.bold)
                              );
                            }
                          )
                        ),
                        onTap: onPressedProductsButton,
                      )
                  ),
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: onPressedRemoveButton,
                  ),
                  IconButton(
                    icon: Icon(Icons.qr_code_scanner_sharp),
                    onPressed: onPressedQrButton,
                  ),
                  IconButton(
                    icon: Icon(Icons.share),
                    onPressed: (){
                      if(list.listId != null) Share.share("shoppinglists.com/list/" + list.listId);
                      else showDialog(context: context, builder: (_) => new AlertDialog(
                        title: new Text("Non se pode compartir a lista"),
                        content: new Text("A lista: " + list.listName + " non se pode compartir porque non se pudo xerar un identificador para a mesma"),
                      ));
                    },
                  )
                ],
              ),
              BlocBuilder<ShoppingListBloc, ShoppingListState>(
                builder: (context, state) {
                  if(state is ShoppingListAvailable){
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: list.getProducts().length,
                      itemBuilder: (context, index){
                        Product product = list.getProducts()[index];
                        return Card(
                          child: Row(
                            children: [
                              Text(product.getName(),
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed:(){
                                  BlocProvider.of<ShoppingListBloc>(context).add(RemoveProductOfList(list: list, productToRemove: product));
                                  if(list.isInTrolley()) BlocProvider.of<TrolleyBloc>(context).add(RemovedProductsInList(removedProducts: [product]));
                                }
                              )
                            ]
                          )
                        );
                      }
                    );
                  }
                  else {
                    return Row(
                      children: [
                        Text("Loading lists info",
                          style: TextStyle(fontWeight: FontWeight.bold)
                        )
                      ],
                    );
                  }
                }

              )
            ],
        ),
    );
  }

}