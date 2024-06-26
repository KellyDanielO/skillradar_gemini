import 'dart:math';

import 'package:flutter/cupertino.dart';

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
}
