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

  TrolleyBloc(
      {@required this.trolley,
      @required this.marketRepository,
      @required this.sharedPreferences})
      : super(Unconnected());

  @override
  Stream<TrolleyState> mapEventToState(
    TrolleyEvent event,
  ) async* {
    if (event is LoadList) {
      yield* _mapLoadListToState(event.listProducts, event.listId);
    } else if (event is LoadStoredTrolley) {
      yield* _mapLoadStoredTrolleyToState(event.productIds, event.quantities);
    } else if (event is RemovedProduct) {
      yield* _mapRemovedProductToState(event.productId, event.quantity);
    } else if (event is NewProduct) {
      yield* _mapNewProductToState(event.productId, event.quantity);
    } else if (event is NewProductsInList) {
      yield* _mapNewProductsInListToState(event.newProducts);
    } else if (event is RemovedProductsInList) {
      yield* _mapRemovedProductsInListToState(event.removedProducts);
    }
  }

  Stream<TrolleyState> _mapLoadStoredTrolleyToState(
      List<String> productIds, List<String> quantities) async* {
    yield TrolleyLoading(trolley);
    for (int index = 0; index < productIds.length; index++) {
      String productId = productIds[index];
      double quantity = double.parse(quantities[index]);
      print("Cantidade almacenada para o producto: " + quantity.toString());
      TrolleyItem trolleyItem = trolley.getTrolleyItem(productId);
      if (trolleyItem == null) {
        Future<Product> newProduct = marketRepository.getProductInfo(productId);
        Product product = await newProduct;
        trolleyItem = new TrolleyItem(product: product, fromList: false);
        trolleyItem.add(quantity);
        trolley.addTrolleyItem(trolleyItem);
      } else {
        trolleyItem.add(quantity);
        trolley.addTrolleyItem(trolleyItem);
      }
    }
    _saveTrolleyState();
    yield CurrentTrolleyContent(trolley);
  }

  Stream<TrolleyState> _mapNewProductsInListToState(
      List<Product> newProducts) async* {
    yield TrolleyLoading(trolley);
    List<String> productIds = [];
    for (Product newProduct in newProducts) productIds.add(newProduct.id);
    for (TrolleyItem trolleyItem in trolley.getTrolleyItems()) {
      if (productIds.contains(trolleyItem.product.id))
        trolleyItem.setFromList(true);
    }
    for (Product product in newProducts) {
      if (!trolley.containsProduct(product))
        trolley
            .addTrolleyItem(new TrolleyItem(product: product, fromList: true));
    }
    yield CurrentTrolleyContent(trolley);
  }

  Stream<TrolleyState> _mapRemovedProductsInListToState(
      List<Product> removedProducts) async* {
    yield TrolleyLoading(trolley);
    List<String> productIds = [];
    for (Product removedProduct in removedProducts)
      productIds.add(removedProduct.id);
    for (TrolleyItem trolleyItem in trolley.getTrolleyItems()) {
      if (productIds.contains(trolleyItem.product.id)) {
        (trolleyItem.quantity > 0)
            ? trolleyItem.setFromList(false)
            : trolley.removeTrolleyItem(trolleyItem);
      }
    }
    yield CurrentTrolleyContent(trolley);
  }

  Stream<TrolleyState> _mapLoadListToState(
      List<Product> products, String listId) async* {
    yield TrolleyLoading(trolley);

    for (Product product in products) {
      if (!trolley.containsProduct(product))
        trolley
            .addTrolleyItem(new TrolleyItem(product: product, fromList: true));
      else {
        TrolleyItem trolleyItem = trolley.getTrolleyItem(product.id);
        if (!trolleyItem.isFromList()) trolleyItem.setFromList(true);
      }
    }

    List<String> productIds = [];
    for (Product product in products) productIds.add(product.id);
    for (TrolleyItem trolleyItem in trolley.getTrolleyItems()) {
      if (trolleyItem.isFromList() &&
          !productIds.contains(trolleyItem.product.id)) {
        (trolleyItem.quantity > 0)
            ? trolleyItem.setFromList(false)
            : trolley.removeTrolleyItem(trolleyItem);
      }
    }

    //Saving current list in trolley in shared preferences
    SharedPreferences prefs = await sharedPreferences;
    if (!(prefs.containsKey("listInTrolley") &&
        prefs.getString("listInTrolley") == listId))
      prefs.setString("listInTrolley", listId);
    _saveTrolleyState();
    yield CurrentTrolleyContent(trolley);
  }

  Stream<TrolleyState> _mapRemovedProductToState(
      String productId, double quantity) async* {
    yield TrolleyLoading(trolley);
    TrolleyItem trolleyItem = trolley.getTrolleyItem(productId);
    if (trolleyItem != null && trolleyItem.quantity > 0) {
      if (trolleyItem.product.aGranel())
        trolleyItem.add(quantity);
      else
        trolleyItem.add(-1);
      if (!trolleyItem.isFromList() && trolleyItem.quantity == 0)
        trolley.removeTrolleyItem(trolleyItem);
    } else
      print(
          "[TROLLEY] Sacouse o producto $productId do carro, pero xa non habia constancia de que ese producto estivese no carro");

    _saveTrolleyState();

    yield CurrentTrolleyContent(trolley);
  }

  Stream<TrolleyState> _mapNewProductToState(
      String productId, double quantity) async* {
    yield TrolleyLoading(trolley);
    TrolleyItem trolleyItem = trolley.getTrolleyItem(productId);
    if (trolleyItem != null) {
      if (trolleyItem.product.aGranel())
        trolleyItem.add(quantity);
      else
        trolleyItem.add(1);
    } else {
      print(
          "[TROLLEY] Engadiuse un producto que non estaba na lista. Procedese a obter a información do mesmo na web");
      Future<Product> newProduct = marketRepository.getProductInfo(productId);
      Product product = await newProduct;
      trolleyItem = new TrolleyItem(product: product, fromList: false);
      if (product.aGranel())
        trolleyItem.add(quantity);
      else
        trolleyItem.add(1);
      trolley.addTrolleyItem(trolleyItem);
    }

    _saveTrolleyState();

    yield CurrentTrolleyContent(trolley);
  }

  void _saveTrolleyState() async {
    List<String> currentProducts = [];
    List<String> currentQuantities = [];
    SharedPreferences prefs = await sharedPreferences;
    for (TrolleyItem trolleyItem in trolley.getTrolleyItems()) {
      currentProducts.add(trolleyItem.product.id);
      currentQuantities.add(trolleyItem.quantity.toString());
    }
    prefs.setStringList("products_in_trolley", currentProducts);
    prefs.setStringList("quantities_in_trolley", currentQuantities);
  }
}
