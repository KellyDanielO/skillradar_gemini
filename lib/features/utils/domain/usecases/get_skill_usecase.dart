import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/skill_entity.dart';
import '../repositories/initilize_repository.dart';

class GetAllSkills {
  InitilizeRepository repository;
  GetAllSkills(this.repository);

  Future<Either<DataState, List<SkillEntity>>> getAllSkills() {
    return repository.getAllSkills();
  }
}
