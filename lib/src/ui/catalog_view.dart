import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:market_categories_bloc/src/blocs/blocs.dart';
import 'package:market_categories_bloc/src/models/models.dart';

class CatalogView extends StatelessWidget {

  /*final String listName;
  const CatalogView(this.listName);*/

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CatalogBloc>(context).add(LaunchCatalog());
    //final CatalogBloc catalogBloc = BlocProvider.of<CatalogBloc>(context, listen: true);
    final String listName = ModalRoute
        .of(context)
        .settings
        .arguments;
    //catalogBloc.add(LaunchCatalog());
    return Scaffold(
      appBar: AppBar(title: Text(listName)),
      body: ColoredBox(
          color: Colors.yellow,
          child: Column(
              children: [
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      //child: _Catalog(catalogBloc),
                      child: _Catalog(),
                    )
                )
              ]
          )
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.arrow_back_ios_sharp),
      ),*/
    );
  }
}

class _Catalog extends StatelessWidget {

  /*final CatalogBloc catalogBloc;

  _Catalog(this.catalogBloc);*/
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state){
        if(state is CatalogLoading){
          return Center(child: CircularProgressIndicator());
        }
        else if(state is CatalogLoaded){
          Catalog loadedCatalog = state.props.elementAt(0);
          return ListView.builder(
              itemCount: loadedCatalog.props.length,
              itemBuilder: (context, index){
                return ListTile(
                    title: Text(loadedCatalog.props.elementAt(index))
                );
              }
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