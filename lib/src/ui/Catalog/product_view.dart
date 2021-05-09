import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_categories_bloc/src/blocs/blocs.dart';
import 'package:market_categories_bloc/src/models/models.dart';

import 'package:flutter/services.dart';

class ProductView extends StatefulWidget {
  final Product product;
  final ShoppingList list;

  const ProductView({this.product, this.list});
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    print(widget.product.getName());
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      width: 45,
      height: 22,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          color: Colors.white),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              image: DecorationImage(
                image: NetworkImage(widget.product.getImaxe()),
                //"https://cdn.pixabay.com/photo/2016/04/15/08/04/strawberry-1330459_1280.jpg"),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: InkWell(
                  onTap: () {
                    BlocProvider.of<ShoppingListBloc>(context).add(
                        AddProductsToList(
                            list: widget.list,
                            productsToAdd: [widget.product]));
                    HapticFeedback.heavyImpact();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Engadido ${widget.product.name} a lista'),
                    ));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFf1471d),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ),
                  ))),
          Container(
            alignment: Alignment(0, 0),
            color: Color(0xFF5bb580).withOpacity(0.5),
            padding: EdgeInsets.all(0.25),
            width: 81,
            height: 46,
            child: Text(
              widget.product.getName(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white),
            ),
          ),
          Align(
              alignment: Alignment.bottomRight,
              child: Container(
                alignment: Alignment(-0.2, 0),
                color: Color(0xFF5bb580),
                width: 55,
                height: 40,
                child: Text(
                  widget.product.getPrice().toString() + "€",
                  style: TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17),
                ),
              ))
        ],
      ),
    );
  }
}
