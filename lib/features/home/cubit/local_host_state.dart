import 'package:equatable/equatable.dart';

abstract class LocalHostState extends Equatable {
  const LocalHostState();

  @override
  List<Object?> get props => [];
}

class LocalHostInitial extends LocalHostState {}

class LocalHostLoading extends LocalHostState {}

class LocalHostSuccess extends LocalHostState {}

class LocalHostError extends LocalHostState {
  final String message;
  const LocalHostError(this.message);

  @override
  List<Object?> get props => [message];
}
