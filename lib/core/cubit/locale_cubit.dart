import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  void switchLanguage() {
    emit(state.languageCode == 'en' ? const Locale('ar') : const Locale('en'));
  }

  void setLanguage(String languageCode) {
    emit(Locale(languageCode));
  }
}
