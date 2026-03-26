import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/local_host_repository.dart';
import 'local_host_state.dart';

class LocalHostCubit extends Cubit<LocalHostState> {
  final LocalHostRepository _repository = LocalHostRepository();

  LocalHostCubit() : super(LocalHostInitial());

  Future<void> submitOffer({
    required String title,
    required String description,
    required String phone,
    required String city,
    required String activities,
  }) async {
    emit(LocalHostLoading());
    try {
      await _repository.createLocalHost(
        title: title,
        description: description,
        citizenPhone: phone,
        city: city,
        activities: activities,
      );
      emit(LocalHostSuccess());
    } catch (e) {
      emit(LocalHostError(e.toString()));
    }
  }
}
