import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/widgets/error_widgets.dart';
import '../../../../core/widgets/success_widgets.dart';
import '../../../../core/entities/user_entity.dart';
import '../../data/datasources/remote/remote_datasource.dart';
import '../../data/repositories/initilize_repository_impl.dart';
import '../../domain/repositories/initilize_repository.dart';
import '../../domain/usecases/get_userdata_usecase.dart';

final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  return RemoteDataSource();
});

final authRepositoryProvider = Provider<InitilizeRepository>((ref) {
  final remoteDataSource = ref.read(remoteDataSourceProvider);
  return InitilizeRepositoryImpl(remoteDataSource);
});
final getUserDataProvider = Provider<GetUserData>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return GetUserData(repository);
});
final initializeListenerProvider =
    StateNotifierProvider<InitializeStateNotifier, UserEntity?>((ref) {
  final getUserData = ref.read(getUserDataProvider);
  return InitializeStateNotifier(getUserData);
});

class InitializeStateNotifier extends StateNotifier<UserEntity?> {
  final GetUserData _getUserData;
  InitializeStateNotifier(this._getUserData) : super(null);

  Future<UserEntity?> getUserData({
    required String accessToken,
    required String refreshToken,
  }) async {
    Either<DataState, UserEntity> response = await _getUserData.getUserData(
        accessToken: accessToken, refreshToken: refreshToken);
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
        if (userEntity.username == null || userEntity.location == null) {
          AppHelpers().writeData('account_stage', 'set-up');
        } else {
          AppHelpers().writeData('account_stage', 'done');
        }
          successWidget(message: 'Welcome Back');
        return userEntity;
      },
    );
  }
}
