import 'package:flutter/material.dart';
import 'package:market_categories_bloc/src/models/models.dart';
import 'package:market_categories_bloc/src/ui/payment_view.dart';

class ShoppingListInTrolley extends StatelessWidget {
  final ShoppingList list;
  final Trolley trolley;

  const ShoppingListInTrolley({@required this.list, @required this.trolley});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: trolley.getTrolleyItems().length,
          itemBuilder: (context, index) {
            TrolleyItem itemInTrolley = trolley.getTrolleyItemByIndex(index);
            Product product = itemInTrolley.product;
            Color cardColor;
            if (itemInTrolley.isFromList()) {
              (itemInTrolley.quantity > 0)
                  ? cardColor = Colors.greenAccent
                  : cardColor = Colors.white;
            } else
              cardColor = Colors.green;
            return Card(
                child: Text(
                  itemInTrolley.product.getName() +
                      " " +
                      itemInTrolley.quantity.toString(),
                  style: TextStyle(fontStyle: FontStyle.normal),
                ),
                color: cardColor);
          }),
      Divider(
        height: 20,
        thickness: 5,
        indent: 20,
        endIndent: 20,
      ),
      Row(
        children: [
          Text(
            trolley.getTotalPrice().toString(),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF006b1d),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreditCardPage()),
              );
            },
            icon: Icon(Icons.payment, size: 18),
            label: Text(
              "PAGAR",
              //style: TextStyle(color: Color(0xFF006b1d)),
            ),
          )
        ],
      ),
    ]);
  }
}
