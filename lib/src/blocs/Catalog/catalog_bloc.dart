import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market_categories_bloc/src/resources/market_repository.dart';
import 'package:meta/meta.dart';
import 'package:market_categories_bloc/src/models/models.dart';

part 'catalog_event.dart';
part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {

  List<Category> catalogCategories = [];
  List<Product> catalogCurrentSelectedProducts = [];
  final MarketRepository marketRepository;

  CatalogBloc({@required this.marketRepository}) : super(null);

  @override
  Stream<CatalogState> mapEventToState(CatalogEvent event) async* {
    if(event is LoadCatalogProducts){
      yield* _mapLoadCatalogProductsToState(event.productsEndpoint);
    }
    else if(event is LoadCatalogCategories){
      yield* _mapLoadCatalogCategoriesToState();
    }
  }

  Stream<CatalogState> _mapLoadCatalogProductsToState(String productsEndpoint) async* {
    yield CatalogLoading();
    try {
      final CatalogInfo newInfo = await marketRepository.getCatalogProducts(productsEndpoint);
      catalogCurrentSelectedProducts = newInfo.props[0].cast<Product>();
      yield CatalogLoaded(catalogCategories, catalogCurrentSelectedProducts);
    } catch (e) {
      print("Error: $e");
      yield CatalogError();
    }
  }

  Stream<CatalogState> _mapLoadCatalogCategoriesToState() async* {
    yield CatalogLoading();
    try{
      final CatalogInfo newInfo = await marketRepository.getCatalogCategories();
      catalogCategories = newInfo.props[0].cast<Category>();
      yield CatalogLoaded(catalogCategories, catalogCurrentSelectedProducts);
    } catch (e) {
      print("Error: $e");
      yield CatalogError();
    }
  }


  /*@override
  Stream<CatalogState> mapEventToState(
      CatalogEvent event,
      ) async* {
    if (event is LoadCategories) {
      yield* _mapLoadCategoriesToState();
    }
    else if(event is LoadTags){
      yield* _mapLoadTagsToState();
    }
    else if(event is LoadBrands){
      yield* _mapLoadBrandsToState();
    }
    else if(event is LoadProducts){
      yield* _mapLoadProductsToState();
    }
  }

  Stream<CatalogState> _mapLoadCategoriesToState() async* {
    yield CatalogLoading();
    try {
      //final Catalog catalog = await marketRepository.fetchCategories();
      final Catalog catalog = await marketRepository.getCatalogData("subcategories");
      yield CatalogLoaded(catalog);
    } catch (_) {
      yield CatalogError();
    }
  }

  Stream<CatalogState> _mapLoadTagsToState(String subcategorie) async* {
    yield CatalogLoading();
    try {
      final Catalog catalog = await marketRepository.getCatalogData("subcategories/" + subcategorie);
      yield CatalogLoaded(catalog);
    } catch (_) {
      yield CatalogError();
    }
  }

  Stream<CatalogState> _mapLoadBrandsToState() async* {
    yield CatalogLoading();
    try {
      final Catalog catalog = await marketRepository.fetchCategories();
      yield CatalogLoaded(catalog);
    } catch (_) {
      yield CatalogError();
    }
  }

  Stream<CatalogState> _mapLoadProductsToState() async* {
    yield CatalogLoading();
    try {
      final Catalog catalog = await marketRepository.fetchCategories();
      yield CatalogLoaded(catalog);
    } catch (_) {
      yield CatalogError();
    }
  }*/
}