class MarketCache {

  final _cache = <String, Object>{};

  Object get(String term) => _cache[term];

  void set(String term, Object result) => _cache[term] = result;

  bool contains(String term) => _cache.containsKey(term);

  void remove(String term) => _cache.remove(term);

}
