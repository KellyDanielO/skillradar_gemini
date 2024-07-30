import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/saved_profile_entity.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/providers/provider_classes.dart';
import '../../../../core/providers/provider_variables.dart';
import '../../../../core/widgets/error_widgets.dart';
import '../../../../core/widgets/success_widgets.dart';
import '../../data/datasources/remote/remote_datasource.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../domain/usecases/remove_saved_profile_usecase.dart';
import '../../domain/usecases/saved_profile_usecase.dart';

final navigatedUserNotifierProvider =
    StateNotifierProvider<UserStateNotifier, UserEntity?>((ref) {
  return UserStateNotifier();
});

final displayUserNotifierProvider =
    StateNotifierProvider<UserStateNotifier, UserEntity?>((ref) {
  return UserStateNotifier();
});

final remoteDataSourceProvider = Provider<RemoteDatasource>((ref) {
  return RemoteDatasource();
});

final baseRepositoryProvider = Provider<ProfileRepository>((ref) {
  final remoteDataSource = ref.read(remoteDataSourceProvider);
  return ProfileRepositoryImpl(remoteDataSource);
});

final saveProfileProvider = Provider<SavedProfile>((ref) {
  final repository = ref.read(baseRepositoryProvider);
  return SavedProfile(repository);
});

final removeSavedProfileProvider = Provider<RemoveSavedProfile>((ref) {
  final repository = ref.read(baseRepositoryProvider);
  return RemoveSavedProfile(repository);
});

final profileListenerProvider =
    StateNotifierProvider<ProfileRepositoryStateNotifier, UserEntity?>((ref) {
  final saveProfile = ref.read(saveProfileProvider);
  final removeSavedProfile = ref.read(removeSavedProfileProvider);
  return ProfileRepositoryStateNotifier(saveProfile, removeSavedProfile);
});

class ProfileRepositoryStateNotifier extends StateNotifier<UserEntity?> {
  final SavedProfile _savedProfile;
  final RemoveSavedProfile _removeSavedProfile;
  ProfileRepositoryStateNotifier(this._savedProfile, this._removeSavedProfile)
      : super(null);

  Future<void> saveProfile({
    required WidgetRef ref,
    required String accessToken,
    required String refreshToken,
    required String id,
  }) async {
    Either<DataState, SavedProfileEntity> response =
        await _savedProfile.addSavedProfile(
            id: id, accessToken: accessToken, refreshToken: refreshToken);
    return response.fold(
      (DataState responseDataState) {
        if (responseDataState is DataFailureOffline) {
          errorWidget(message: 'you\'re offline');
        }
        if (responseDataState is DataFailure) {
          if (responseDataState.status != 500) {
            if (responseDataState.status == 404) {
              errorWidget(message: 'profile not found');
            }
            errorWidget(message: responseDataState.message);
          } else {
            errorWidget(message: 'unknown error');
          }
        }
      },
      (SavedProfileEntity profile) {
        ref.read(savedUsersNotifierProvider.notifier).addUser(profile);
        successWidget(message: 'saved');
      },
    );
  }

  Future<void> removeProfile({
    required WidgetRef ref,
    required String accessToken,
    required String refreshToken,
    required String id,
    required SavedProfileEntity profile,
  }) async {
    Either<DataState, String> response =
        await _removeSavedProfile.removeSavedProfile(
            id: id, accessToken: accessToken, refreshToken: refreshToken);
    return response.fold(
      (DataState responseDataState) {
        if (responseDataState is DataFailureOffline) {
          errorWidget(message: 'you\'re offline');
        }
        if (responseDataState is DataFailure) {
          if (responseDataState.status != 500) {
            if (responseDataState.status == 404) {
              errorWidget(message: 'profile not found');
            }
            errorWidget(message: responseDataState.message);
          } else {
            errorWidget(message: 'unknown error');
          }
        }
      },
      (String response) {
        ref.read(savedUsersNotifierProvider.notifier).removeUser(profile);
        successWidget(message: 'completed');
      },
    );
  }
}
