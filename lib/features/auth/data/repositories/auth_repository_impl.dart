import 'package:dartz/dartz.dart';

import 'package:skillradar/core/data_state/data_state.dart';

import 'package:skillradar/core/entities/user_entity.dart';

import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/remote_data_source.dart';
import '../../../../core/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  RemoteDataSource remoteDataSource;
  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<DataState, UserEntity>> createAccount({
    required String userId,
    required String accountTye,
    required String email,
    required String name,
  }) async {
    Either<DataState, UserModel> response =
        await remoteDataSource.createAccount(
            userId: userId, accountTye: accountTye, email: email, name: name);
    return response.fold(
      (DataState responseDataState) => Left(responseDataState),
      (UserModel userModel) => Right(userModel.toEntity()),
    );
  }

  @override
  Future<Either<DataState, UserEntity>> setUpAccount({
    required String accessToken,
    required String refreshToken,
    required String username,
    required String location,
  }) async {
    Either<DataState, UserModel> response = await remoteDataSource.setUpAccount(
      accessToken: accessToken,
      refreshToken: refreshToken,
      username: username,
      location: location,
    );
    return response.fold(
      (DataState responseDataState) => Left(responseDataState),
      (UserModel userModel) => Right(userModel.toEntity()),
    );
  }

  @override
  Future<Either<DataState, UserEntity>> loginAccount(
      {required String userId, required String email}) async {
    Either<DataState, UserModel> response =
        await remoteDataSource.loginAccount(userId: userId, email: email);
    return response.fold(
      (DataState responseDataState) => Left(responseDataState),
      (UserModel userModel) => Right(userModel.toEntity()),
    );
  }
}
