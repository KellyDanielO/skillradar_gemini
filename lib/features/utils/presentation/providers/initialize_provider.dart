import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/entities/skill_entity.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/providers/provider_variables.dart';
import '../../../../core/widgets/error_widgets.dart';
import '../../../../core/widgets/success_widgets.dart';
import '../../../../core/entities/user_entity.dart';
import '../../data/datasources/remote/remote_datasource.dart';
import '../../data/repositories/initilize_repository_impl.dart';
import '../../domain/entities/initilize_entity.dart';
import '../../domain/repositories/initilize_repository.dart';
import '../../domain/usecases/add_skills_usecase.dart';
import '../../domain/usecases/get_skill_usecase.dart';
import '../../domain/usecases/get_userdata_usecase.dart';
import '../../domain/usecases/initializer_usecase.dart';

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
final getAllSkillsProvider = Provider<GetAllSkills>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return GetAllSkills(repository);
});
final addSkillsProvider = Provider<AddSkills>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return AddSkills(repository);
});
final initializeProvider = Provider<Initializer>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return Initializer(repository);
});
final initializeListenerProvider =
    StateNotifierProvider<InitializeStateNotifier, UserEntity?>((ref) {
  final getUserData = ref.read(getUserDataProvider);
  final getAllSkills = ref.read(getAllSkillsProvider);
  final addSkills = ref.read(addSkillsProvider);
  final initialize = ref.read(initializeProvider);
  return InitializeStateNotifier(
      getUserData, getAllSkills, addSkills, initialize);
});

class InitializeStateNotifier extends StateNotifier<UserEntity?> {
  final GetUserData _getUserData;
  final GetAllSkills _getAllSkills;
  final AddSkills _addSkills;
  final Initializer _initializer;
  InitializeStateNotifier(
      this._getUserData, this._getAllSkills, this._addSkills, this._initializer)
      : super(null);

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

  Future<void> initilize({
    required WidgetRef ref,
  }) async {
    Either<DataState, InitilizeEntity> response =
        await _initializer.initialize();
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
      (InitilizeEntity data) {
        ref.read(gobalSkillsNotifierProvider.notifier).setSkill(data.skills);
        ref.read(gobalSocialsNotifierProvider.notifier).setSkill(data.socials);
      },
    );
  }

  Future<UserEntity?> addSkills({
    required String skills,
    required String accessToken,
    required String refreshToken,
  }) async {
    log(skills);
    Either<DataState, UserEntity> response = await _addSkills.addSkills(
        skills: skills, accessToken: accessToken, refreshToken: refreshToken);
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

  Future<void> getAllSkills({
    required WidgetRef ref,
  }) async {
    Either<DataState, List<SkillEntity>> response =
        await _getAllSkills.getAllSkills();
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
      (List<SkillEntity> skills) {
        ref.read(gobalSkillsNotifierProvider.notifier).setSkill(skills);
      },
    );
  }
}
