import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/widgets/custom_btns.dart';
import '../../../base/presentation/screens/base_screen.dart';

class SetupAccountSuccessScreen extends ConsumerStatefulWidget {
  const SetupAccountSuccessScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SetupAccountSuccessScreenState();
}

class _SetupAccountSuccessScreenState
    extends ConsumerState<SetupAccountSuccessScreen> {
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
          children: <Widget>[
            Hero(
              tag: 'setup_success',
              transitionOnUserGestures: true,
              child: Icon(
                CupertinoIcons.check_mark_circled_solid,
                color: AppColors.primaryColor,
                size: 100.sp,
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              'Account set up successful!',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.sansFont,
                    color: AppColors.whiteColor,
                  ),
            ),
            SizedBox(height: 10.h),
            Hero(
              tag: 'submit_button',
              transitionOnUserGestures: true,
              child: CustomBtn(
                text: 'Dive in',
                width: width * .35,
                btnColor: AppColors.primaryColor,
                textColor: AppColors.blackColor,
                borderRadius: BorderRadius.circular(10),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                fontSize: 14.sp,
                onPressed: () {
                  AppHelpers.moveTo(const BaseScreen(), context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
