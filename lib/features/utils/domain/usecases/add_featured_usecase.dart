import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';
import '../repositories/utility_repository.dart';

class AddFeatured {
  UtilityRepository repository;
  AddFeatured(this.repository);

  Future<Either<DataState, UserEntity>> addFeatured({
    required File media,
    required String summary,
    required String accessToken,
    required String refreshToken,
  }) {
    return repository.addFeatured(media: media, summary: summary, accessToken: accessToken, refreshToken: refreshToken);
  }
}
