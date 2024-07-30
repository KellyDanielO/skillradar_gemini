import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/saved_profile_entity.dart';
import '../../../../core/entities/user_entity.dart';

abstract class BaseRepository {
  
  Future<Either<DataState, List<UserEntity>>> getFeedData({
    required String accessToken,
    required String refreshToken,
  });

  Future<Either<DataState, List<SavedProfileEntity>>> getAllSavedProfile({
    required String accessToken,
    required String refreshToken,
  });
}
