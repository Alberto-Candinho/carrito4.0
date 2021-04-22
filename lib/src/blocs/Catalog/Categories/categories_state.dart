part of 'categories_bloc.dart';

@immutable
abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object> get props => [];
}

class LoadingCategories extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {

  final List<Category> catalogCategories;

  const CategoriesLoaded(this.catalogCategories);

  @override
  List<Object> get props => [this.catalogCategories];
}

class ErrorLoadingCategories extends CategoriesState {}
