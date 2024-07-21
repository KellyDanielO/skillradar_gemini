import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import '../../../../../core/constants/constants.dart';
import '../../../../../core/data_state/data_state.dart';
import '../../../../../core/models/skill_model.dart';
import '../../../../../core/models/user_model.dart';

class RemoteDataSource {
  Future<Either<DataState, UserModel>> getUserData({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/user/'),
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );
      final statusCode = response.statusCode;
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        UserModel user = UserModel.fromJson(jsonResponse['data']);
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

  Future<Either<DataState, UserModel>> addSkills({
    required String skills,
    required String accessToken,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('${AppConstants.baseUrl}/user/'),
        body: {
          'skills': skills,
        },
        headers: {
          HttpHeaders.authorizationHeader: 'Bearer $accessToken',
        },
      );
      final statusCode = response.statusCode;
      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        UserModel user = UserModel.fromJson(jsonResponse['data']);
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

  Future<Either<DataState, List<SkillModel>>> getAllSkills() async {
    try {
      final response = await http.get(
        Uri.parse('${AppConstants.baseUrl}/skill/'),
      );
      final statusCode = response.statusCode;
      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<SkillModel> skills = SkillModel.fromJsonList(jsonResponse);
        return Right(skills);
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
