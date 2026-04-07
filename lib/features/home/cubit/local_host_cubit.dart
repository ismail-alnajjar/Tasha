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
    required double latitude,
    required double longitude,
  }) async {
    emit(LocalHostLoading());
    try {
      await _repository.createLocalHost(
        title: title,
        description: description,
        citizenPhone: phone,
        city: city,
        activities: activities,
        latitude: latitude,
        longitude: longitude,
      );
      emit(LocalHostSuccess());
    } catch (e) {
      emit(LocalHostError(e.toString()));
    }
  }

  Future<void> getMyOffers() async {
    emit(LocalHostLoading());
    try {
      final models = await _repository.getMyLocalHosts();
      emit(MyLocalHostsLoaded(models));
    } catch (e) {
      emit(LocalHostError(e.toString()));
    }
  }

  Future<void> getAllHosts() async {
    emit(LocalHostLoading());
    try {
      final hosts = await _repository.getAllLocalHosts();
      emit(AllLocalHostsLoaded(hosts));
    } catch (e) {
      emit(LocalHostError(e.toString()));
    }
  }
}
