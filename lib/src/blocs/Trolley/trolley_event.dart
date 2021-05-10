part of 'trolley_bloc.dart';

@immutable
abstract class TrolleyEvent extends Equatable {
  const TrolleyEvent();
}

class LoadList extends TrolleyEvent {
  final List<Product> listProducts;
  final String listId;
  const LoadList({@required this.listProducts, @required this.listId});

  @override
  List<Object> get props => [listProducts, listId];
}

class RemovedProduct extends TrolleyEvent {
  final String productId;
  final double quantity;

  const RemovedProduct({this.productId, this.quantity});

  @override
  List<Object> get props => [productId];
}

class NewProduct extends TrolleyEvent {
  final String productId;
  final double quantity;

  const NewProduct({@required this.productId, @required this.quantity});

  @override
  List<Object> get props => [productId];
}

class NewProductsInList extends TrolleyEvent {
  final List<Product> newProducts;

  const NewProductsInList({@required this.newProducts});

  @override
  List<Object> get props => [newProducts];
}

class RemovedProductsInList extends TrolleyEvent {
  final List<Product> removedProducts;

  const RemovedProductsInList({@required this.removedProducts});

  @override
  List<Object> get props => [removedProducts];
}

class LoadStoredTrolley extends TrolleyEvent {
  final List<String> productIds;
  final List<String> quantities;

  const LoadStoredTrolley(
      {@required this.productIds, @required this.quantities});

  @override
  List<Object> get props => [productIds, quantities];
}

class GetOutOfTrolley extends TrolleyEvent {
  final ShoppingList list;

  const GetOutOfTrolley({@required this.list});

  @override
  List<Object> get props => [list];
}

class NewProductWithError extends TrolleyEvent {
  final String error;
  final String productId;
  final double quantity;

  const NewProductWithError(
      {@required this.productId,
      @required this.quantity,
      @required this.error});

  @override
  List<Object> get props => [productId, quantity, error];
}
