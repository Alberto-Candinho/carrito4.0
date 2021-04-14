import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market_categories_bloc/src/resources/market_repository.dart';
import 'package:meta/meta.dart';
import 'package:market_categories_bloc/src/models/models.dart';

part 'categories_event.dart';
part 'categories_state.dart';

class CategoriesBloc extends Bloc<CategoriesEvent, CategoriesState> {

  List<Category> catalogCategories = [];
  final MarketRepository marketRepository;

  CategoriesBloc({@required this.marketRepository}) : super(null);

  @override
  Stream<CategoriesState> mapEventToState(CategoriesEvent event) async* {
    if(event is LoadCategories){
        yield* _mapLoadToState();
    }
  }

  Stream<CategoriesState> _mapLoadToState() async* {
    yield LoadingCategories();
    try{
      final CatalogInfo newInfo = await marketRepository.getCatalogCategories();
      catalogCategories = newInfo.props[0].cast<Category>();
      yield CategoriesLoaded(catalogCategories);
    } catch (e) {
      print("Error: $e");
      yield ErrorLoadingCategories();
    }
  }

}