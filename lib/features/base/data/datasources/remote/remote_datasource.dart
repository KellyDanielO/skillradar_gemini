import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/constants/constants.dart';
import '../../../../../core/data_state/data_state.dart';
import '../../../../../core/models/user_model.dart';

class RemoteDataSource {
  Future<Either<DataState, List<UserModel>>> getFeedData({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/get-all-users-with-same-skill/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
          HttpHeaders.contentTypeHeader: "application/json",
        },
      );
      response.headers['content-type'] = 'application/json; charset=utf-8';
      final statusCode = response.statusCode;
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        List<UserModel> user = UserModel.fromJsonList(jsonResponse['users']);
        return Right(user);
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
