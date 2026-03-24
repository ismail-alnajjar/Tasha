import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/repositories/report_repository.dart';
import 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepository _repository = ReportRepository();

  ReportCubit() : super(ReportInitial());

  Future<void> sendReport({
    required String title,
    required String description,
    required double latitude,
    required double longitude,
    File? photo,
  }) async {
    emit(ReportLoading());
    try {
      await _repository.sendReport(
        title: title,
        description: description,
        latitude: latitude,
        longitude: longitude,
        photo: photo,
      );
      emit(ReportSuccess());
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  Future<void> getMyReports() async {
    emit(ReportLoading());
    try {
      final reports = await _repository.getMyReports();
      emit(MyReportsLoaded(reports));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }
}
