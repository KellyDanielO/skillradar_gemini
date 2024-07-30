import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/saved_profile_entity.dart';
import '../repositories/base_repository.dart';

class GetSavedProfile {
  BaseRepository repository;
  GetSavedProfile(this.repository);

  Future<Either<DataState, List<SavedProfileEntity>>> getSavedProfile({
    required String accessToken,
    required String refreshToken,
  }) {
    return repository.getAllSavedProfile(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
