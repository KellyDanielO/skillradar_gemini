import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';
import '../repositories/utility_repository.dart';

class EditProfile {
  UtilityRepository repository;
  EditProfile(this.repository);

  Future<Either<DataState, UserEntity>> editProfile({
    required String bio,
    required String name,
    required String location,
    File? profileImage,
    required String accessToken,
    required String refreshToken,
    String? website,
    String? phoneNumber,
  }) {
    return repository.editProfile(
      bio: bio,
      name: name,
      location: location,
      profileImage: profileImage,
      accessToken: accessToken,
      phoneNumber: phoneNumber,
      website: website,
      refreshToken: refreshToken,
    );
  }
}
