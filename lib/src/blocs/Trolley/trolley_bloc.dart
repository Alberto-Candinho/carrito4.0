import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:market_categories_bloc/src/models/models.dart';
import 'package:market_categories_bloc/src/resources/market_repository.dart';
import 'package:meta/meta.dart';

part 'trolley_state.dart';
part 'trolley_event.dart';

class TrolleyBloc extends Bloc<TrolleyEvent, TrolleyState> {

  final MarketRepository marketRepository;
  final Trolley trolley;


  TrolleyBloc({@required this.trolley, @required this.marketRepository}) : super(Unconnected());

  @override
  Stream<TrolleyState> mapEventToState(
      TrolleyEvent event,
      ) async* {
    if (event is LoadListProducts) {
      yield* _mapLoadListProductsToState(event.listProducts);
    }
    else if(event is RemovedProduct){
      yield* _mapRemovedProductToState(event.productId);
    }
    else if(event is NewProduct){
      yield* _mapNewProductToState(event.productId);
    }

  }

  /*Stream<TrolleyState> _mapConnectionEstablishedToState(List<Product> products) async* {
    yield TrolleyLoading(trolley);
    trolley.setTrolleyItemsFromList(products);
    yield CurrentTrolleyContent(trolley);

  }*/
  Stream<TrolleyState> _mapLoadListProductsToState(List<Product> products) async* {
    yield TrolleyLoading(trolley);
    for(Product product in products){
      if(!trolley.containsProduct(product)) trolley.addTrolleyItem(new TrolleyItem(product: product, fromList: true));
    }
    yield CurrentTrolleyContent(trolley);
  }

  Stream<TrolleyState> _mapRemovedProductToState(String productId) async* {
    yield TrolleyLoading(trolley);
    TrolleyItem trolleyItem = trolley.getTrolleyItem(productId);
    if(trolleyItem != null && trolleyItem.quantity > 0){
      trolleyItem.add(-1);
      if(!trolleyItem.isFromList() && trolleyItem.quantity == 0) trolley.removeTrolleyItem(trolleyItem);

    }
    else print("[TROLLEY] Sacouse o producto $productId do carro, pero xa non habia constancia de que ese producto estivese no carro");

    yield CurrentTrolleyContent(trolley);

  }

  Stream<TrolleyState> _mapNewProductToState(String productId) async* {
    yield TrolleyLoading(trolley);
    TrolleyItem trolleyItem = trolley.getTrolleyItem(productId);
    if(trolleyItem != null) trolleyItem.add(1);
    else{
      print("[TROLLEY] Engadiuse un producto que non estaba na lista. Procedese a obter a información do mesmo na web");
      Future<Product> newProduct = marketRepository.getProductInfo(productId);
      Product product = await newProduct;
      trolleyItem = new TrolleyItem(product: product, fromList: false);
      trolleyItem.add(1);
      trolley.addTrolleyItem(trolleyItem);

    }
    yield CurrentTrolleyContent(trolley);


  }

}