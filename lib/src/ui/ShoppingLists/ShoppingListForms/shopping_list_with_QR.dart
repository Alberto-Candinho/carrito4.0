import 'package:flutter/material.dart';
import 'package:market_categories_bloc/src/models/models.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';


class ShoppingListWithQR extends StatelessWidget {

  final ShoppingList list;
  final Function onPressedAddButton;
  final Function onPressedRemoveButton;
  final Function onPressedQrButton;
  final Function onPressedProductsButton;

  const ShoppingListWithQR({@required this.list, @required this.onPressedAddButton, @required this.onPressedRemoveButton, @required this.onPressedQrButton, @required this.onPressedProductsButton});

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
                          child: Text(
                            list.listName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
              QrImage(
                data: list.listName,
              )
            ]
        )
    );
  }
}