import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../entities/skill_entity.dart';
import '../entities/user_entity.dart';

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

class UserStateNotifier extends StateNotifier<UserEntity?> {
  UserStateNotifier() : super(null);
  void setUser(UserEntity? user) {
    state = user;
  }
}
class SkillsStateNotifier extends StateNotifier<List<SkillEntity>> {
  SkillsStateNotifier() : super([]);
  void setSkill(List<SkillEntity> skills) {
    state = skills;
  }
}