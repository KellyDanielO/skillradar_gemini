import 'package:dartz/dartz.dart';

import 'package:skillradar/core/data_state/data_state.dart';

import 'package:skillradar/core/entities/user_entity.dart';

import '../../../../core/models/user_model.dart';
import '../../domain/repositories/initilize_repository.dart';
import '../datasources/remote/remote_datasource.dart';

class InitilizeRepositoryImpl implements InitilizeRepository {
  RemoteDataSource remoteDataSource;
  InitilizeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<DataState, UserEntity>> getUserData({
    required String accessToken,
    required String refreshToken,
  }) async {
    Either<DataState, UserModel> response = await remoteDataSource.getUserData(
        accessToken: accessToken, refreshToken: refreshToken);
    return response.fold(
      (DataState responseDataState) => Left(responseDataState),
      (UserModel userModel) => Right(userModel.toEntity()),
    );
  }
}
