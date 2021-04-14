import 'package:flutter/material.dart';
import 'package:market_categories_bloc/src/models/models.dart';
import 'package:qr_flutter/qr_flutter.dart';


class ShoppingListView extends StatefulWidget{

  final ShoppingList list;
  final Function onPressedAddButton;
  final Function onPressedRemoveButton;

  ShoppingListView(this.list, this.onPressedAddButton, this.onPressedRemoveButton);


  @override
  _ShoppingListState createState() => _ShoppingListState();

}

class _ShoppingListState extends State<ShoppingListView>{

  bool _showQR = false;

  void _switchQR() {
    setState(() {
      if(_showQR) _showQR = false;
      else _showQR = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    ShoppingList list = widget.list;
    Function onPressedAddButton = widget.onPressedAddButton;
    Function onPressedRemoveButton = widget.onPressedRemoveButton;
    Function onPressedQRButton = (){
      _switchQR();
    };

    if(!_showQR) {
      return ShoppingListSummaryView(list: list, onPressedAddButton: onPressedAddButton, onPressedRemoveButton: onPressedRemoveButton, onPressedQrButton: onPressedQRButton);
    }
    else {
      return ShoppingListWithQR(list: list, onPressedAddButton: onPressedAddButton, onPressedRemoveButton: onPressedRemoveButton, onPressedQrButton: onPressedQRButton);
    }
  }


}

class ShoppingListWithQR extends StatelessWidget {

  final ShoppingList list;
  final Function onPressedAddButton;
  final Function onPressedRemoveButton;
  final Function onPressedQrButton;

  const ShoppingListWithQR({@required this.list, @required this.onPressedAddButton, @required this.onPressedRemoveButton, @required this.onPressedQrButton});

  @override
  Widget build(BuildContext context) {
    return Column(
        children:[
          Row(
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
                    onTap: () {
                      List<Product> productsInList = list.getProducts();
                      for (int index = 0; index <
                          productsInList.length; index++)
                        print(productsInList[index]);
                    },
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
                onPressed: () {},
              )
            ],
          ),
          QrImage(
            data: list.listName,
          )
        ]

    );
  }
}

class ShoppingListSummaryView extends StatelessWidget{

  final ShoppingList list;
  final Function onPressedAddButton;
  final Function onPressedRemoveButton;
  final Function onPressedQrButton;

  const ShoppingListSummaryView({@required this.list, @required this.onPressedAddButton, @required this.onPressedRemoveButton, @required this.onPressedQrButton});

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
                    onTap: () {
                      List<Product> productsInList = list.getProducts();
                      for (int index = 0; index <
                          productsInList.length; index++)
                        print(productsInList[index]);
                    },
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
                onPressed: () {},
              )
            ],
          )
      );
    }
}


