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
      ).timeout(const Duration(minutes: 2));
      final statusCode = response.statusCode;
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (response.statusCode == 200) {
        UserModel user = UserModel.fromJson(jsonResponse['data']);
        return Right(user);
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
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (response.statusCode == 201) {
        UserModel user = UserModel.fromJson(jsonResponse['data']);
        return Right(user);
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

  Future<Either<DataState, UserModel>> editProfile({
    required String bio,
    required String name,
    required String location,
    File? profileImage,
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}/user/');

      // Create a multipart request
      final request = http.MultipartRequest('PUT', uri)
        ..headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken'
        ..fields['bio'] = bio
        ..fields['name'] = name
        ..fields['location'] = location;

      // If a file is provided, add it to the request
      if (profileImage != null) {
        final fileStream = http.ByteStream(profileImage.openRead());
        final length = await profileImage.length();
        final multipartFile = http.MultipartFile(
          'profile_picture',
          fileStream,
          length,
          filename: profileImage.uri.pathSegments.last,
        );
        request.files.add(multipartFile);
      }

      // Send the request and get the response
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      final statusCode = response.statusCode;
      final jsonResponse = json.decode(responseBody);
      if (response.statusCode == 201 || statusCode == 200) {
        UserModel user = UserModel.fromJson(jsonResponse['user']);
        return Right(user);
      } else if (statusCode == 401) {
        return Left(DataFailure(response.statusCode, 'unauthorized access'));
      } else if (statusCode == 404) {
        return Left(DataFailure(response.statusCode, 'address not found'));
      } else {
        return Left(DataFailure(response.statusCode, jsonResponse));
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return Left(DataFailureOffline(700, 'network error'));
      }
      return Left(DataFailure(500, e.toString()));
    }
  }

  Future<Either<DataState, UserModel>> uploadCoverPhoto({
    required File coverPhoto,
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      final uri = Uri.parse('${AppConstants.baseUrl}/user/cover-photo/');

      // Create a multipart request
      final request = http.MultipartRequest('PATCH', uri)
        ..headers[HttpHeaders.authorizationHeader] = 'Bearer $accessToken';
    

    
        final fileStream = http.ByteStream(coverPhoto.openRead());
        final length = await coverPhoto.length();
        final multipartFile = http.MultipartFile(
          'cover_photo',
          fileStream,
          length,
          filename: coverPhoto.uri.pathSegments.last,
        );
        request.files.add(multipartFile);

      // Send the request and get the response
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      final statusCode = response.statusCode;
      final jsonResponse = json.decode(responseBody);
      if (response.statusCode == 201 || statusCode == 200) {
        UserModel user = UserModel.fromJson(jsonResponse['user']);
        return Right(user);
      } else if (statusCode == 401) {
        return Left(DataFailure(response.statusCode, 'unauthorized access'));
      } else if (statusCode == 404) {
        return Left(DataFailure(response.statusCode, 'user not found'));
      } else {
        return Left(DataFailure(response.statusCode, jsonResponse));
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
        return Left(DataFailure(response.statusCode, 'error'));
      }
    } catch (e) {
      if (e.toString().contains('SocketException')) {
        return Left(DataFailureOffline(700, 'network error'));
      }
      return Left(DataFailure(500, e.toString()));
    }
  }
}
