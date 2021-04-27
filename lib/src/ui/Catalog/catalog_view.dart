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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton()
      ),
      body: ColoredBox(
          color: Colors.yellow,
          child: Column(
              children: [
                Container(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: 125,
                        width: 300,
                        child: Column(
                          children: [
                            Text("\n\n\nCATALOGO",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(list.listName, style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ],
                        )
                      ),
                      CatalogHeaderView()
                    ],
                  )
                ),
                CatalogBodyView(list: list)
              ]
          )
      ),

    );
  }
}