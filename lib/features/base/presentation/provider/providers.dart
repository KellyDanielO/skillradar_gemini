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
import '../constants/enums.dart';

class IntNotifier extends StateNotifier<int> {
  IntNotifier() : super(0);

  void change(int value) {
    state = value;
  }
}

class FeedStateNotifier extends StateNotifier<FeedState> {
  FeedStateNotifier() : super(FeedState.none);
  void change(FeedState data) {
    state = data;
  }
}

class ListNotifier extends StateNotifier<List<String>> {
  ListNotifier() : super([]);
  void setList(List<String> list) {
    state = list;
  }

  void addSkill(String skill) {
    state = [...state, skill];
  }

  void removeSkill(String skill) {
    state = state.where((s) => s != skill).toList();
  }

  void clearSkills() {
    state = [];
  }
}

final selectedSkillsProvider = StateNotifierProvider<ListNotifier, List<String>>((ref) {
  return ListNotifier();
});

final bottomNavProvider = StateNotifierProvider<IntNotifier, int>((ref) {
  return IntNotifier();
});

final feedStateNotifierProvider =
    StateNotifierProvider<FeedStateNotifier, FeedState>((ref) {
  return FeedStateNotifier();
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
            if (responseDataState.status == 404) {
              ref
                  .read(feedStateNotifierProvider.notifier)
                  .change(FeedState.noUsers);
            }
            errorWidget(message: responseDataState.message);
          } else {
            errorWidget(message: 'unknown error');
          }
        }
      },
      (List<UserEntity> users) {
        if (users.isEmpty) {
          ref
              .read(feedStateNotifierProvider.notifier)
              .change(FeedState.noUsers);
        } else {
          ref.read(feedUsersNotifierProvider.notifier).setUsers(users);
          ref.read(feedStateNotifierProvider.notifier).change(FeedState.none);
        }
      },
    );
  }
}
