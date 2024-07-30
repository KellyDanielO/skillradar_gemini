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
    String? website,
    String? phoneNumber,
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
  Future<Either<DataState, UserEntity>> removedFeatured({
    required String id,
    required String accessToken,
    required String refreshToken,
  });
  Future<Either<DataState, UserEntity>> removedSocial({
    required String id,
    required String accessToken,
    required String refreshToken,
  });
  Future<Either<DataState, UserEntity>> addSocial({
    required String social,
    required String link,
    required String accessToken,
    required String refreshToken,
  });
  Future<Either<DataState, UserEntity>> editVisibilitySettings({
    required String showPhoneNumber,
    required String showEmail,
    required String showProfile,
    required String accessToken,
    required String refreshToken,
  });
}
