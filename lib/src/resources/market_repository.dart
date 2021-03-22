import 'dart:async';
import 'package:market_categories_bloc/src/models/Catalog/catalog_info.dart';
import 'dart:convert';
import 'market_client.dart';
import 'market_cache.dart';

class MarketRepository {
  final String categoriesEndpoint = "/";
  final MarketClient marketClient;
  final MarketCache marketCache;

  MarketRepository(this.marketClient, this.marketCache);

  Future<CatalogInfo> getCatalogCategories() async {
    if (marketCache.contains(categoriesEndpoint)) {
      return marketCache.get(categoriesEndpoint);
    }
    else {
      final result = await marketClient.sendRequest(categoriesEndpoint);
      final catalogInfo = CatalogInfo.fromCategoriesJson(json.decode(result.body));
      marketCache.set(categoriesEndpoint, catalogInfo);
      return catalogInfo;
    }
  }

  Future<CatalogInfo> getCatalogProducts(String productsEndpoint) async {
    if (marketCache.contains(categoriesEndpoint + productsEndpoint)) {
      return marketCache.get(productsEndpoint);
    }
    else {
      final result = await marketClient.sendRequest(categoriesEndpoint + productsEndpoint);
      final catalogInfo = CatalogInfo.fromProductsJson(json.decode(result.body));
      marketCache.set(categoriesEndpoint + productsEndpoint, catalogInfo);
      return catalogInfo;
    }
  }


}