part of 'catalog_bloc.dart';

@immutable
abstract class CatalogState extends Equatable {
  const CatalogState();

  @override
  List<Object> get props => [];
}

class CatalogLoading extends CatalogState {}

class CatalogLoaded extends CatalogState {

  final List<Product> currentSelectedProducts;
  final List<Category> catalogCategories;

  const CatalogLoaded(this.catalogCategories, this.currentSelectedProducts);

  @override
  List<Object> get props => [this.catalogCategories, this.currentSelectedProducts];
}

class CatalogError extends CatalogState {}
