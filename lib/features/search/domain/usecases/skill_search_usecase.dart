import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';
import '../repositories/search_repository.dart';

class SkillSearch {
  SearchRepository repository;
  SkillSearch(this.repository);

  Future<Either<DataState, List<UserEntity>>> skillSearch({
    required String skills,
    required String accessToken,
    required String refreshToken,
  }) {
    return repository.skillSearch(
        skills: skills, accessToken: accessToken, refreshToken: refreshToken);
  }
}
