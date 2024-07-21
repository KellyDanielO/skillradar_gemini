import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';
import '../repositories/base_repository.dart';

class GetFeedData {
  BaseRepository repository;
  GetFeedData(this.repository);

  Future<Either<DataState, List<UserEntity>>> getFeedData({
    required String accessToken,
    required String refreshToken,
  }) {
    return repository.getFeedData(
        accessToken: accessToken, refreshToken: refreshToken);
  }
}
