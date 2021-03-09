import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class Catalog extends Equatable {
  List<String> _categories = [];

  Catalog.fromJson(Map<String, dynamic> parsedJson) {
    for (int index = 0; index < parsedJson["data"].length; index++)
      _categories.add(parsedJson["data"][index].toString());
  }

  @override
  // TODO: implement props
  List<String> get props => _categories;
}
