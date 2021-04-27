import 'package:flutter/cupertino.dart';
import '../models.dart';

class TrolleyItem {

  final Product product;
  int quantity;
  bool fromList;

  TrolleyItem({@required this.product, @required this.fromList}) : quantity = 0;


  void add(int quantity){
    this.quantity = this.quantity + quantity;
  }

  double getPrice(){
    return this.quantity * this.product.unitPrice * (1 - this.product.discount);
  }

  bool isFromList(){
    return fromList;
  }

  void setFromList(bool fromList){
    this.fromList = fromList;
  }



}