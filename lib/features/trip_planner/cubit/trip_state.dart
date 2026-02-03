import 'package:equatable/equatable.dart';

abstract class TripState extends Equatable {
  const TripState();
  @override
  List<Object> get props => [];
}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripGenerated extends TripState {
  final int days;
  const TripGenerated(this.days);
}
