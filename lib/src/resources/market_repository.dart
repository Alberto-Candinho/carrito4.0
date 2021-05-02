import 'dart:async';
import 'package:market_categories_bloc/src/models/models.dart';
import 'dart:convert';
import 'market_client.dart';
import 'market_cache.dart';

class MarketRepository {
  final String categoriesEndpoint = "/";
  final String productInfoEndpoint = "/id/";
  final MarketClient marketClient;
  final MarketCache marketCache;

  MarketRepository(this.marketClient, this.marketCache);

  Future<CatalogInfo> getCatalogCategories() async {
    if (marketCache.contains(categoriesEndpoint)) {
      return marketCache.get(categoriesEndpoint);
    } else {
      final result = await marketClient.sendRequest(categoriesEndpoint);
      final catalogInfo =
          CatalogInfo.fromCategoriesJson(json.decode(result.body));
      marketCache.set(categoriesEndpoint, catalogInfo);
      return catalogInfo;
    }
  }

  Future<CatalogInfo> getCatalogProducts(String productsEndpoint) async {
    if (marketCache.contains(categoriesEndpoint + productsEndpoint)) {
      print("EN CACHE");
      return marketCache.get(categoriesEndpoint + productsEndpoint);
    } else {
      final result =
          await marketClient.sendRequest(categoriesEndpoint + productsEndpoint);
      print(json.decode(result.body));
      final catalogInfo =
          CatalogInfo.fromProductsJson(json.decode(result.body));

      for (Product product in catalogInfo.props[0]) {
        print("PRECIO OBTIDO DO PRODUCTO: " + product.getPrice().toString());
      }
      marketCache.set(categoriesEndpoint + productsEndpoint, catalogInfo);
      return catalogInfo;
    }
  }

  Future<Product> getProductInfo(String productId) async {
    if (marketCache.contains(productInfoEndpoint + productId)) {
      return marketCache.get(productInfoEndpoint + productId);
    } else {
      final result =
          await marketClient.sendRequest(productInfoEndpoint + productId);
      final product = Product.fromProductJson(json.decode(result.body));
      marketCache.set(productInfoEndpoint + productId, product);
      return product;
    }
  }
}
