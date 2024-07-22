import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:skillradar/core/data_state/data_state.dart';

import 'package:skillradar/core/entities/user_entity.dart';

import '../../../../core/models/user_model.dart';
import '../../domain/repositories/utility_repository.dart';
import '../datasources/remote/remote_datasource.dart';

class UtilityRepositoryImpl implements UtilityRepository {
  RemoteDataSource remoteDataSource;
  UtilityRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<DataState, UserEntity>> editProfile({
    required String bio,
    required String name,
    required String location,
    File? profileImage,
    required String accessToken,
    required String refreshToken,
  }) async {
    Either<DataState, UserModel> response = await remoteDataSource.editProfile(
      bio: bio,
      name: name,
      location: location,
      accessToken: accessToken,
      profileImage: profileImage,
      refreshToken: refreshToken,
    );
    return response.fold(
      (DataState responseDataState) => Left(responseDataState),
      (UserModel userModel) => Right(userModel.toEntity()),
    );
  }
}
