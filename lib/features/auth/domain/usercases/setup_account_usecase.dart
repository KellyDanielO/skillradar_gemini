import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SetUpAccount {
  AuthRepository repository;
  SetUpAccount(this.repository);

  Future<Either<DataState, UserEntity>> setUpAccount({
    required String accessToken,
    required String refreshToken,
    required String username,
    required String location,
  }) {
    return repository.setUpAccount(
        accessToken: accessToken,
        refreshToken: refreshToken,
        username: username,
        location: location);
  }
}
