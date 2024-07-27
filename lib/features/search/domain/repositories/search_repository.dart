import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';

abstract class SearchRepository{

  Future<Either<DataState, List<UserEntity>>> skillSearch({
    required String skills,
    required String accessToken,
    required String refreshToken,
  });
}