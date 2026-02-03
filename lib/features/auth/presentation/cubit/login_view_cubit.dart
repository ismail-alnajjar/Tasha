import 'package:flutter_bloc/flutter_bloc.dart';

class LoginViewCubit extends Cubit<bool> {
  LoginViewCubit() : super(true); // true = Login, false = Signup

  void setLogin() => emit(true);
  void setSignup() => emit(false);
  void toggle() => emit(!state);
}
