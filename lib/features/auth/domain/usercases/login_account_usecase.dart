import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

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
