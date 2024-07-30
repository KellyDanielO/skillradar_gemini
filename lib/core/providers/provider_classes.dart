import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../entities/saved_profile_entity.dart';
import '../entities/skill_entity.dart';
import '../entities/social_entity.dart';
import '../entities/user_entity.dart';

class BoolNotifier extends StateNotifier<bool> {
  BoolNotifier() : super(false);

  void change(bool value) {
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

class UsersStateNotifier extends StateNotifier<List<UserEntity>> {
  UsersStateNotifier() : super([]);
  void setUsers(List<UserEntity> user) {
    state = user;
  }

  void addUser(UserEntity user) {
    state = [user, ...state];
  }

  void removeUser(UserEntity user) {
    state = state.where((s) => s != user).toList();
  }

  void clearUsers() {
    state = [];
  }
}

class SavedUsersStateNotifier extends StateNotifier<List<SavedProfileEntity>> {
  SavedUsersStateNotifier() : super([]);
  void setUsers(List<SavedProfileEntity> user) {
    state = user;
  }

  void addUser(SavedProfileEntity user) {
    state = [user, ...state];
  }

  void removeUser(SavedProfileEntity user) {
    state = state.where((s) => s != user).toList();
  }

  void clearUsers() {
    state = [];
  }
}

class SkillsStateNotifier extends StateNotifier<List<SkillEntity>> {
  SkillsStateNotifier() : super([]);
  void setSkill(List<SkillEntity> skills) {
    state = skills;
  }
}

class SocialsStateNotifier extends StateNotifier<List<SocialEntity>> {
  SocialsStateNotifier() : super([]);
  void setSkill(List<SocialEntity> skills) {
    state = skills;
  }
}

class WidgetRefStateNotifier extends StateNotifier<WidgetRef?> {
  WidgetRefStateNotifier() : super(null);
  void setState(WidgetRef ref) {
    state = ref;
  }
}
