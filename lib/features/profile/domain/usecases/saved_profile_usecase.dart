import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/saved_profile_entity.dart';
import '../repositories/profile_repository.dart';

class SavedProfile {
  ProfileRepository repository;
  SavedProfile(this.repository);

  Future<Either<DataState, SavedProfileEntity>> addSavedProfile({
    required String id,
    required String accessToken,
    required String refreshToken,
  }) {
    return repository.addSavedProfile(
      id: id,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
