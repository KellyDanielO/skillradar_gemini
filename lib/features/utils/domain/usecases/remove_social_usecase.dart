import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';
import '../repositories/utility_repository.dart';

class RemoveSocial {
  UtilityRepository repository;
  RemoveSocial(this.repository);

  Future<Either<DataState, UserEntity>> removeSocial({
    required String id,
    required String accessToken,
    required String refreshToken,
  }) {
    return repository.removedSocial(
      id: id,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
