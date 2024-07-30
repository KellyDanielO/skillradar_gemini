import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';
import '../repositories/utility_repository.dart';

class EditVisibilitySettings {
  UtilityRepository repository;
  EditVisibilitySettings(this.repository);

  Future<Either<DataState, UserEntity>> editVisibilitySettings({
    required String showPhoneNumber,
    required String showEmail,
    required String showProfile,
    required String accessToken,
    required String refreshToken,
  }) {
    return repository.editVisibilitySettings(
      showPhoneNumber: showPhoneNumber,
      showEmail: showEmail,
      showProfile: showProfile,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
