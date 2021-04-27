import 'package:flutter/material.dart';
import 'package:market_categories_bloc/src/models/models.dart';

class ShoppingListInTrolley extends StatelessWidget {

  final ShoppingList list;
  final Trolley trolley;

  const ShoppingListInTrolley({@required this.list, @required this.trolley});

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: trolley.getTrolleyItems().length,
        itemBuilder: (context, index){
          TrolleyItem itemInTrolley = trolley.getTrolleyItemByIndex(index);
          Color cardColor;
          if(itemInTrolley.isFromList()){
            (itemInTrolley.quantity > 0)? cardColor = Colors.greenAccent: cardColor = Colors.white;
          }
          else cardColor = Colors.green;
          return Card(
              child: Text(itemInTrolley.product.getName() + " " + itemInTrolley.quantity.toString(),
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              color: cardColor
            );
          }

    );
  }

}
