import 'package:dartz/dartz.dart';

import 'package:skillradar/core/data_state/data_state.dart';

import 'package:skillradar/core/entities/saved_profile_entity.dart';

import '../../../../core/models/saved_profile_model.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/remote/remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  RemoteDatasource remoteDatasource;
  ProfileRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<DataState, SavedProfileEntity>> addSavedProfile({
    required String id,
    required String accessToken,
    required String refreshToken,
  }) async {
    Either<DataState, SavedProfileModel> response =
        await remoteDatasource.saveProfile(
      accessToken: accessToken,
      refreshToken: refreshToken,
      id: id,
    );
    return response.fold(
      (DataState responseDataState) => Left(responseDataState),
      (SavedProfileModel profile) => Right(profile.toEntity()),
    );
  }

  @override
  Future<Either<DataState, String>> removeSavedProfile({
    required String id,
    required String accessToken,
    required String refreshToken,
  }) async {
    Either<DataState, String> response = await remoteDatasource.removeProfile(
      accessToken: accessToken,
      refreshToken: refreshToken,
      id: id,
    );
    return response.fold(
      (DataState responseDataState) => Left(responseDataState),
      (String response) => Right(response),
    );
  }
}
