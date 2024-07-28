import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/skill_entity.dart';
import '../../../../core/entities/user_entity.dart';
import '../entities/initilize_entity.dart';

abstract class InitilizeRepository {
  Future<Either<DataState, InitilizeEntity>> initialize();
  Future<Either<DataState, UserEntity>> getUserData({
    required String accessToken,
    required String refreshToken,
  });
  Future<Either<DataState, List<SkillEntity>>> getAllSkills();
  Future<Either<DataState, UserEntity>> addSkills({
    required String skills,
    required String accessToken,
    required String refreshToken,
  });
}
