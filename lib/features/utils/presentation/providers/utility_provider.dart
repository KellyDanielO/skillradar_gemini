import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/providers/provider_classes.dart';
import '../../../../core/widgets/error_widgets.dart';
import '../../../../core/entities/user_entity.dart';
import '../../data/datasources/remote/remote_datasource.dart';
import '../../data/repositories/utility_repository_impl.dart';
import '../../domain/repositories/utility_repository.dart';
import '../../domain/usecases/edit_profile_usecase.dart';

final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  return RemoteDataSource();
});

final authRepositoryProvider = Provider<UtilityRepository>((ref) {
  final remoteDataSource = ref.read(remoteDataSourceProvider);
  return UtilityRepositoryImpl(remoteDataSource);
});
final editProfileDataProvider = Provider<EditProfile>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return EditProfile(repository);
});
final utilityListenerProvider =
    StateNotifierProvider<UtilityStateNotifier, UserEntity?>((ref) {
  final editProfileData = ref.read(editProfileDataProvider);
  return UtilityStateNotifier(editProfileData);
});
final editProfileLoadingNotifierProvider =
    StateNotifierProvider.autoDispose<BoolNotifier, bool>((ref) {
  return BoolNotifier();
});

class UtilityStateNotifier extends StateNotifier<UserEntity?> {
  final EditProfile _editProfile;
  UtilityStateNotifier(this._editProfile) : super(null);

  Future<UserEntity?> editProfile({
    required String bio,
    required String name,
    required String location,
    File? profileImage,
    required String accessToken,
    required String refreshToken,
  }) async {
    Either<DataState, UserEntity> response = await _editProfile.editProfile(
      bio: bio,
      name: name,
      location: location,
      accessToken: accessToken,
      refreshToken: refreshToken,
      profileImage: profileImage,
    );
    return response.fold(
      (DataState responseDataState) {
        if (responseDataState is DataFailureOffline) {
          errorWidget(message: 'you\'re offline');
        }
        if (responseDataState is DataFailure) {
          if (responseDataState.status != 500) {
            errorWidget(message: responseDataState.message);
          } else {
            print(responseDataState.message);
            print(responseDataState.status);
            errorWidget(message: 'unknown error1');
          }
        }

        return null;
      },
      (UserEntity userEntity) {
        return userEntity;
      },
    );
  }
}
