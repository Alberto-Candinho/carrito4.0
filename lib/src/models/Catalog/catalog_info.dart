import 'package:equatable/equatable.dart';
import '../models.dart';

class CatalogInfo extends Equatable {
  final List<dynamic> _currentInfo = [];

  CatalogInfo.fromCategoriesJson(Map<String, dynamic> parsedJson) {
    for (int index = 0; index < parsedJson["categories"].length; index++) {
      var categoryJson = Map<String, dynamic>.from(parsedJson["categories"][index]);
      _currentInfo.add(new Category(name: categoryJson["nome"]));
    }
  }

  CatalogInfo.fromProductsJson(Map<String, dynamic> parsedJson) {
    for (int index = 0; index < parsedJson["products"].length; index++) {
      var productJson = Map<String, dynamic>.from(parsedJson["products"][index]);
      _currentInfo.add(new Product(name: productJson["nome"], description: productJson["descripcion"], brand: productJson["marca"], unitPrice: productJson["prezo"]));
    }
  }

  @override
  List<dynamic> get props => [_currentInfo];
}
