import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/hidden_gem_repository.dart';
import 'hidden_gem_state.dart';

class HiddenGemCubit extends Cubit<HiddenGemState> {
  final HiddenGemRepository _repository = HiddenGemRepository();

  HiddenGemCubit() : super(HiddenGemInitial());

  Future<void> sendHiddenGem({
    required String name,
    required String description,
    required double latitude,
    required double longitude,
    List<File>? photos,
  }) async {
    emit(HiddenGemLoading());
    try {
      await _repository.sendHiddenGem(
        name: name,
        description: description,
        latitude: latitude,
        longitude: longitude,
        photos: photos,
      );
      emit(HiddenGemSuccess());
    } catch (e) {
      emit(HiddenGemError(e.toString()));
    }
  }

  Future<void> getMyHiddenGems() async {
    emit(HiddenGemLoading());
    try {
      final gems = await _repository.getMyHiddenGems();
      emit(MyHiddenGemsLoaded(gems));
    } catch (e) {
      emit(HiddenGemError(e.toString()));
    }
  }
}
