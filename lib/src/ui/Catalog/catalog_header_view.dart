import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_categories_bloc/src/blocs/blocs.dart';
import 'package:market_categories_bloc/src/models/models.dart';

class CatalogHeaderView extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state) {
        if (state is CatalogLoading) {
          return Text('Loading Categories',
              style: TextStyle(color: Colors.blue)
          );
        }
        else if (state is CatalogLoaded) {
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
                    },
                  )
                );
              }
          )
        ),
        Container(
          height: 50,
          width: 350,

            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: ((selectedCategory == null) ? 0 : selectedCategory.getTags().length),
              itemBuilder: (context, index) {
                return Container(
                    width: 150,
                    child: GestureDetector(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(selectedCategory.getTags()[index])
                      ),
                      onTap: (){
                        String productsEndpoint = selectedCategory.getName() + "/" + selectedCategory.getTags()[index];
                        BlocProvider.of<CatalogBloc>(context).add(LoadCatalogProducts(productsEndpoint: productsEndpoint));
                      },
                    )
                );

              }
          )

        )
      ],
    );
  }

}


