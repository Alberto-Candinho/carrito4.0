import 'package:equatable/equatable.dart';
import '../models.dart';

class CatalogInfo extends Equatable {
  final List<dynamic> _currentInfo = [];

  CatalogInfo.fromCategoriesJson(Map<String, dynamic> parsedJson) {
    for (int index = 0; index < parsedJson["categories"].length; index++) {
      var categoryJson = Map<String, dynamic>.from(parsedJson["categories"][index]);
      List<String> received_tags = [];
      for(int tag_index = 0; tag_index < categoryJson["tags"].length; tag_index++){
        received_tags.add(categoryJson["tags"][tag_index].toString());
      }
      _currentInfo.add(new Category(
          name: categoryJson["name"],
          tags: received_tags
      ));
    }
  }

  CatalogInfo.fromProductsJson(Map<String, dynamic> parsedJson) {
    for (int index = 0; index < parsedJson["products"].length; index++) {
      var productJson = Map<String, dynamic>.from(parsedJson["products"][index]);
      _currentInfo.add(new Product(id: productJson["prod_id"], name: productJson["prod_name_long"], unitPrice: productJson["prod_unit_price"]));
    }
  }

  @override
  List<dynamic> get props => [_currentInfo];
}
