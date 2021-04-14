part of 'products_bloc.dart';

@immutable
abstract class ProductsEvent extends Equatable {
  const ProductsEvent();
}

class LoadProducts extends ProductsEvent{
  final String productsEndpoint;

  const LoadProducts({this.productsEndpoint});

  @override
  List<Object> get props => [productsEndpoint];

}
