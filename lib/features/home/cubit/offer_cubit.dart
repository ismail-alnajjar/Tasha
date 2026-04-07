import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tashaapp/features/home/cubit/offer_state.dart';
import 'package:tashaapp/features/home/data/repositories/offer_repository.dart';

class OfferCubit extends Cubit<OfferState> {
  final OfferRepository _repository;

  OfferCubit(this._repository) : super(OfferInitial());

  Future<void> fetchOffers() async {
    if (isClosed) return;
    emit(OfferLoading());
    try {
      final offers = await _repository.getOffers();
      if (isClosed) return;
      emit(OfferLoaded(offers));
    } catch (e) {
      if (isClosed) return;
      emit(OfferError(e.toString()));
    }
  }
}
