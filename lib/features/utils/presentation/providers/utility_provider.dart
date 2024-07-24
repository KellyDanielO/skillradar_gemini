import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/providers/provider_classes.dart';
import '../../../../core/widgets/error_widgets.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/widgets/success_widgets.dart';
import '../../data/datasources/remote/remote_datasource.dart';
import '../../data/repositories/utility_repository_impl.dart';
import '../../domain/repositories/utility_repository.dart';
import '../../domain/usecases/add_featured_usecase.dart';
import '../../domain/usecases/edit_profile_usecase.dart';
import '../../domain/usecases/remove_deatured_usecase.dart';
import '../../domain/usecases/upload_cover_usecase.dart';

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

final uploadCoverPhotoProvider = Provider<UploadCoverPhoto>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return UploadCoverPhoto(repository);
});

final addFeaturedPhotoProvider = Provider<AddFeatured>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return AddFeatured(repository);
});

final removeFeaturedPhotoProvider = Provider<RemoveFeatured>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return RemoveFeatured(repository);
});

final utilityListenerProvider =
    StateNotifierProvider<UtilityStateNotifier, UserEntity?>((ref) {
  final editProfileData = ref.read(editProfileDataProvider);
  final uploadCoverPhoto = ref.read(uploadCoverPhotoProvider);
  final addFeaturedPhoto = ref.read(addFeaturedPhotoProvider);
  final removeFeaturedPhoto = ref.read(removeFeaturedPhotoProvider);
  return UtilityStateNotifier(
      editProfileData, uploadCoverPhoto, addFeaturedPhoto, removeFeaturedPhoto);
});

final editProfileLoadingNotifierProvider =
    StateNotifierProvider.autoDispose<BoolNotifier, bool>((ref) {
  return BoolNotifier();
});

final uploadingFeaturedLoadingNotifierProvider =
    StateNotifierProvider.autoDispose<BoolNotifier, bool>((ref) {
  return BoolNotifier();
});

class UtilityStateNotifier extends StateNotifier<UserEntity?> {
  final EditProfile _editProfile;
  final UploadCoverPhoto _uploadCoverPhoto;
  final AddFeatured _addFeatured;
  final RemoveFeatured _removeFeatured;
  UtilityStateNotifier(this._editProfile, this._uploadCoverPhoto,
      this._addFeatured, this._removeFeatured)
      : super(null);

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
            errorWidget(message: 'unknown error');
          }
        }

        return null;
      },
      (UserEntity userEntity) {
        return userEntity;
      },
    );
  }

  Future<UserEntity?> addFeatured({
    required String summary,
    required File media,
    required String accessToken,
    required String refreshToken,
  }) async {
    Either<DataState, UserEntity> response = await _addFeatured.addFeatured(
      media: media,
      summary: summary,
      accessToken: accessToken,
      refreshToken: refreshToken,
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
            errorWidget(message: 'unknown error');
          }
        }

        return null;
      },
      (UserEntity userEntity) {
        return userEntity;
      },
    );
  }

  Future<UserEntity?> removeFeatured({
    required String id,
    required String accessToken,
    required String refreshToken,
  }) async {
    Either<DataState, UserEntity> response =
        await _removeFeatured.removeFeatured(
            id: id, accessToken: accessToken, refreshToken: refreshToken);
    return response.fold(
      (DataState responseDataState) {
        if (responseDataState is DataFailureOffline) {
          errorWidget(message: 'you\'re offline');
        }
        if (responseDataState is DataFailure) {
          if (responseDataState.status != 500) {
            errorWidget(message: responseDataState.message);
          } else {
            errorWidget(message: 'unknown error');
          }
        }

        return null;
      },
      (UserEntity userEntity) {
        return userEntity;
      },
    );
  }

  Future<UserEntity?> uploadCoverPhoto({
    required File coverPhoto,
    required String accessToken,
    required String refreshToken,
  }) async {
    successWidget(message: 'Uploading....');
    Either<DataState, UserEntity> response =
        await _uploadCoverPhoto.uploadCoverPhoto(
            coverPhoto: coverPhoto,
            accessToken: accessToken,
            refreshToken: refreshToken);
    return response.fold(
      (DataState responseDataState) {
        if (responseDataState is DataFailureOffline) {
          errorWidget(message: 'you\'re offline');
        }
        if (responseDataState is DataFailure) {
          if (responseDataState.status != 500) {
            errorWidget(message: responseDataState.message);
          } else {
            errorWidget(message: 'unknown error');
          }
        }

        return null;
      },
      (UserEntity userEntity) {
        successWidget(message: 'Uploaded.');
        return userEntity;
      },
    );
  }
}
