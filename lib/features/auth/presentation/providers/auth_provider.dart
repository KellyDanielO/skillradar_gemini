import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/data_state/data_state.dart';
import '../../../../core/widgets/error_widgets.dart';
import '../../data/datasources/remote/remote_data_source.dart';
import '../../data/repository/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usercases/create_account_usecase.dart';

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

final createAccountListenerProvider =
    StateNotifierProvider<AuthStateNotifier, UserEntity?>((ref) {
  final createAccount = ref.read(createAccountProvider);
  return AuthStateNotifier(createAccount);
});

class AuthStateNotifier extends StateNotifier<UserEntity?> {
  final CreateAccount _createAccount;
  AuthStateNotifier(this._createAccount) : super(null);

  Future<bool> createAccount({
    required String userId,
    required String accountTye,
    required String email,
    required String name,
  }) async {
    print('object');
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
        log(userEntity.name);
        return true;
      },
    );
  }
}
