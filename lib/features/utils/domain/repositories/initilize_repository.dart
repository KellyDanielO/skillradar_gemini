import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';

abstract class InitilizeRepository {
  Future<Either<DataState, UserEntity>> getUserData({
    required String accessToken,
    required String refreshToken,
  });
}
