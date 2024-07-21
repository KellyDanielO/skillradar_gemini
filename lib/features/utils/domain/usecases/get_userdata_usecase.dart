import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';
import '../repositories/initilize_repository.dart';

class GetUserData {
  InitilizeRepository repository;
  GetUserData(this.repository);

  Future<Either<DataState, UserEntity>> getUserData({
    required String accessToken,
    required String refreshToken,
  }) {
    return repository.getUserData(accessToken: accessToken, refreshToken: refreshToken);
  }
}
