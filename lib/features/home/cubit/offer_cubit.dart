import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tashaapp/features/home/cubit/offer_state.dart';
import 'package:tashaapp/features/home/data/repositories/offer_repository.dart';

class OfferCubit extends Cubit<OfferState> {
  final OfferRepository _repository;

  OfferCubit(this._repository) : super(OfferInitial());

  Future<void> fetchOffers() async {
    emit(OfferLoading());
    try {
      final offers = await _repository.getOffers();
      emit(OfferLoaded(offers));
    } catch (e) {
      emit(OfferError(e.toString()));
    }
  }
}
