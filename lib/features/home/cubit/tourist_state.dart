import '../data/models/place_model.dart';
import 'package:equatable/equatable.dart';

abstract class TouristState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TouristInitial extends TouristState {}
class TouristLoading extends TouristState {}
class TouristLoaded extends TouristState {
  final List<PlaceModel> places;
  TouristLoaded(this.places);

  @override
  List<Object?> get props => [places];
}
class TouristError extends TouristState {
  final String message;
  TouristError(this.message);

  @override
  List<Object?> get props => [message];
}
