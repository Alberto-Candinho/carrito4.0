part of 'trolley_bloc.dart';

@immutable
abstract class TrolleyEvent extends Equatable {
  const TrolleyEvent();
}

class LoadListProducts extends TrolleyEvent{

  final List<Product> listProducts;

  const LoadListProducts({@required this.listProducts});

  @override
  List<Object> get props => [listProducts];
}

class RemovedProduct extends TrolleyEvent{

  final String productId;

  const RemovedProduct({this.productId});

  @override
  List<Object> get props => [productId];

}

class NewProduct extends TrolleyEvent{

  final String productId;

  const NewProduct({@required this.productId});

  @override
  List<Object> get props => [productId];

}
