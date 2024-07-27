import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/providers/provider_classes.dart';
import '../../../../core/widgets/error_widgets.dart';
import '../../../base/presentation/constants/enums.dart';
import '../../data/datasources/remote/remote_datasource.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/usecases/skill_search_usecase.dart';

final skillSearchUsersNotifierProvider =
    StateNotifierProvider<UsersStateNotifier, List<UserEntity>>((ref) {
  return UsersStateNotifier();
});

class SkillSearchStateNotifier extends StateNotifier<SkillSearchState> {
  SkillSearchStateNotifier() : super(SkillSearchState.loading);
  void change(SkillSearchState data) {
    state = data;
  }
}

final skillSearchStateNotifierProvider =
    StateNotifierProvider.autoDispose<SkillSearchStateNotifier, SkillSearchState>((ref) {
  return SkillSearchStateNotifier();
});

final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  return RemoteDataSource();
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  final remoteDataSource = ref.read(remoteDataSourceProvider);
  return SearchRepositoryImpl(remoteDataSource);
});
final skillSearchProvider = Provider<SkillSearch>((ref) {
  final repository = ref.read(searchRepositoryProvider);
  return SkillSearch(repository);
});
final searchListenerProvider =
    StateNotifierProvider<SearchRepositoryStateNotifier, UserEntity?>((ref) {
  final skillSearch = ref.read(skillSearchProvider);
  return SearchRepositoryStateNotifier(skillSearch);
});

class SearchRepositoryStateNotifier extends StateNotifier<UserEntity?> {
  final SkillSearch _skillSearch;
  SearchRepositoryStateNotifier(this._skillSearch) : super(null);

  Future<void> searchSkill({
    required WidgetRef ref,
    required String skills,
    required String accessToken,
    required String refreshToken,
  }) async {
    Either<DataState, List<UserEntity>> response =
        await _skillSearch.skillSearch(
            skills: skills,
            accessToken: accessToken,
            refreshToken: refreshToken);
    return response.fold(
      (DataState responseDataState) {
        if (responseDataState is DataFailureOffline) {
          errorWidget(message: 'you\'re offline');
        }
        if (responseDataState is DataFailure) {
          if (responseDataState.status != 500) {
            if (responseDataState.status == 404) {
              errorWidget(message: 'no selected skill');
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
              .read(skillSearchStateNotifierProvider.notifier)
              .change(SkillSearchState.noUsers);
        } else {
          ref.read(skillSearchUsersNotifierProvider.notifier).setUsers(users);
          ref
              .read(skillSearchStateNotifierProvider.notifier)
              .change(SkillSearchState.done);
        }
      },
    );
  }
}
