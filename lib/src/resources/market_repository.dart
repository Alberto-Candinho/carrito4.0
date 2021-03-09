import 'dart:async';
import 'package:market_categories_bloc/src/models/Catalog/catalog.dart';
import 'dart:convert';
import 'market_client.dart';
import 'market_cache.dart';

class MarketRepository {
  final MarketClient market_client;
  final MarketCache market_cache;

  MarketRepository(this.market_client, this.market_cache);

  Future<Catalog> fetchCategories() async {
    if (market_cache.contains("subcategories")) {
      return Catalog.fromJson(json.decode(market_cache.get("subcategories").body));
    } else {
      final result = await market_client.fetchCategoriesList();
      market_cache.set("subcategories", result);
      return Catalog.fromJson(json.decode(result.body));
    }
  }




}