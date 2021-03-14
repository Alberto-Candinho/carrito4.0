import 'package:flutter/material.dart';

class ShoppingListView extends StatelessWidget{

  final String listName;
  final Function onPressedAddButton;
  final Function onPressedRemoveButton;

  ShoppingListView(this.listName, this.onPressedAddButton, this.onPressedRemoveButton);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.add_shopping_cart),
            onPressed: onPressedAddButton,
          ),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
                child: Text(
                  listName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ),
          ),
          /*Text(
            listName,
          ),*/
          IconButton(
            icon: Icon(Icons.remove),
            onPressed: onPressedRemoveButton,
          ),
          IconButton(
              icon: Icon(Icons.qr_code_scanner_sharp),
          ),
          IconButton(
              icon: Icon(Icons.share),
          )
        ],
      )
    );
  }



}