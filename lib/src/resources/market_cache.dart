import 'package:market_categories_bloc/src/models/models.dart';

class MarketCache {

  final _cache = <String, CatalogInfo>{};

  CatalogInfo get(String term) => _cache[term];

  void set(String term, CatalogInfo result) => _cache[term] = result;

  bool contains(String term) => _cache.containsKey(term);

  void remove(String term) => _cache.remove(term);

}
