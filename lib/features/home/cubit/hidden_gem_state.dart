import 'package:equatable/equatable.dart';
import '../data/models/hidden_gem_model.dart';

abstract class HiddenGemState extends Equatable {
  const HiddenGemState();

  @override
  List<Object?> get props => [];
}

class HiddenGemInitial extends HiddenGemState {}

class HiddenGemLoading extends HiddenGemState {}

class HiddenGemSuccess extends HiddenGemState {}

class MyHiddenGemsLoaded extends HiddenGemState {
  final List<HiddenGemModel> gems;

  const MyHiddenGemsLoaded(this.gems);

  @override
  List<Object?> get props => [gems];
}

class HiddenGemError extends HiddenGemState {
  final String message;

  const HiddenGemError(this.message);

  @override
  List<Object?> get props => [message];
}
