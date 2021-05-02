import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:market_categories_bloc/src/models/models.dart';
import 'package:market_categories_bloc/src/resources/market_repository.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'trolley_state.dart';
part 'trolley_event.dart';

class TrolleyBloc extends Bloc<TrolleyEvent, TrolleyState> {

  final MarketRepository marketRepository;
  final Future<SharedPreferences> sharedPreferences;
  final Trolley trolley;


  TrolleyBloc({@required this.trolley, @required this.marketRepository, @required this.sharedPreferences}) : super(Unconnected());

  @override
  Stream<TrolleyState> mapEventToState(
      TrolleyEvent event,
      ) async* {
    if (event is LoadList) {
      yield* _mapLoadListToState(event.listProducts, event.listId);
    }
    else if(event is RemovedProduct){
      yield* _mapRemovedProductToState(event.productId);
    }
    else if(event is NewProduct){
      yield* _mapNewProductToState(event.productId, event.quantity);
    }

  }

  Stream<TrolleyState> _mapLoadListToState(List<Product> products, String listId) async* {
    yield TrolleyLoading(trolley);
    //if(!list.isInTrolley()) list.setInTrolley(true);
    for(Product product in products){
      if(!trolley.containsProduct(product)) trolley.addTrolleyItem(new TrolleyItem(product: product, fromList: true));
      else{
        TrolleyItem trolleyItem = trolley.getTrolleyItem(product.id);
        if(!trolleyItem.isFromList()) trolleyItem.setFromList(true);
      }
    }

    //Saving current list in trolley in shared preferences
    SharedPreferences prefs = await sharedPreferences;
    if(!(prefs.containsKey("listInTrolley") && prefs.getString("listInTrolley") == listId)) prefs.setString("listInTrolley", listId);
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

    _saveTrolleyState();

    yield CurrentTrolleyContent(trolley);


  }

  Stream<TrolleyState> _mapNewProductToState(String productId, int quantity) async* {
    yield TrolleyLoading(trolley);
    TrolleyItem trolleyItem = trolley.getTrolleyItem(productId);
    if(trolleyItem != null) trolleyItem.add(1);
    else{
      print("[TROLLEY] Engadiuse un producto que non estaba na lista. Procedese a obter a información do mesmo na web");
      Future<Product> newProduct = marketRepository.getProductInfo(productId);
      Product product = await newProduct;
      trolleyItem = new TrolleyItem(product: product, fromList: false);
      trolleyItem.add(quantity);
      trolley.addTrolleyItem(trolleyItem);

    }

    _saveTrolleyState();

    yield CurrentTrolleyContent(trolley);


  }

  void _saveTrolleyState() async{
    List<String> currentProducts = [];
    List<String> currentQuantities = [];
    SharedPreferences prefs = await sharedPreferences;
    for(TrolleyItem trolleyItem in trolley.getTrolleyItems()) {
      currentProducts.add(trolleyItem.product.id);
      currentQuantities.add(trolleyItem.quantity.toString());
    }
    prefs.setStringList("products_in_trolley", currentProducts);
    prefs.setStringList("quantities_in_trolley", currentQuantities);

  }

}