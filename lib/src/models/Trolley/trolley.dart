import 'package:flutter/cupertino.dart';
import '../models.dart';

class Trolley {

  List<TrolleyItem> trolleyItems;

  Trolley() : trolleyItems = [];

  /*void setTrolleyItemsFromList(List<Product> listProducts){
    List<TrolleyItem> trolleyItems = [];
    for(Product product in listProducts){
      trolleyItems.add(new TrolleyItem(product: product, fromList: true));
    }
    this.trolleyItems = trolleyItems;
  }*/

  bool containsProduct(Product product){
    for(TrolleyItem trolleyItem in trolleyItems)
      if(trolleyItem.product.id == product.id) return true;
    return false;
  }

  List<TrolleyItem> getTrolleyItems (){
    return trolleyItems;
  }

  TrolleyItem getTrolleyItem(String productId){
    for(TrolleyItem trolleyItem in trolleyItems){
      if(trolleyItem.product.id == productId) return trolleyItem;
    }
    return null;
  }

  TrolleyItem getTrolleyItemByIndex(int index){
    return this.trolleyItems[index];
  }

  double getTotalPrice(){
    double totalPrice = 0;
    for(TrolleyItem trolleyItem in trolleyItems){
      totalPrice = totalPrice + trolleyItem.getPrice();
    }
    return totalPrice;
  }

  void addTrolleyItem(TrolleyItem trolleyItem){
    this.trolleyItems.add(trolleyItem);
  }

  void removeTrolleyItem(TrolleyItem trolleyItem){
    this.trolleyItems.remove(trolleyItem);
  }



}