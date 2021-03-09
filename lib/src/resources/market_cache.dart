import 'dart:async';
import 'package:http/http.dart' as Http;
import 'dart:convert';
import 'package:market_categories_bloc/src/models/models.dart';

class MarketCache {

  final _cache = <String, Http.Response>{};

  Http.Response get(String term) => _cache[term];

  void set(String term, Http.Response result) => _cache[term] = result;

  bool contains(String term) => _cache.containsKey(term);

  void remove(String term) => _cache.remove(term);

}
