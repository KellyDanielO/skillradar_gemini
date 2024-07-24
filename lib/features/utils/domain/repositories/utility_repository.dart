import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';

abstract class UtilityRepository {
  Future<Either<DataState, UserEntity>> editProfile({
    required String bio,
    required String name,
    required String location,
    File? profileImage,
    required String accessToken,
    required String refreshToken,
  });

  Future<Either<DataState, UserEntity>> uploadCoverPhoto({
    required File coverPhoto,
    required String accessToken,
    required String refreshToken,
  });
  
  Future<Either<DataState, UserEntity>> addFeatured({
    required File media,
    required String summary,
    required String accessToken,
    required String refreshToken,
  });
}
