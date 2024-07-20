
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/widgets/error_widgets.dart';
import '../../../../core/widgets/success_widgets.dart';
import '../../data/datasources/remote/remote_data_source.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usercases/create_account_usecase.dart';
import '../../domain/usercases/setup_account_usecase.dart';

final remoteDataSourceProvider = Provider<RemoteDataSource>((ref) {
  return RemoteDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.read(remoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});
final createAccountProvider = Provider<CreateAccount>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return CreateAccount(repository);
});
final setUpAccountProvider = Provider<SetUpAccount>((ref) {
  final repository = ref.read(authRepositoryProvider);
  return SetUpAccount(repository);
});

final createAccountListenerProvider =
    StateNotifierProvider<AuthStateNotifier, UserEntity?>((ref) {
  final createAccount = ref.read(createAccountProvider);
  final setUpAccount = ref.read(setUpAccountProvider);
  return AuthStateNotifier(createAccount, setUpAccount);
});
final setUpAccountListenerProvider =
    StateNotifierProvider<AuthStateNotifier, UserEntity?>((ref) {
  final setUpAccount = ref.read(setUpAccountProvider);
  final createAccount = ref.read(createAccountProvider);
  return AuthStateNotifier(createAccount, setUpAccount);
});

class AuthStateNotifier extends StateNotifier<UserEntity?> {
  final CreateAccount _createAccount;
  final SetUpAccount _setUpAccount;
  AuthStateNotifier(this._createAccount, this._setUpAccount) : super(null);

  Future<bool> createAccount({
    required String userId,
    required String accountTye,
    required String email,
    required String name,
  }) async {
    Either<DataState, UserEntity> response = await _createAccount.createAccount(
        userId: userId, accountTye: accountTye, email: email, name: name);
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

        return false;
      },
      (UserEntity userEntity) {
        AppHelpers().writeData('access_token', userEntity.tokens!.accessToken);
        AppHelpers()
            .writeData('refresh_token', userEntity.tokens!.refreshToken);
        AppHelpers().writeData('account_stage', 'set-up');
        successWidget(message: 'Successful!');
        return true;
      },
    );
  }

  Future<bool> setUpAccount({
    required String location,
    required String username,
  }) async {
    String? accessToken = await AppHelpers().getData('access_token');
    String? refreshToken = await AppHelpers().getData('refresh_token');
    if (accessToken != null && refreshToken != null) {
      Either<DataState, UserEntity> response = await _setUpAccount.setUpAccount(
        accessToken: accessToken,
        refreshToken: refreshToken,
        username: username,
        location: location,
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
              print(responseDataState.status);
              print(responseDataState.message);
              errorWidget(message: 'unknown error');
            }
          }

          return false;
        },
        (UserEntity userEntity) {
          AppHelpers().writeData('account_stage', 'done');
          successWidget(message: 'Successful!');
          return true;
        },
      );
    } else {
      return false;
    }
  }
}
