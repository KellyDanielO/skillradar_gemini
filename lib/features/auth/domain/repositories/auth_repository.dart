import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<DataState, UserEntity>> createAccount({
    required String userId,
    required String accountTye,
    required String email,
    required String name,
  });
  Future<Either<DataState, UserEntity>> setUpAccount({
    required String accessToken,
    required String refreshToken,
    required String username,
    required String location,
  });
}
