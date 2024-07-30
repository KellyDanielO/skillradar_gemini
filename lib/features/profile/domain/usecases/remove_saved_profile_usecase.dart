import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../repositories/profile_repository.dart';

class RemoveSavedProfile {
  ProfileRepository repository;
  RemoveSavedProfile(this.repository);

  Future<Either<DataState, String>> removeSavedProfile({
    required String id,
    required String accessToken,
    required String refreshToken,
  }) {
    return repository.removeSavedProfile(
      id: id,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
