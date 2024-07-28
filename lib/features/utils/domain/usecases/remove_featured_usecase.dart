
import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';
import '../repositories/utility_repository.dart';

class RemoveFeatured {
  UtilityRepository repository;
  RemoveFeatured(this.repository);

  Future<Either<DataState, UserEntity>> removeFeatured({
    required String id,
    required String accessToken,
    required String refreshToken,
  }) {
    return repository.removedFeatured(
      id: id,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
