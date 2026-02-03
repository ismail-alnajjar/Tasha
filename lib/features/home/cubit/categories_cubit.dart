import 'package:flutter_bloc/flutter_bloc.dart';
import 'categories_state.dart';

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit() : super(CategoriesInitial());

  void loadCategories() async {
    emit(CategoriesLoading());
    await Future.delayed(const Duration(seconds: 1));
    if (isClosed) return;
    emit(
      const CategoriesLoaded([
        'Popular',
        'Museum',
        'Nature',
        'Foodie',
        'History',
        'Shopping',
      ]),
    );
  }
}
