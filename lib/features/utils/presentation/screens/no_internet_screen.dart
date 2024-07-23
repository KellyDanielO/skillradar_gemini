import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/router.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/widgets/custom_btns.dart';

class NoInternetScreen extends ConsumerStatefulWidget {
  const NoInternetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NoInternetScreenState();
}

class _NoInternetScreenState extends ConsumerState<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: width * .2,
              child: Image.asset(AppAssets.notInternet),
            ),
            SizedBox(height: 10.h),
            Text(
              'No Internet',
              style: TextStyle(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: AppHelpers.isTablet() ? 12.sp : 18.sp,
                fontFamily: AppFonts.sansFont,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              'Please check your internet connection \nand try again',
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: AppHelpers.isTablet() ? 12.sp : 12.sp,
                fontFamily: AppFonts.sansFont,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: width * .5,
              child: CustomBtn(
                text: 'Try Again!',
                textColor: AppColors.blackColor,
                btnColor: AppColors.whiteColor,
                fontSize: 12.sp,
                padding: EdgeInsets.symmetric(vertical: 10.h),
                onPressed: () {
                  AppHelpers.goReplacedNamed(routeName: AppRouter.splashScreen, context: context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
