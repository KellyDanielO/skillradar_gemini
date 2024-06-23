import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

class BoolNotifier extends StateNotifier<bool> {
  BoolNotifier(): super(false);

  void change(bool value){
    state = value;
  }
  
}

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en'));
  void setLocale(Locale locale) {
    state = locale;
  }
}