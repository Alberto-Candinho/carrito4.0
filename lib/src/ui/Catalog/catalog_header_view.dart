import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_categories_bloc/src/blocs/blocs.dart';
import 'package:market_categories_bloc/src/models/models.dart';

class CatalogHeaderView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesBloc, CategoriesState>(
      builder: (context, state) {
        if (state is LoadingCategories) {
          return Text('Loading Categories',
              style: TextStyle(color: Colors.blue)
          );
        }
        else if (state is CategoriesLoaded) {
          List<Category> loadedCategories = state.props.elementAt(0);
          return _CatalogCategoriesView(categoriesList: loadedCategories);
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
class _CatalogCategoriesView extends StatefulWidget{

  final List<Category> categoriesList;

  const _CatalogCategoriesView({this.categoriesList});
  @override
  _CatalogCategoriesViewState createState() => _CatalogCategoriesViewState();

}

class _CatalogCategoriesViewState extends State<_CatalogCategoriesView> {

  Category selectedCategory;

  @override
  Widget build(BuildContext context) {
    List<Category> categoriesList = widget.categoriesList;
    return Column(
      children: [
        Container(
          height: 50,
          width: 350,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categoriesList.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 150,
                  child: GestureDetector(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Text(categoriesList[index].getName())
                    ),
                    onTap: (){
                      setState(() {
                        selectedCategory = categoriesList[index];
                      });
                      String productsEndpoint = selectedCategory.getName();
                      BlocProvider.of<ProductsBloc>(context).add(LoadProducts(productsEndpoint: productsEndpoint));
                    },
                  )
                );
              }
          )
        ),

      ],
    );
  }

}


