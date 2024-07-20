import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/constants/constants.dart';
import '../../../../../core/data_state/data_state.dart';
import '../../models/token_model.dart';
import '../../models/user_model.dart';

class RemoteDataSource {
  Future<Either<DataState, UserModel>> createAccount({
    required String userId,
    required String accountTye,
    required String email,
    required String name,
  }) async {
    print('data source');
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/auth/register/'),
        body: {
          "user_id": userId,
          "account_type": accountTye,
          "email": email,
          "name": name
        },
      );
      final statusCode = response.statusCode;
      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        UserModel user = UserModel.fromJson(jsonResponse['user']);
        final tokens = TokenModel.fromJson(jsonResponse);
        user.tokens = tokens;
        return Right(user);
      } else if (statusCode == 400) {
        return Left(DataFailure(response.statusCode, 'missing data'));
      } else if (statusCode == 406) {
        return Left(DataFailure(response.statusCode, 'invalid email'));
      } else if (statusCode == 401) {
        return Left(DataFailure(response.statusCode, 'email exist'));
      } else {
        return Left(DataFailure(response.statusCode, response.body));
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return Left(DataFailureOffline(700, 'network error'));
      }
      return Left(DataFailure(500, e.toString()));
    }
  }
}
