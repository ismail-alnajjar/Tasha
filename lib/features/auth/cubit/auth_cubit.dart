import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_state.dart';

class AuthPasswordResetSent extends AuthState {}

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Google Sign-In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthCubit() : super(AuthInitial());

  String? _pendingUserType;

  /// ================= Auth Status =================
  void checkAuthStatus() async {
    emit(AuthLoading());
    try {
      final user = _auth.currentUser;
      if (user != null) {
        emit(AuthAuthenticated(_pendingUserType ?? 'tourist'));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// ================= Email Login =================
  void login(String email, String password) async {
    emit(AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      emit(AuthAuthenticated(_pendingUserType ?? 'tourist'));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(const AuthError("No account found with this email"));
      } else if (e.code == 'wrong-password') {
        emit(const AuthError("Incorrect password"));
      } else if (e.code == 'invalid-email') {
        emit(const AuthError("Invalid email address format"));
      } else if (e.code == 'unknown-error') {
        emit(
          const AuthError(
            "Unknown error. Check internet or API Key restrictions in Google Cloud.",
          ),
        );
      } else {
        emit(AuthError("${e.message ?? "Login failed"} (Code: ${e.code})"));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// ================= Email Signup =================
  void signup(String name, String email, String password, String type) async {
    emit(AuthLoading());
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user?.updateDisplayName(name);
      emit(AuthAuthenticated(type));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? "Signup failed"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// ================= Password Reset =================
  void resetPassword(String email) async {
    emit(AuthLoading());
    try {
      await _auth.sendPasswordResetEmail(email: email);
      emit(
        AuthPasswordResetSent(),
      ); // We need to define this state or reuse a success message
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(const AuthError("No account found with this email"));
      } else if (e.code == 'invalid-email') {
        emit(const AuthError("Invalid email address format"));
      } else {
        emit(
          AuthError(
            "${e.message ?? "Failed to send reset email"} (Code: ${e.code})",
          ),
        );
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// ================= Google Sign-In =================
  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        emit(AuthUnauthenticated());
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      await _auth.signInWithCredential(credential);

      emit(AuthAuthenticated(_pendingUserType ?? 'tourist'));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(e.message ?? 'Google Sign-In failed'));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  /// ================= Guest Login =================
  void loginAsGuest() async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));
    emit(const AuthAuthenticated('guest'));
  }

  /// ================= User Type =================
  void selectUserType(String type) {
    _pendingUserType = type;
  }

  String? get pendingUserType => _pendingUserType;

  /// ================= Logout =================
  void logout() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      _pendingUserType = null;
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
