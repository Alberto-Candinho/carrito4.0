part of 'trolley_bloc.dart';

@immutable
abstract class TrolleyEvent extends Equatable {
  const TrolleyEvent();
}

class LoadList extends TrolleyEvent{

  final List<Product> listProducts;
  final String listId;
  const LoadList({@required this.listProducts, @required this.listId});

  @override
  List<Object> get props => [listProducts, listId];
}

class RemovedProduct extends TrolleyEvent{

  final String productId;

  const RemovedProduct({this.productId});

  @override
  List<Object> get props => [productId];

}

class NewProduct extends TrolleyEvent{

  final String productId;
  final int quantity;

  const NewProduct({@required this.productId, @required this.quantity});

  @override
  List<Object> get props => [productId];

}
