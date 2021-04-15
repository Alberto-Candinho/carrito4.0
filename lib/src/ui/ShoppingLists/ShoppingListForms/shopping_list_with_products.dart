import 'package:flutter/material.dart';
import 'package:market_categories_bloc/src/models/models.dart';

class ShoppingListWithProducts extends StatefulWidget {

  final ShoppingList list;
  final Function onPressedAddButton;
  final Function onPressedRemoveButton;
  final Function onPressedQrButton;
  final Function onPressedProductsButton;

  const ShoppingListWithProducts({@required this.list, @required this.onPressedAddButton, @required this.onPressedRemoveButton, @required this.onPressedQrButton, @required this.onPressedProductsButton});

  @override
  _ShoppingListWithProductsState createState() => _ShoppingListWithProductsState();

}
class _ShoppingListWithProductsState extends State<ShoppingListWithProducts> {


  @override
  Widget build(BuildContext context) {

    final ShoppingList list = widget.list;
    final Function onPressedAddButton = widget.onPressedAddButton;
    final Function onPressedRemoveButton = widget.onPressedRemoveButton;
    final Function onPressedQrButton = widget.onPressedQrButton;
    final Function onPressedProductsButton = widget.onPressedProductsButton;

    return Container(
        color: Colors.white,
        child: Column(
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
                    onPressed: (){},
                  )
                ],
              ),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: list.getProducts().length,
                  itemBuilder: (context, index){
                    Product product = list.getProducts()[index];
                    return Card(
                      child: Row(
                        children: [
                          Text(
                            product.getName(),
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          IconButton(
                              icon: Icon(Icons.remove),
                              onPressed:(){
                                setState(() {
                                  list.removeProduct(product);
                                });
                              }
                          )
                        ],
                      ),
                    );
                  }
              )
            ]
        )
    );
  }
}