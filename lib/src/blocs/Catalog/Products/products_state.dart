part of 'products_bloc.dart';

@immutable
abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class LoadingProducts extends ProductsState {}

class ProductsLoaded extends ProductsState {

  final List<Product> currentSelectedProducts;

  const ProductsLoaded(this.currentSelectedProducts);

  @override
  List<Object> get props => [this.currentSelectedProducts];
}

class ErrorLoadingProducts extends ProductsState {}
