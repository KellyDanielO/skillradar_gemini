import 'package:dartz/dartz.dart';
import 'package:skillradar/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/data_state/data_state.dart';
import '../entities/user_entity.dart';

class CreateAccount {
  AuthRepository repository;
  CreateAccount(this.repository);

  Future<Either<DataState, UserEntity>> createAccount({
    required String userId,
    required String accountTye,
    required String email,
    required String name,
  }) {
    print('use case');
    return repository.createAccount(
        userId: userId, accountTye: accountTye, email: email, name: name);
  }
}
