import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_categories_bloc/src/blocs/Catalog/Categories/categories_bloc.dart';
import 'package:market_categories_bloc/src/blocs/blocs.dart';
import 'package:market_categories_bloc/src/models/models.dart';
import 'package:market_categories_bloc/src/ui/views.dart';

class CatalogInfoView extends StatelessWidget {
  final ShoppingList list;

  const CatalogInfoView({@required this.list});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CategoriesBloc>(context).add(LoadCategories());
    BlocProvider.of<ProductsBloc>(context).add(LoadProducts(productsEndpoint: "Ofertas"));
    return Scaffold(
        backgroundColor: Color(0xFFf3f3f3),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Color(0xFF5bb580),
            elevation: 0,
            leading: BackButton()),
        body: Stack(children: [
          Container(
            height: double.infinity,
            color: Colors.transparent,
            margin: const EdgeInsets.only(top: 150, left: 10.0, right: 10.0),
            child: CatalogBodyView(list: list),
          ),
          Container(
              alignment: Alignment(0, 0.0),
              decoration: BoxDecoration(
                  color: Color(0xFF5bb580),
                  border: Border.all(
                    color: Color(0xFF5bb580),
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(25))),
              height: 220,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 80),
                  Text(
                    "CATALOGO",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    list.listName.toUpperCase(),
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: Colors.white70),
                  ),
                  SizedBox(height: 25),
                  CatalogHeaderView()
                ],
              )),
        ]));
  }
}
