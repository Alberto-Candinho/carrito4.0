part of 'categories_bloc.dart';

@immutable
abstract class CategoriesEvent extends Equatable {
  const CategoriesEvent();
}

class LoadCategories extends CategoriesEvent{

  @override
  List<Object> get props => [];

}