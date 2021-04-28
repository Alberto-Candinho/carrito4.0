import 'package:flutter/cupertino.dart';
import '../models.dart';

class TrolleyItem {

  final Product product;
  double quantity;
  bool fromList;

  TrolleyItem({@required this.product, @required this.fromList}) : quantity = 0;


  /*void add(int quantity){
    this.quantity = this.quantity + quantity;
  }*/

  void add(double quantity){
    this.quantity = this.quantity + quantity;
    this.quantity = (this.quantity < 0)? 0: this.quantity;

  }

  double getPrice(){
    if(product.aGranel()) return this.quantity/1000 * this.product.unitPrice * (1 - this.product.discount);
    else return this.quantity * this.product.unitPrice * (1 - this.product.discount);
  }

  bool isFromList(){
    return fromList;
  }

  void setFromList(bool fromList){
    this.fromList = fromList;
  }



}