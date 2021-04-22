import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_categories_bloc/src/blocs/blocs.dart';
import 'package:market_categories_bloc/src/models/models.dart';
import '../views.dart';

class CatalogBodyView extends StatelessWidget{

  final ShoppingList list;

  const CatalogBodyView({@required this.list});

  @override
  Widget build(BuildContext context) {

    return Container(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: _CatalogProductsView(list: list),
        )
    );
  }
}

class _CatalogProductsView extends StatelessWidget {

  final ShoppingList list;

  const _CatalogProductsView({@required this.list});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductsBloc, ProductsState>(
      builder: (context, state){
        if(state is LoadingProducts){
          return Center(child: CircularProgressIndicator());
        }
        else if(state is ProductsLoaded){
          List<Product> loadedProducts = state.props.elementAt(0);
          return Container(
              height: 400,
              color: Colors.grey,
              child: Stack(
                children: [
                  ListView.builder(
                      itemCount: loadedProducts.length,
                      itemBuilder: (context, index){
                        return ProductView(product: loadedProducts[index]);
                      }
                  ),
                  ElevatedButton(
                      child: Text("Add to list"),
                      onPressed: (){
                        List<Product> productsToAdd = [];
                        for(int index = 0; index < loadedProducts.length; index++){
                          if(loadedProducts[index].isSelected()){
                            loadedProducts[index].setIsSelected(false);
                            productsToAdd.add(loadedProducts[index]);
                          }
                        }
                        BlocProvider.of<ShoppingListsBloc>(context).add(AddProductsToList(list: list, productsToAdd: productsToAdd));
                      }
                  )
                ],
              )
          );

        }
        else {
          return Text(
            'Something went wrong!',
            style: TextStyle(color: Colors.red),
          );
        }
      },
    );

  }
}