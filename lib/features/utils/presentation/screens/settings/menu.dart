import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/assets.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/constants/router.dart';
import '../../../../../core/helpers/functions.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  @override
  void initState() {
    AppHelpers.changeBottomBarColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Navigator.canPop(context)
            ? IconButton(
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                padding: AppHelpers.isTablet()
                    ? const EdgeInsets.only(left: 10)
                    : const EdgeInsets.all(0),
                icon: SvgPicture.asset(
                  AppAssets.arrowIOSBoldIcon,
                  colorFilter: const ColorFilter.mode(
                      AppColors.whiteColor, BlendMode.srcIn),
                  width: 15.w,
                  height: 15.h,
                ),
              )
            : null,
        centerTitle: true,
        title: Text(
          'Menu',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.bold,
            fontSize: AppHelpers.isTablet() ? 12.sp : 18.sp,
            fontFamily: AppFonts.actionFont,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: AppHelpers.isTablet() ? 40.w : 20.w),
        width: width,
        height: height * .9,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: height * .03),
              Text(
                'Account Settings',
                style: TextStyle(
                  color: AppColors.greyColor,
                  fontFamily: AppFonts.actionFont,
                  fontSize: width * .01 + 12,
                ),
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppAssets.skillIcon,
                    colorFilter: const ColorFilter.mode(
                        AppColors.whiteColor, BlendMode.srcIn),
                    width: 15.w,
                    height: 15.h,
                  ),
                ),
                title: Text(
                  'Skills',
                  style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(.7),
                    fontFamily: AppFonts.sansFont,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.whiteColor,
                ),
                onTap: () {
                  AppHelpers.goNamed(
                      routeName: AppRouter.addSkillsScreen, context: context);
                },
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.people_outline_outlined,
                    color: AppColors.whiteColor,
                  ),
                ),
                title: Text(
                  'Socials',
                  style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(.7),
                    fontFamily: AppFonts.sansFont,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.whiteColor,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_outlined,
                    color: AppColors.whiteColor,
                  ),
                ),
                title: Text(
                  'Featured Images',
                  style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(.7),
                    fontFamily: AppFonts.sansFont,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.whiteColor,
                ),
                onTap: () {
                  AppHelpers.goNamed(routeName: AppRouter.addFeaturedScreen, context: context);
                },
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    CupertinoIcons.padlock,
                    color: AppColors.whiteColor,
                  ),
                ),
                title: Text(
                  'Change password',
                  style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(.7),
                    fontFamily: AppFonts.sansFont,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.whiteColor,
                ),
                onTap: () {},
              ),
              SizedBox(height: height * .02),
              Text(
                'Preferences',
                style: TextStyle(
                  color: AppColors.greyColor,
                  fontFamily: AppFonts.actionFont,
                  fontSize: width * .01 + 12,
                ),
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.language_outlined,
                    color: AppColors.whiteColor,
                  ),
                ),
                title: Text(
                  'Change language',
                  style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(.7),
                      fontFamily: AppFonts.sansFont,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.whiteColor,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    AppAssets.bellOutlinedIcon,
                    colorFilter: const ColorFilter.mode(
                        AppColors.whiteColor, BlendMode.srcIn),
                    width: 18.w,
                    height: 18.h,
                  ),
                ),
                title: Text(
                  'Notifications',
                  style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(.7),
                      fontFamily: AppFonts.sansFont,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.whiteColor,
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.remove_red_eye_outlined,
                    color: AppColors.whiteColor,
                  ),
                ),
                title: Text(
                  'Visibility',
                  style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(.7),
                      fontFamily: AppFonts.sansFont,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.whiteColor,
                ),
                onTap: () {},
              ),
              SizedBox(height: height * .02),
              Text(
                'Others',
                style: TextStyle(
                  color: AppColors.greyColor,
                  fontFamily: AppFonts.actionFont,
                  fontSize: width * .01 + 12,
                ),
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.document_scanner_outlined,
                    color: AppColors.whiteColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.whiteColor,
                ),
                title: Text(
                  'Privacy Policy',
                  style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(.7),
                      fontFamily: AppFonts.sansFont,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                onTap: () {},
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.document_scanner_outlined,
                    color: AppColors.whiteColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.whiteColor,
                ),
                title: Text(
                  'Terms and Conditions',
                  style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(.7),
                    fontFamily: AppFonts.sansFont,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                onTap: () {},
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.info_outline,
                    color: AppColors.whiteColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.whiteColor,
                ),
                title: Text(
                  "About",
                  style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(.7),
                      fontFamily: AppFonts.sansFont,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                onTap: () {},
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.feedback_outlined,
                    color: AppColors.whiteColor,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.whiteColor,
                ),
                title: Text(
                  'Feedback',
                  style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(.7),
                      fontFamily: AppFonts.sansFont,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                onTap: () {
                  // AppHelpers.launchUrlNow('tabtrac.business@gmail.com', 'Feedback on Tabtrac', '');
                },
              ),
              ListTile(
                leading: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withOpacity(.2),
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.logout_outlined,
                    color: AppColors.whiteColor,
                  ),
                ),
                title: Text(
                  'Logout',
                  style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(.7),
                      fontFamily: AppFonts.sansFont,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        title: Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: width * .01 + 18,
                            fontFamily: AppFonts.actionFont,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        content: Text(
                          'Are you sure, you wan to logout!',
                          style: TextStyle(
                            fontSize: width * .01 + 16,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                                fontSize: width * .01 + 14,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              AppHelpers().logout().then((data) {
                                AppHelpers.goReplacedNamed(
                                    routeName: AppRouter.splashScreen,
                                    context: context);
                              });
                            },
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                color: AppColors.redColor,
                                fontSize: width * .01 + 14,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
