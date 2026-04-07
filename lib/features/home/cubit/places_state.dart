import '../data/models/place_model.dart';

abstract class PlacesState {}

class PlacesInitial extends PlacesState {}
class PlacesLoading extends PlacesState {}
class PlacesLoaded extends PlacesState {
  final List<PlaceModel> places;
  PlacesLoaded(this.places);
}
class PlacesError extends PlacesState {
  final String message;
  PlacesError(this.message);
}
