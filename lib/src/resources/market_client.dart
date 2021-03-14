import 'dart:async';
import 'package:http/http.dart' as Http;
import 'dart:convert';
import 'package:market_categories_bloc/src/models/models.dart';

class MarketClient{

  Future<Http.Response> fetchCategoriesList() async {
    Uri uri = Uri.parse("http://192.168.0.165:8090/subcategories");
    final response = await Http.get(uri);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load post');
    }
  }


}