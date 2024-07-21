import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class CreateAccount {
  AuthRepository repository;
  CreateAccount(this.repository);

  Future<Either<DataState, UserEntity>> createAccount({
    required String userId,
    required String accountTye,
    required String email,
    required String name,
  }) {
    return repository.createAccount(
        userId: userId, accountTye: accountTye, email: email, name: name);
  }
}
