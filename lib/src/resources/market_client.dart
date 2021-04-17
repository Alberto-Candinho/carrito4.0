import 'dart:async';
import 'package:http/http.dart' as Http;

class MarketClient{

  final String server_direction = "http://192.168.8.106:8090";

  Future<Http.Response> sendRequest(String endpoint) async {
    Uri uri = Uri.parse(server_direction + endpoint);
    final response = await Http.get(uri);
    if (response.statusCode == 200) {
      return response;
    } else {
      throw Exception('Failed to load post');
    }
  }


}