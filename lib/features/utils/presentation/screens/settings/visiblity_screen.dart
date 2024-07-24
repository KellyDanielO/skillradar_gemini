import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/assets.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/providers/provider_variables.dart';

class VisiblityScreen extends ConsumerStatefulWidget {
  const VisiblityScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _VisiblityScreenState();
}

class _VisiblityScreenState extends ConsumerState<VisiblityScreen> {
  bool showPhoneNumber = true,
      showEmail = true,
      showProfile = true,
      dataChanged = false,
      addingSkillsLoading = false;
  @override
  void initState() {
    final user = ref.read(gobalUserNotifierProvider);
    showPhoneNumber = user!.showPhoneNumber;
    showEmail = user.showEmail;
    showProfile = user.showProfile;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    ref.watch(gobalUserNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        leadingWidth: 50.w,
        leading: FittedBox(
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: SvgPicture.asset(
              AppAssets.arrowIOSBoldIcon,
              colorFilter:
                  const ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn),
              width: 15.w,
              height: 15.h,
            ),
          ),
        ),
        title: Text(
          'Visibility',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 18.sp,
            fontFamily: AppFonts.actionFont,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: dataChanged == false
          ? null
          : FloatingActionButton(
              onPressed: () {},
              backgroundColor: AppColors.primaryColor,
              shape: const CircleBorder(),
              child: addingSkillsLoading
                  ? const CupertinoActivityIndicator()
                  : const Icon(
                      Icons.check,
                    ),
            ),
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Show Email',
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 16.sp,
                  fontFamily: AppFonts.interFont,
                ),
              ),
              trailing: Switch(
                value: showEmail,
                activeColor: AppColors.primaryColor,
                onChanged: (value) {
                  setState(() {
                    showEmail = value;
                    dataChanged = true;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                'Show Phonenumber',
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 16.sp,
                  fontFamily: AppFonts.interFont,
                ),
              ),
              trailing: Switch(
                value: showPhoneNumber,
                activeColor: AppColors.primaryColor,
                onChanged: (value) {
                  setState(() {
                    showPhoneNumber = value;
                    dataChanged = true;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(
                'Show Profile',
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 16.sp,
                  fontFamily: AppFonts.interFont,
                ),
              ),
              trailing: Switch(
                value: showProfile,
                activeColor: AppColors.primaryColor,
                onChanged: (value) {
                  setState(() {
                    showProfile = value;
                    dataChanged = true;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
