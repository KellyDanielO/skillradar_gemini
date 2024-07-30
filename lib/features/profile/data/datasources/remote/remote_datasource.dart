import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constants/constants.dart';
import '../../../../../core/data_state/data_state.dart';
import '../../../../../core/models/saved_profile_model.dart';

class RemoteDatasource {
  Future<Either<DataState, SavedProfileModel>> saveProfile({
    required String accessToken,
    required String refreshToken,
    required String id,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${AppConstants.baseUrl}/user/saved-profile/'),
        body: {
          'profile_id': id,
        },
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );
      response.headers['content-type'] = 'application/json; charset=utf-8';
      final statusCode = response.statusCode;
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (response.statusCode == 201) {
        SavedProfileModel profile =
            SavedProfileModel.fromJson(jsonResponse['data']);
        return Right(profile);
      } else if (statusCode == 401) {
        return Left(DataFailure(response.statusCode, 'unauthorized access'));
      } else {
        return Left(DataFailure(response.statusCode, jsonResponse['response']));
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return Left(DataFailureOffline(700, 'network error'));
      }
      return Left(DataFailure(500, e.toString()));
    }
  }

  Future<Either<DataState, String>> removeProfile({
    required String accessToken,
    required String refreshToken,
    required String id,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('${AppConstants.baseUrl}/user/saved-profile/$id/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );
      response.headers['content-type'] = 'application/json; charset=utf-8';
      final statusCode = response.statusCode;
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        return const Right('done');
      } else if (statusCode == 401) {
        return Left(DataFailure(response.statusCode, 'unauthorized access'));
      } else {
        return Left(DataFailure(response.statusCode, jsonResponse['response']));
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return Left(DataFailureOffline(700, 'network error'));
      }
      return Left(DataFailure(500, e.toString()));
    }
  }
}
