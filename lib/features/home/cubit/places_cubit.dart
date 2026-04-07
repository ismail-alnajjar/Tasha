import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tashaapp/features/home/cubit/places_state.dart';
import 'package:tashaapp/features/home/data/repositories/place_repository.dart';

class PlacesCubit extends Cubit<PlacesState> {
  final PlaceRepository _repository = PlaceRepository();

  PlacesCubit() : super(PlacesInitial());

  Future<void> fetchPlacesByCategory(String category) async {
    emit(PlacesLoading());
    try {
      final places = await _repository.getPlacesByCategory(category);
      if (isClosed) return;
      emit(PlacesLoaded(places));
    } catch (e) {
      if (isClosed) return;
      emit(PlacesError(e.toString()));
    }
  }
}
