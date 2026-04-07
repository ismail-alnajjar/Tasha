import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tashaapp/features/home/cubit/tourist_state.dart';
import 'package:tashaapp/features/home/data/repositories/tourist_repository.dart';

class TouristCubit extends Cubit<TouristState> {
  final TouristRepository _repository = TouristRepository();

  TouristCubit() : super(TouristInitial());

  Future<void> fetchTouristPlaces(String category) async {
    emit(TouristLoading());
    try {
      final places = await _repository.getTouristPlaces(category);
      if (isClosed) return;
      emit(TouristLoaded(places));
    } catch (e) {
      if (isClosed) return;
      emit(TouristError(e.toString()));
    }
  }
}
