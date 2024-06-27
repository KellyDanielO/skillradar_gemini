import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/widgets/custom_btns.dart';
import 'setup_account_screen.dart';

class SelectUsernameAndLocation extends ConsumerStatefulWidget {
  const SelectUsernameAndLocation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectUsernameAndLocationState();
}

class _SelectUsernameAndLocationState
    extends ConsumerState<SelectUsernameAndLocation> {
  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10.h),
              Text(
                'Set up account!',
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sansFont,
                      color: AppColors.whiteColor,
                    ),
              ),
              SizedBox(height: 25.h),
              Text(
                'Please fill in a unque username',
                style: TextStyle(
                  color: AppColors.whiteColor.withOpacity(.7),
                ),
              ),
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Username',
                    style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(.7),
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.sansFont),
                  ),
                  SizedBox(height: 5.h),
                  TextField(
                    // controller: _searchController,
                    style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(.7),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Enter email address',
                      hintStyle: TextStyle(
                        color: AppColors.whiteColor.withOpacity(.7),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.whiteColor.withOpacity(.2),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.blackShadeColor,
                      suffixIcon: Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        color: AppColors.whiteColor.withOpacity(.7),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Location',
                    style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(.7),
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.sansFont),
                  ),
                  SizedBox(height: 5.h),
                  TextField(
                    // controller: _searchController,
                    readOnly: true,
                    style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(.7),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Click to enter location',
                      hintStyle: TextStyle(
                        color: AppColors.whiteColor.withOpacity(.7),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: AppColors.whiteColor.withOpacity(.2),
                          width: 2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                      ),
                      filled: true,
                      fillColor: AppColors.blackShadeColor,
                      suffixIcon: IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.location_on_outlined,
                          color: AppColors.whiteColor.withOpacity(.7),
                        ),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15.h),
              Hero(
                tag: 'submit_button',
                transitionOnUserGestures: true,
                child: CustomBtn(
                  text: 'Set up',
                  btnColor: AppColors.primaryColor,
                  textColor: AppColors.blackColor,
                  borderRadius: BorderRadius.circular(10),
                  fontSize: 14.sp,
                  onPressed: () {
                    AppHelpers.moveTo(
                        const SetupAccountSuccessScreen(), context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
