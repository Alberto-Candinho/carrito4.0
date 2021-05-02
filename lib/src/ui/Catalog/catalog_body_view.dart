import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_categories_bloc/src/blocs/blocs.dart';
import 'package:market_categories_bloc/src/models/models.dart';
import '../views.dart';

class CatalogBodyView extends StatelessWidget {
  final ShoppingList list;

  const CatalogBodyView({@required this.list});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(32),
      child: _CatalogProductsView(list: list),
    ));
  }
}

class _CatalogProductsView extends StatelessWidget {
  final ShoppingList list;

  const _CatalogProductsView({@required this.list});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state) {
        if (state is LoadingProducts) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProductsLoaded) {
          List<Product> loadedProducts = state.props.elementAt(0);
          return Stack(
            children: [
              GridView.count(
                  crossAxisCount: 2,
                  children: List.generate(loadedProducts.length, (index) {
                    return ProductView(
                      product: loadedProducts[index],
                      list: list,
                    );
                  })),
            ],
          );
        } else {
          return Text(
            'Something went wrong!',
            style: TextStyle(color: Colors.red),
          );
        }
      },
    );
  }
}
