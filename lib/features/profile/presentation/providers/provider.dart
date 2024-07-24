
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/entities/user_entity.dart';
import '../../../../core/providers/provider_classes.dart';

final navigatedUserNotifierProvider =
    StateNotifierProvider<UserStateNotifier, UserEntity?>((ref) {
  return UserStateNotifier();
});

final displayUserNotifierProvider =
    StateNotifierProvider<UserStateNotifier, UserEntity?>((ref) {
  return UserStateNotifier();
});