import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market_categories_bloc/src/resources/market_repository.dart';
import 'package:meta/meta.dart';
import 'package:market_categories_bloc/src/models/models.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  List<Product> currentSelectedProducts = [];
  final MarketRepository marketRepository;

  ProductsBloc({@required this.marketRepository}) : super(null);

  @override
  Stream<ProductsState> mapEventToState(ProductsEvent event) async* {
    if (event is LoadProducts) {
      yield* _mapLoadToState(event.productsEndpoint);
    }
  }

  Stream<ProductsState> _mapLoadToState(String productsEndpoint) async* {
    yield LoadingProducts();
    try {
      final CatalogInfo newInfo =
          await marketRepository.getCatalogProducts(productsEndpoint);
      currentSelectedProducts = newInfo.props[0].cast<Product>();
      yield ProductsLoaded(currentSelectedProducts);
    } catch (e, stacktrace) {
      print("Error: $e");
      print("Stacktrace: $stacktrace");
      yield ErrorLoadingProducts();
    }
  }
}
