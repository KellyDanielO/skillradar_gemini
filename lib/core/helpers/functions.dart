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
}
