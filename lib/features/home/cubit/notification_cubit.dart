import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import '../data/models/app_notification.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamSubscription? _subscription;
  String? _currentUid;

  NotificationCubit() : super(const NotificationState());

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  /// Start listening to user-specific notifications in Firestore
  void startListening(String uid) {
    if (_currentUid == uid && _subscription != null) return;
    
    _subscription?.cancel();
    _currentUid = uid;

    _subscription = _firestore
        .collection('notifications')
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .limit(100) // Keep history manageable
        .snapshots()
        .listen((snapshot) {
      final list = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Correctly map document ID
        return AppNotification.fromMap(data);
      }).toList();
      
      emit(state.copyWith(notifications: list));
    }, onError: (e) {
      print('Firestore Notification Error: $e');
    });
  }

  /// Stop listening (on logout)
  void stopListening() {
    _subscription?.cancel();
    _subscription = null;
    _currentUid = null;
    emit(const NotificationState());
  }

  /// Add new notification (Handled by app locally if arriving from FCM)
  /// Note: The backend should ideally write to Firestore directly
  Future<void> addNotification({required String title, required String body}) async {
    if (_currentUid == null) return;

    await _firestore.collection('notifications').add({
      'userId': _currentUid,
      'title': title,
      'body': body,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

  /// Mark all as read in Firestore
  Future<void> markAllAsRead() async {
    if (_currentUid == null) return;

    final unreadDocs = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: _currentUid)
        .where('isRead', isEqualTo: false)
        .get();

    final batch = _firestore.batch();
    for (var doc in unreadDocs.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }

  /// Clear all notifications for this user in Firestore
  Future<void> clearAll() async {
    if (_currentUid == null) return;

    final allDocs = await _firestore
        .collection('notifications')
        .where('userId', isEqualTo: _currentUid)
        .get();

    final batch = _firestore.batch();
    for (var doc in allDocs.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }
}
