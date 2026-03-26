import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tashaapp/features/home/cubit/notification_cubit.dart';
import 'package:tashaapp/firebase_options.dart';

class FirebaseService {
  // Singleton pattern for FirebaseService
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  /// --- 1. Main Initialization ---
  Future<void> initialize() async {
    // 1. Initialize Firebase App
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 2. Set Background Message Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 3. Request Permissions for Notifications
    await _requestPermissions();

    // 4. Get FCM Token for debugging
    String? token = await FirebaseMessaging.instance.getToken();
    debugPrint('=================================');
    debugPrint('🔑 FCM Token: $token');
    debugPrint('=================================');

    // 5. Initialize Listeners
    _initMessageListeners();
  }

  /// --- 2. Request Notification Permissions ---
  Future<void> _requestPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  /// --- 3. Topic Subscriptions ---
  Future<void> subscribeToUserTopic(String uid) async {
    String topic = 'user_$uid';
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    debugPrint('✅ Subscribed to topic: $topic');
  }

  Future<void> unsubscribeFromUserTopic(String uid) async {
    String topic = 'user_$uid';
    await FirebaseMessaging.instance.unsubscribeFromTopic(topic);
    debugPrint('❌ Unsubscribed from topic: $topic');
  }

  /// --- 4. Message Listeners (Foreground & Background Opened) ---
  void _initMessageListeners() {
    // Terminated State (App opened from notification when closed)
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        debugPrint('App opened from terminated state by notification: ${message.messageId}');
      }
    });

    // Background State (App in background, opened by tapping notification)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('App opened from background state by notification: ${message.messageId}');
    });

    // Foreground State (App is open, handled by setupForegroundListener)
  }

  /// --- 5. Global Background Message Handler ---
  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    
    if (message.notification != null) {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        final firestore = FirebaseFirestore.instance;
        await firestore.collection('notifications').add({
          'userId': uid,
          'title': message.notification?.title ?? 'Notification',
          'body': message.notification?.body ?? '',
          'timestamp': FieldValue.serverTimestamp(),
          'isRead': false,
        });
      }
    }
    
    debugPrint("Handling a background message: ${message.messageId}");
  }

  /// --- 6. Helper for Foreground SnackBar ---
  bool _listenerSetup = false;
  void setupForegroundListener(BuildContext context, GlobalKey<ScaffoldMessengerState> messengerKey) {
    if (_listenerSetup) return;
    _listenerSetup = true;

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("🔔 Foreground Message Received: ${message.messageId}");
      
      if (message.notification != null) {
        final title = message.notification?.title ?? 'New Notification';
        final body = message.notification?.body ?? '';

        // 1. Direct Save to Firestore (Bypassing Cubit context dependencies)
        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser != null) {
          try {
            await FirebaseFirestore.instance.collection('notifications').add({
              'userId': currentUser.uid,
              'title': title,
              'body': body,
              'timestamp': FieldValue.serverTimestamp(),
              'isRead': false,
            });
            debugPrint("✅ Notification saved directly to Firestore.");
          } catch (e) {
            debugPrint("❌ Error saving notification directly: $e");
          }
        }

        // 2. Show SnackBar using GlobalKey
        final state = messengerKey.currentState;
        if (state != null) {
          state.hideCurrentSnackBar();
          state.showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.notifications_active, color: Colors.white),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.notification?.title ?? 'New Alert',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          message.notification?.body ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF134E4A),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height - 160,
                right: 16,
                left: 16,
              ),
              duration: const Duration(seconds: 4),
            ),
          );
        } else {
          debugPrint("❌ ScaffoldMessengerState is NULL. Check GlobalKey assignment.");
        }
      }
    });
  }
}
