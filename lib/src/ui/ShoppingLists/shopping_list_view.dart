import 'package:flutter/material.dart';
import 'package:market_categories_bloc/src/models/models.dart';

class ShoppingListView extends StatefulWidget{

  final ShoppingList list;
  final Function onPressedAddButton;
  final Function onPressedRemoveButton;

  ShoppingListView(this.list, this.onPressedAddButton, this.onPressedRemoveButton);


  @override
  _ShoppingListState createState() => _ShoppingListState();

}

class _ShoppingListState extends State<ShoppingListView>{
  @override
  Widget build(BuildContext context) {
    ShoppingList list = widget.list;
    Function onPressedAddButton = widget.onPressedAddButton;
    Function onPressedRemoveButton = widget.onPressedRemoveButton;
    return Card(
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.add_shopping_cart),
              onPressed: onPressedAddButton,
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
                onTap: (){
                  List<Product> productsInList = list.getProducts();
                  for(int index = 0; index < productsInList.length; index++) print(productsInList[index]);
                },
              )
            ),
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: onPressedRemoveButton,
            ),
            IconButton(
              icon: Icon(Icons.qr_code_scanner_sharp),
              onPressed: (){},
            ),
            IconButton(
              icon: Icon(Icons.share),
              onPressed: (){},
            )
          ],
        )
    );
  }

}
