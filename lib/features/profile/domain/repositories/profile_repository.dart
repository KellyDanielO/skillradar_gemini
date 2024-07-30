import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/saved_profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<DataState, SavedProfileEntity>> addSavedProfile({
    required String id,
    required String accessToken,
    required String refreshToken,
  });
  
  Future<Either<DataState, String>> removeSavedProfile({
    required String id,
    required String accessToken,
    required String refreshToken,
  });
}
