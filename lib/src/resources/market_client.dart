import 'dart:async';
import 'package:http/http.dart' as Http;

class MarketClient{

  final String server_direction = "http://192.168.8.106:8090";

  Future<Http.Response> sendRequest(String endpoint) async {
    Uri uri = Uri.parse(server_direction + endpoint);
    final response = await Http.get(uri);
    //print(response.body.toString());
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load post');
    }
  }

  /*Future<Http.Response> fetchTagsForCategorie(String categorie) async {
    Uri uri = Uri.parse("http://192.168.0.30:8090/subcategories/" + categorie);
    final response = await Http.get(uri);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Http.Response> fetchBrandsForTagInCategorie(String tag, String categorie) async {
    Uri uri = Uri.parse("http://192.168.0.30:8090/subcategories/" + categorie + "/" + tag);
    final response = await Http.get(uri);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<Http.Response> fetchProducts(String brand, String tag, String categorie) async {
    Uri uri = Uri.parse("http://192.168.0.30:8090/subcategories/" + categorie + "/" + tag + "/" + brand);
    final response = await Http.get(uri);
    print(response.body.toString());
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load post');
    }
  }*/


}