
import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';
import '../repositories/utility_repository.dart';

class AddSocial {
  UtilityRepository repository;
  AddSocial(this.repository);

  Future<Either<DataState, UserEntity>> addSocial({
    required String social,
    required String link,
    required String accessToken,
    required String refreshToken,
  }) {
    return repository.addSocial(
      social: social,
      link: link,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
