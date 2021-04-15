import 'package:flutter/material.dart';
import 'package:market_categories_bloc/src/models/models.dart';
import 'ShoppingListForms/shopping_list_summary.dart';
import 'ShoppingListForms/shopping_list_with_products.dart';
import 'ShoppingListForms/shopping_list_with_QR.dart';

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
  bool _showProducts = false;

  void _switchQR() {
    setState(() {
      if(_showQR) _showQR = false;
      else{
        _showQR = true;
        _showProducts = false;
      }
    });
  }

  void _switchProducts() {
    setState(() {
      if(_showProducts) _showProducts = false;
      else{
        _showProducts = true;
        _showQR = false;
      }
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
    Function onPressedProductsButton = (){
      _switchProducts();
    };


    if(_showQR) {
      return ShoppingListWithQR(list: list, onPressedAddButton: onPressedAddButton, onPressedRemoveButton: onPressedRemoveButton,
        onPressedQrButton: onPressedQRButton, onPressedProductsButton: onPressedProductsButton);
    }
    else if(_showProducts){
      return ShoppingListWithProducts(list: list, onPressedAddButton: onPressedAddButton, onPressedRemoveButton: onPressedRemoveButton,
          onPressedQrButton: onPressedQRButton, onPressedProductsButton: onPressedProductsButton);
    }
    else{
      return ShoppingListSummary(list: list, onPressedAddButton: onPressedAddButton, onPressedRemoveButton: onPressedRemoveButton,
        onPressedQrButton: onPressedQRButton, onPressedProductsButton: onPressedProductsButton);
    }
  }


}

