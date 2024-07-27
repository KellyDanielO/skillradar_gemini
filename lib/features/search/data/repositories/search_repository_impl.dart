import 'package:dartz/dartz.dart';

import 'package:skillradar/core/data_state/data_state.dart';

import 'package:skillradar/core/entities/user_entity.dart';

import '../../../../core/models/user_model.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/remote/remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  RemoteDataSource remoteDataSource;
  SearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<DataState, List<UserEntity>>> skillSearch({
    required String skills,
    required String accessToken,
    required String refreshToken,
  }) async {
    Either<DataState, List<UserModel>> response =
        await remoteDataSource.skillSearch(
            accessToken: accessToken,
            refreshToken: refreshToken,
            skills: skills);
    return response.fold(
      (DataState responseDataState) => Left(responseDataState),
      (List<UserModel> users) =>
          Right(users.map((user) => user.toEntity()).toList()),
    );
  }
}
