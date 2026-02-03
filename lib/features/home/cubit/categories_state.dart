import 'package:equatable/equatable.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();
  @override
  List<Object> get props => [];
}

class CategoriesInitial extends CategoriesState {}

class CategoriesLoading extends CategoriesState {}

class CategoriesLoaded extends CategoriesState {
  final List<String> categories;
  const CategoriesLoaded(this.categories);
}

class CategoriesError extends CategoriesState {
  final String message;
  const CategoriesError(this.message);
}
