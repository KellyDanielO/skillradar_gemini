import 'package:dartz/dartz.dart';
import 'package:skillradar/features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/data_state/data_state.dart';
import '../entities/user_entity.dart';

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
