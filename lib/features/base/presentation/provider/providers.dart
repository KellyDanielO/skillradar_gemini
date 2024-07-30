import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/saved_profile_entity.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/providers/provider_classes.dart';
import '../../../../core/providers/provider_variables.dart';
import '../../../../core/widgets/error_widgets.dart';
import '../../data/datasources/remote/remote_datasource.dart';
import '../../data/repositories/base_repository_impl.dart';
import '../../domain/repositories/base_repository.dart';
import '../../domain/usecases/get_feed_data_usecase.dart';
import '../../domain/usecases/get_saved_profile_usecase.dart';
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

class SavedProfileStateNotifier extends StateNotifier<SavedProfileState> {
  SavedProfileStateNotifier() : super(SavedProfileState.none);
  void change(SavedProfileState data) {
    state = data;
  }
}

class ExploreStateNotifier extends StateNotifier<ExploreState> {
  ExploreStateNotifier() : super(ExploreState.none);
  void change(ExploreState data) {
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

final selectedSkillsProvider =
    StateNotifierProvider<ListNotifier, List<String>>((ref) {
  return ListNotifier();
});

final bottomNavProvider = StateNotifierProvider<IntNotifier, int>((ref) {
  return IntNotifier();
});

final feedStateNotifierProvider =
    StateNotifierProvider<FeedStateNotifier, FeedState>((ref) {
  return FeedStateNotifier();
});

final savedProfileStateNotifierProvider =
    StateNotifierProvider<SavedProfileStateNotifier, SavedProfileState>((ref) {
  return SavedProfileStateNotifier();
});
final exploreStateNotifierProvider =
    StateNotifierProvider<ExploreStateNotifier, ExploreState>((ref) {
  return ExploreStateNotifier();
});

final feedUsersNotifierProvider =
    StateNotifierProvider<UsersStateNotifier, List<UserEntity>>((ref) {
  return UsersStateNotifier();
});


final discoveredUsersNotifierProvider =
    StateNotifierProvider<UsersStateNotifier, List<UserEntity>>((ref) {
  return UsersStateNotifier();
});

final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  return RemoteDataSource();
});

final baseRepositoryProvider = Provider<BaseRepository>((ref) {
  final remoteDataSource = ref.read(remoteDataSourceProvider);
  return BaseRepositoryImpl(remoteDataSource);
});

final getFeedDataProvider = Provider<GetFeedData>((ref) {
  final repository = ref.read(baseRepositoryProvider);
  return GetFeedData(repository);
});

final getSavedProfileProvider = Provider<GetSavedProfile>((ref) {
  final repository = ref.read(baseRepositoryProvider);
  return GetSavedProfile(repository);
});
final baseListenerProvider =
    StateNotifierProvider<BaseRepositoryStateNotifier, UserEntity?>((ref) {
  final getFeedData = ref.read(getFeedDataProvider);
  final getSavedProfile = ref.read(getSavedProfileProvider);
  return BaseRepositoryStateNotifier(getFeedData, getSavedProfile);
});

class BaseRepositoryStateNotifier extends StateNotifier<UserEntity?> {
  final GetFeedData _getFeedData;
  final GetSavedProfile _getSavedProfile;
  BaseRepositoryStateNotifier(this._getFeedData, this._getSavedProfile)
      : super(null);

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

  Future<void> getSavedProfile({
    required WidgetRef ref,
    required String accessToken,
    required String refreshToken,
  }) async {
    Either<DataState, List<SavedProfileEntity>> response = await _getSavedProfile
        .getSavedProfile(accessToken: accessToken, refreshToken: refreshToken);
    return response.fold(
      (DataState responseDataState) {
        if (responseDataState is DataFailureOffline) {
          errorWidget(message: 'you\'re offline');
        }
        if (responseDataState is DataFailure) {
          if (responseDataState.status != 500) {
            if (responseDataState.status == 404) {
              ref
                  .read(savedProfileStateNotifierProvider.notifier)
                  .change(SavedProfileState.noUser);
            }
            errorWidget(message: responseDataState.message);
          } else {
            errorWidget(message: 'unknown error');
          }
        }
      },
      (List<SavedProfileEntity> users) {
        if (users.isEmpty) {
          ref
              .read(savedProfileStateNotifierProvider.notifier)
              .change(SavedProfileState.noUser);
        } else {
          ref.read(savedUsersNotifierProvider.notifier).setUsers(users);
          ref.read(savedProfileStateNotifierProvider.notifier).change(SavedProfileState.none);
        }
      },
    );
  }
}
