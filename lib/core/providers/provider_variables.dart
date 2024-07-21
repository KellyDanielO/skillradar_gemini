import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/skill_entity.dart';
import '../entities/user_entity.dart';
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
final addingSkillsLoadingNotifierProvider = StateNotifierProvider.autoDispose<BoolNotifier, bool>((ref) {
  return BoolNotifier();
});

final languageNotifierProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

final gobalUserNotifierProvider =
    StateNotifierProvider<UserStateNotifier, UserEntity?>((ref) {
  return UserStateNotifier();
});
final gobalSkillsNotifierProvider =
    StateNotifierProvider<SkillsStateNotifier, List<SkillEntity>>((ref) {
  return SkillsStateNotifier();
});