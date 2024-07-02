import 'dart:developer';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants/colors.dart';

void errorWidget({required String message}) {
  if (Platform.isAndroid || Platform.isIOS) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.redColor,
      textColor: AppColors.whiteColor,
      fontSize: 16.sp,
    );
  }
  else{
    log(message);
  }
}
