import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/providers/provider_classes.dart';
import '../../../../core/widgets/error_widgets.dart';
import '../../data/datasources/remote/remote_datasource.dart';
import '../../data/repositories/base_repository_impl.dart';
import '../../domain/repositories/base_repository.dart';
import '../../domain/usecases/get_feed_data_usecase.dart';

class IntNotifier extends StateNotifier<int> {
  IntNotifier() : super(0);

  void change(int value) {
    state = value;
  }
}

final bottomNavProvider = StateNotifierProvider<IntNotifier, int>((ref) {
  return IntNotifier();
});

final feedLoadingNotifierProvider =
    StateNotifierProvider<BoolNotifier, bool>((ref) {
  return BoolNotifier();
});

final feedUsersNotifierProvider =
    StateNotifierProvider<UsersStateNotifier, List<UserEntity>>((ref) {
  return UsersStateNotifier();
});

final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  return RemoteDataSource();
});

final authRepositoryProvider = Provider<BaseRepository>((ref) {
  final remoteDataSource = ref.read(remoteDataSourceProvider);
  return BaseRepositoryImpl(remoteDataSource);
});
final getFeedDataProvider = Provider<GetFeedData>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return GetFeedData(repository);
});
final baseListenerProvider =
    StateNotifierProvider<BaseRepositoryStateNotifier, UserEntity?>((ref) {
  final getFeedData = ref.read(getFeedDataProvider);
  return BaseRepositoryStateNotifier(getFeedData);
});

class BaseRepositoryStateNotifier extends StateNotifier<UserEntity?> {
  final GetFeedData _getFeedData;
  BaseRepositoryStateNotifier(this._getFeedData) : super(null);

  Future<void> getFeedData({
    required WidgetRef ref,
    required String accessToken,
    required String refreshToken,
  }) async {
    Either<DataState, List<UserEntity>> response = await _getFeedData
        .getFeedData(accessToken: accessToken, refreshToken: refreshToken);
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
      },
      (List<UserEntity> users) {
        ref.read(feedUsersNotifierProvider.notifier).setUsers(users);
        ref.read(feedLoadingNotifierProvider.notifier).change(false);
      },
    );
  }
}
