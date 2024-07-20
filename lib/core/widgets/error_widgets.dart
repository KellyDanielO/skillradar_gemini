import 'dart:developer';
import 'dart:io';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:skillradar/core/helpers/app_extensions.dart';

import '../constants/colors.dart';

void errorWidget({required String message}) {
  if (Platform.isAndroid || Platform.isIOS) {
    Fluttertoast.showToast(
      msg: message.capitalizeFirst.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: AppColors.redColor,
      textColor: AppColors.whiteColor,
      fontSize: 14.sp,
    );
  }
  else{
    log(message);
  }
}
