import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/helpers/functions.dart';
import 'onboarding_screens.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {

    AppHelpers.changeBottomBarColor();
    Future.delayed(
      const Duration(seconds: 5),
      () => AppHelpers.moveTo(const OnboardingScreen(), context),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    return Scaffold(
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 250.w,
              height: 250.w,
              child: Image.asset(AppAssets.logo3),
            ).animate().fade(delay: 500.ms),
            const CupertinoActivityIndicator(
              color: AppColors.primaryColor,
              radius: 15,
            ).animate().fade(delay: 1.seconds),
          ],
        ),
      ),
    );
  }
}
