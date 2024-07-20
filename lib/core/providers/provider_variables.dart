import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'provider_classes.dart';

final buttonLoadingNotifierProvider = StateNotifierProvider<BoolNotifier, bool>((ref) {
  return BoolNotifier();
});
final accountCreatingLoadingNotifierProvider = StateNotifierProvider.autoDispose<BoolNotifier, bool>((ref) {
  return BoolNotifier();
});
final accountSetUpLoadingNotifierProvider = StateNotifierProvider.autoDispose<BoolNotifier, bool>((ref) {
  return BoolNotifier();
});

final languageNotifierProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});