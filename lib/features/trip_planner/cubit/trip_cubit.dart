import 'package:flutter_bloc/flutter_bloc.dart';
import 'trip_state.dart';

class TripCubit extends Cubit<TripState> {
  TripCubit() : super(TripInitial());

  void generateTrip(int days) async {
    emit(TripLoading());
    await Future.delayed(const Duration(seconds: 2));
    emit(TripGenerated(days));
  }
}
