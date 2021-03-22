part of 'catalog_bloc.dart';

@immutable
abstract class CatalogEvent extends Equatable {
  const CatalogEvent();
}

class LoadCatalogCategories extends CatalogEvent{

  @override
  List<Object> get props => [];

}

class LoadCatalogProducts extends CatalogEvent{
  final String productsEndpoint;

  const LoadCatalogProducts({this.productsEndpoint});

  @override
  List<Object> get props => [productsEndpoint];

}
/*class LoadCategories extends CatalogEvent{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadTags extends CatalogEvent{
  final String categorie;

  const LoadTags({this.categorie});

  @override
  List<Object> get props => [categorie];

}

class LoadBrands extends CatalogEvent{
  final String categorie;
  final String tag;

  const LoadBrands({this.categorie, this.tag});

  @override
  List<Object> get props => [categorie, tag];

}

class LoadProducts extends CatalogEvent{
  final String categorie;
  final String tag;
  final String brand;

  const LoadProducts({this.categorie, this.tag, this.brand});

  @override
  List<Object> get props => [categorie, tag, brand];
}*/