import 'dart:convert';
import 'dart:io';

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
  Future<Either<DataState, UserModel>> loginAccount({
    required String userId,
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/auth/login/'),
        body: {
          "user_id": userId,
          "email": email,
        },
      );
      final statusCode = response.statusCode;
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        UserModel user = UserModel.fromJson(jsonResponse['user']);
        final tokens = TokenModel.fromJson(jsonResponse);
        user.tokens = tokens;
        return Right(user);
      } else if (statusCode == 400) {
        return Left(DataFailure(response.statusCode, 'missing data'));
      } else if (statusCode == 406 || statusCode == 404) {
        return Left(DataFailure(response.statusCode, 'account not found'));
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

  Future<Either<DataState, UserModel>> setUpAccount({
    required String accessToken,
    required String refreshToken,
    required String username,
    required String location,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('${AppConstants.baseUrl}/auth/set-up/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
        body: {
          "username": username,
          "location": location,
        },
      );
      final statusCode = response.statusCode;
      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        UserModel user = UserModel.fromJson(jsonResponse['data']);
        return Right(user);
      } else if (statusCode == 400) {
        return Left(DataFailure(response.statusCode, 'missing data'));
      } else if (statusCode == 406) {
        return Left(DataFailure(response.statusCode, 'username exists'));
      } else if (statusCode == 401) {
        return Left(DataFailure(response.statusCode, 'unauthorized access'));
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
