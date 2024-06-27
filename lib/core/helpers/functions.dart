// ignore_for_file: deprecated_member_use

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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
}
