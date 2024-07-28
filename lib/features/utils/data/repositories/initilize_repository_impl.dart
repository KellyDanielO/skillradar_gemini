import 'package:dartz/dartz.dart';

import 'package:skillradar/core/data_state/data_state.dart';
import 'package:skillradar/core/entities/skill_entity.dart';

import 'package:skillradar/core/entities/user_entity.dart';
import 'package:skillradar/features/utils/domain/entities/initilize_entity.dart';

import '../../../../core/models/skill_model.dart';
import '../../../../core/models/user_model.dart';
import '../../domain/repositories/initilize_repository.dart';
import '../datasources/remote/remote_datasource.dart';
import '../models/initialize_model.dart';

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

  @override
  Future<Either<DataState, List<SkillEntity>>> getAllSkills() async {
    Either<DataState, List<SkillModel>> response =
        await remoteDataSource.getAllSkills();
    return response.fold(
      (DataState responseDataState) => Left(responseDataState),
      (List<SkillModel> skills) =>
          Right(skills.map((skill) => skill.toEntity()).toList()),
    );
  }

  @override
  Future<Either<DataState, UserEntity>> addSkills({
    required String skills,
    required String accessToken,
    required String refreshToken,
  }) async {
    Either<DataState, UserModel> response = await remoteDataSource.addSkills(
        skills: skills, accessToken: accessToken);
    return response.fold(
      (DataState responseDataState) => Left(responseDataState),
      (UserModel userModel) => Right(userModel.toEntity()),
    );
  }

  @override
  Future<Either<DataState, InitilizeEntity>> initialize() async {
    Either<DataState, InitilizeModel> response =
        await remoteDataSource.initialize();
    return response.fold(
      (DataState responseDataState) => Left(responseDataState),
      (InitilizeModel data) => Right(data.toEntity()),
    );
  }
}
