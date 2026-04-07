import 'package:equatable/equatable.dart';
import 'package:tashaapp/features/home/data/models/local_host_model.dart';

abstract class LocalHostState extends Equatable {
  const LocalHostState();

  @override
  List<Object?> get props => [];
}

class LocalHostInitial extends LocalHostState {}

class LocalHostLoading extends LocalHostState {}

class LocalHostSuccess extends LocalHostState {}

class MyLocalHostsLoaded extends LocalHostState {
  final List<LocalHostModel> models;
  const MyLocalHostsLoaded(this.models);

  @override
  List<Object?> get props => [models];
}

class AllLocalHostsLoaded extends LocalHostState {
  final List<LocalHostModel> hosts;
  const AllLocalHostsLoaded(this.hosts);

  @override
  List<Object?> get props => [hosts];
}

class LocalHostError extends LocalHostState {
  final String message;
  const LocalHostError(this.message);

  @override
  List<Object?> get props => [message];
}
