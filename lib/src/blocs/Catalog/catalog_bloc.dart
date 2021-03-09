import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:market_categories_bloc/src/resources/market_repository.dart';
import 'package:meta/meta.dart';
import 'package:market_categories_bloc/src/models/models.dart';

part 'catalog_event.dart';
part 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  final MarketRepository marketRepository;
  CatalogBloc({@required this.marketRepository}) : super(null);

  @override
  Stream<CatalogState> mapEventToState(
      CatalogEvent event,
      ) async* {
    if (event is LaunchCatalog) {
      yield* _mapLaunchCatalogToState();
    }
  }

  Stream<CatalogState> _mapLaunchCatalogToState() async* {
    yield CatalogLoading();
    try {
      /*await Future<void>.delayed(const Duration(milliseconds: 500));
      yield CatalogLoaded(Catalog());*/
      final Catalog catalog = await marketRepository.fetchCategories();
      yield CatalogLoaded(catalog);
    } catch (_) {
      yield CatalogError();
    }
  }
}