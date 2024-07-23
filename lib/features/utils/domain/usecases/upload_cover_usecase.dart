import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';
import '../repositories/utility_repository.dart';

class UploadCoverPhoto {
  UtilityRepository repository;
  UploadCoverPhoto(this.repository);

  Future<Either<DataState, UserEntity>> uploadCoverPhoto({
    required File coverPhoto,
    required String accessToken,
    required String refreshToken,
  }) {
    return repository.uploadCoverPhoto(coverPhoto: coverPhoto, accessToken: accessToken, refreshToken: refreshToken);
  }
}
