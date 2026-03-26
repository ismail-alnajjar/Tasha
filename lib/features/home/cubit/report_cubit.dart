import 'dart:io';
import 'dart:async';
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
    List<File>? photos,
  }) async {
    emit(ReportLoading());
    try {
      await _repository.sendReport(
        title: title,
        description: description,
        latitude: latitude,
        longitude: longitude,
        photos: photos,
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

  /// Listen to reports to detect new replies from admin in real-time
  StreamSubscription? _reportsSubscription;
  void startListeningToReportReplies(String uid, Function(String, String) onNewReply) {
    _reportsSubscription?.cancel();
    // Assuming reports are also in Firestore or we can poll/listen. 
    // Since we're using a REST API repository for getMyReports, 
    // real-time listening for replies should ideally be via Firebase Messaging 
    // or a recurring refresh logic.
  }

  @override
  Future<void> close() {
    _reportsSubscription?.cancel();
    return super.close();
  }
}
