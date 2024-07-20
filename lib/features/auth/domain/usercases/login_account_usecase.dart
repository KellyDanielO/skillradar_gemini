import 'package:dartz/dartz.dart';
import 'package:skillradar/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/data_state/data_state.dart';
import '../entities/user_entity.dart';

class LoginAccount {
  AuthRepository repository;
  LoginAccount(this.repository);

  Future<Either<DataState, UserEntity>> loginAccount({
    required String userId,
    required String email,
  }) {
    return repository.loginAccount(userId: userId, email: email);
  }
}
