import 'package:flutter/material.dart';
import 'package:market_categories_bloc/src/models/models.dart';

class ProductView extends StatefulWidget{

  final Product product;

  const ProductView({this.product});
  @override
  _ProductState createState() => _ProductState();

}

class _ProductState extends State<ProductView> {

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ((widget.product.isSelected() ? Colors.blue : Colors.white)),
      child: GestureDetector(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(widget.product.getName()),
        ),
        onTap: (){
          setState(() {
            widget.product.setIsSelected(!widget.product.isSelected());
          });
        },
      ),
    );
  }

}
