import 'package:dartz/dartz.dart';

import 'package:skillradar/core/data_state/data_state.dart';
import 'package:skillradar/core/entities/saved_profile_entity.dart';

import 'package:skillradar/core/entities/user_entity.dart';

import '../../../../core/models/saved_profile_model.dart';
import '../../../../core/models/user_model.dart';
import '../../domain/repositories/base_repository.dart';
import '../datasources/remote/remote_datasource.dart';

class BaseRepositoryImpl implements BaseRepository {
  RemoteDataSource remoteDataSource;
  BaseRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<DataState, List<UserEntity>>> getFeedData({
    required String accessToken,
    required String refreshToken,
  }) async {
    Either<DataState, List<UserModel>> response = await remoteDataSource
        .getFeedData(accessToken: accessToken, refreshToken: refreshToken);
    return response.fold(
      (DataState responseDataState) => Left(responseDataState),
      (List<UserModel> users) =>
          Right(users.map((user) => user.toEntity()).toList()),
    );
  }

  @override
  Future<Either<DataState, List<SavedProfileEntity>>> getAllSavedProfile({
    required String accessToken,
    required String refreshToken,
  }) async {
    Either<DataState, List<SavedProfileModel>> response = await remoteDataSource
        .getSavedUser(accessToken: accessToken, refreshToken: refreshToken);
    return response.fold(
      (DataState responseDataState) => Left(responseDataState),
      (List<SavedProfileModel> profiles) => Right(
        profiles.map((profile) => profile.toEntity()).toList(),
      ),
    );
  }
}
