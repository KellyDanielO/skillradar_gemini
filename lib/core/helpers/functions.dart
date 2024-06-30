// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../features/utils/presentation/screens/image_picker/media_picker.dart';
import '../constants/colors.dart';

class AppHelpers {
  static void moveTo(Widget newScreen, BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => newScreen,
      ),
    );
  }

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
      required RequestType requestType,
      required BuildContext context}) async {
    List<AssetEntity>? result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MediaPicker(maxCount, requestType);
        },
      ),
    );
    if (result != null) {
      // setState(() {
      //   haveSelected = true;
      //   selectedAssetList = result;
      // });
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
          print("Storage permission granted");
        } else {
          // The permission was denied
          print("Storage permission denied");
        }
      } else {
        // The permission is already granted
        print("Storage permission already granted");
      }
    }
  }
}
