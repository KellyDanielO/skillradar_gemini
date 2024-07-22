import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillradar/core/helpers/extensions.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/router.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/providers/provider_variables.dart';
import '../providers/initialize_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    AppHelpers.changeBottomBarColor();
    request();
    super.initState();
  }

  void request() async {
    await AppHelpers.requestStoragePermission();
    String? accessToken = await AppHelpers().getData('access_token');
    String? refreshToken = await AppHelpers().getData('refresh_token');
    // print(accessToken);
    if (accessToken.isNull || refreshToken.isNull) {
      if (mounted) {
        AppHelpers.goReplacedNamed(
            routeName: AppRouter.welcomeScreen, context: context);
      }
    } else {
      ref
          .read(initializeListenerProvider.notifier)
          .getUserData(accessToken: accessToken!, refreshToken: refreshToken!)
          .then(
        (UserEntity? user) async {
          String? accountStage = await AppHelpers().getData('account_stage');
          ref.read(gobalUserNotifierProvider.notifier).setUser(user);
          await ref
              .read(initializeListenerProvider.notifier)
              .getAllSkills(ref: ref);
          if (mounted) {
            if (accountStage == null) {
              AppHelpers.goReplacedNamed(
                  routeName: AppRouter.welcomeScreen, context: context);
            } else {
              if (accountStage == 'set-up') {
                AppHelpers.goReplacedNamed(
                    routeName: AppRouter.setUpScreen, context: context);
              } else if (accountStage == 'done') {
                AppHelpers.goReplacedNamed(
                    routeName: AppRouter.baseScreen, context: context);
              } else {
                AppHelpers.goReplacedNamed(
                    routeName: AppRouter.welcomeScreen, context: context);
              }
            }
          }
        },
      );
    }
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
