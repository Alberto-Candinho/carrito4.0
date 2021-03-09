part of 'catalog_bloc.dart';

@immutable
abstract class CatalogEvent extends Equatable {
  const CatalogEvent();
}

class LaunchCatalog extends CatalogEvent{
  @override
  // TODO: implement props
  List<Object> get props => [];

}
