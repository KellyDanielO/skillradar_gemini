// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/utils/presentation/screens/image_picker/media_picker.dart';
import '../constants/colors.dart';
import '../constants/constants.dart';
import '../entities/skill_entity.dart';
import '../entities/user_entity.dart';

class AppHelpers {
  static void moveTo(Widget newScreen, BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => newScreen,
      ),
    );
  }

  final _secureStorage = const FlutterSecureStorage();
  AndroidOptions _getAndroidOptions() =>
      const AndroidOptions(encryptedSharedPreferences: true);

  static String generateRandomId({int length = 8}) {
    const charset =
        '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => charset.codeUnitAt(random.nextInt(charset.length))));
  }

  static void launchUrlNow(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      //
    }
  }

  static void launchEmail({
    required String to,
    required String subject,
    required String body,
  }) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: to,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    await launch(emailLaunchUri.toString());
  }

  static void launchPhoneCall(String phoneNumber) async {
    final Uri phoneCallUri = Uri(scheme: 'tel', path: phoneNumber);

    await launch(phoneCallUri.toString());
  }

  static void navigateNamed(BuildContext context, String routName,
      [Object? arguments]) {
    Navigator.pushNamed(context, routName, arguments: arguments);
  }

  static void navigateReplacementNamed(BuildContext context, String routName) {
    Navigator.of(context).pushNamedAndRemoveUntil(routName, (route) => false);
  }

  static void changeBottomBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.blackColor,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.blackColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  static bool isTablet() {
    return false;
  }

  Future<List<AssetEntity>?> pickAssets(
      {required int maxCount,
      RequestType? requestType,
      required BuildContext context}) async {
    List<AssetEntity>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MediaPicker(maxCount, requestType ?? RequestType.image);
        },
      ),
    );
    if (result != null) {
      return result;
    }
    return null;
  }

  static Future<void> requestStoragePermission() async {
    // Check the status of the permission
    if (Platform.isAndroid || Platform.isIOS) {
      var status = await Permission.storage.status;

      if (!status.isGranted) {
        // Request the permission
        if (await Permission.storage.request().isGranted) {
          // The permission was granted
          debugPrint("Storage permission granted");
        } else {
          // The permission was denied
          debugPrint("Storage permission denied");
        }
      } else {
        // The permission is already granted
        debugPrint("Storage permission already granted");
      }
    }
  }

  Future<void> writeData(String key, String value) async {
    await _secureStorage.write(
      key: key,
      value: value,
      aOptions: _getAndroidOptions(),
    );
  }

  Future<void> deleteData(String key) async {
    await _secureStorage.delete(
      key: key,
      aOptions: _getAndroidOptions(),
    );
  }

  Future<void> deleteAllData() async {
    await _secureStorage.deleteAll(
      aOptions: _getAndroidOptions(),
    );
  }

  Future<void> logout() async {
    await AuthController().signOutFromGoogle();
    await deleteAllData();
  }

  Future<String?> getData(
    String key,
  ) async {
    var data = await _secureStorage.read(
      key: key,
      aOptions: _getAndroidOptions(),
    );
    return data.toString();
  }

  static Future<bool> isOnline() async {
    bool result = await InternetConnectionChecker().hasConnection;
    return result;
  }

  static Future<String> getCompleteAddress() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return 'Location permissions are denied.';
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return 'Location permissions are permanently denied.';
    }

    // Get the current location of the device.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Convert the coordinates to a list of placemarks.
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // Get the first placemark in the list.
    Placemark placemark = placemarks.first;

    // Construct the full address string.
    String completeAddress =
        '${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea}, ${placemark.country}';

    return completeAddress;
  }

  static bool isValidUsername(String username) {
    // Define a regular expression pattern for allowed usernames
    final RegExp usernameRegExp = RegExp(r'^[a-zA-Z0-9_]+$');

    // Check if the username matches the pattern
    return usernameRegExp.hasMatch(username);
  }

  static void goNamed({
    required String routeName,
    required BuildContext context,
  }) {
    context.pushNamed(routeName);
  }

  static void goReplacedNamed({
    required String routeName,
    required BuildContext context,
  }) {
    context.goNamed(routeName);
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 18) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  static SkillEntity findFirstCommonSkill(UserEntity user1, UserEntity user2) {
    Set<int> skillIds1 = user1.skills.map((skill) => skill.id).toSet();

    for (SkillEntity skill in user2.skills) {
      if (skillIds1.contains(skill.id)) {
        return skill;
      }
    }
    return user2.skills.first;
  }

  static String findFirstCommonSkillSet(
      List<SkillEntity> skills1, List<String> skills2) {
    Set<String> skillIds1 = skills1.map((skill) => skill.name).toSet();

    for (String skill in skills2) {
      if (skillIds1.contains(skill)) {
        return skill;
      }
    }
    return skills2.first;
  }

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    }
  }

  void precacheNetworkImages(BuildContext context, List<String> imageUrls) {
    for (String imageUrl in imageUrls) {
      precacheImage(NetworkImage(imageUrl), context);
    }
  }

  static String getRandomValue(List<String> array) {
    final random = Random();

    int randomIndex = random.nextInt(array.length);

    String randomValue = array[randomIndex];

    return randomValue;
  }

  Future<String?> generateText({required String promptText}) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: AppConstants.geminiAPIKey,
    );

    final prompt = promptText;
    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);
    return response.text;
  }
}
