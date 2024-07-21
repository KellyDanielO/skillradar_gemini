import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';
import '../repositories/initilize_repository.dart';

class AddSkills {
  InitilizeRepository repository;
  AddSkills(this.repository);

  Future<Either<DataState, UserEntity>> addSkills({
    required String skills,
    required String accessToken,
    required String refreshToken,
  }) {
    return repository.addSkills(skills: skills, accessToken: accessToken, refreshToken: refreshToken);
  }
}
