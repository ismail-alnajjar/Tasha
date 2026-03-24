import 'package:equatable/equatable.dart';
import '../data/models/report_model.dart';

abstract class ReportState extends Equatable {
  const ReportState();
  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportSuccess extends ReportState {}

class MyReportsLoaded extends ReportState {
  final List<ReportModel> reports;
  const MyReportsLoaded(this.reports);
  @override
  List<Object?> get props => [reports];
}

class ReportError extends ReportState {
  final String message;
  const ReportError(this.message);
  @override
  List<Object?> get props => [message];
}
