import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/providers/provider_variables.dart';
import '../../../../core/widgets/custom_btns.dart';
import '../controllers/auth_controller.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'select_username.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final AuthController _authController = AuthController();
  @override
  void initState() {
    AppHelpers.changeBottomBarColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    final accountCreatingLoading =
        ref.watch(accountCreatingLoadingNotifierProvider);
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
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: SvgPicture.asset(
                      AppAssets.arrowIOSBoldIcon,
                      colorFilter: const ColorFilter.mode(
                          AppColors.whiteColor, BlendMode.srcIn),
                      width: 15.w,
                      height: 15.h,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Sign up',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFamily: AppFonts.sansFont,
                          color: AppColors.whiteColor,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 25.h),
              Text(
                'Sign up with one of the following options',
                style: TextStyle(
                  color: AppColors.whiteColor.withOpacity(.7),
                ),
              ),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      UserCredential? credentials =
                          await _authController.signInWithGoogle();
                      if (credentials != null &&
                          credentials.user!.email != null) {
                        ref
                            .read(
                                accountCreatingLoadingNotifierProvider.notifier)
                            .change(true);
                        final data = await ref
                            .read(createAccountListenerProvider.notifier)
                            .createAccount(
                                userId: credentials.user!.uid,
                                accountTye: 'google',
                                email: credentials.user!.email!,
                                name: credentials.user!.displayName!);
                        if (data) {
                          ref
                              .read(accountCreatingLoadingNotifierProvider
                                  .notifier)
                              .change(false);
                          AppHelpers.moveTo(
                              // ignore: use_build_context_synchronously
                              const SelectUsernameAndLocation(), context);
                        } else {
                          _authController.signOutFromGoogle();
                          ref
                              .read(accountCreatingLoadingNotifierProvider
                                  .notifier)
                              .change(false);
                        }
                      }
                    },
                    child: Container(
                      width: width * .43,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      decoration: BoxDecoration(
                        color: AppColors.blackShadeColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.whiteColor.withOpacity(.4)),
                      ),
                      child: SvgPicture.asset(
                        AppAssets.googleBoldIcon,
                        colorFilter: const ColorFilter.mode(
                            AppColors.whiteColor, BlendMode.srcIn),
                        width: 15.w,
                        height: 15.h,
                      ),
                    ),
                  ),
                  Container(
                    width: width * .43,
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    decoration: BoxDecoration(
                      color: AppColors.blackShadeColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: AppColors.whiteColor.withOpacity(.4)),
                    ),
                    child: SvgPicture.asset(
                      AppAssets.facebookBoldIcon,
                      colorFilter: const ColorFilter.mode(
                          AppColors.whiteColor, BlendMode.srcIn),
                      width: 15.w,
                      height: 15.h,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Name',
                    style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(.7),
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.sansFont),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          // controller: _searchController,
                          style: TextStyle(
                            color: AppColors.whiteColor.withOpacity(.7),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter name',
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
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Email',
                    style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(.7),
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.sansFont),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
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
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Password',
                    style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(.7),
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.sansFont),
                  ),
                  SizedBox(height: 5.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          // controller: _searchController,
                          style: TextStyle(
                            color: AppColors.whiteColor.withOpacity(.7),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter password',
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
                                CupertinoIcons.eye_slash,
                                color: AppColors.whiteColor.withOpacity(.7),
                              ),
                            ),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 30.h),
              if (accountCreatingLoading)
                const Align(
                    alignment: Alignment.center,
                    child: CupertinoActivityIndicator(
                      color: AppColors.primaryColor,
                    ))
              else
                Hero(
                  tag: 'submit_button',
                  transitionOnUserGestures: true,
                  child: CustomBtn(
                    text: 'Create Account',
                    btnColor: AppColors.primaryColor,
                    textColor: AppColors.blackColor,
                    borderRadius: BorderRadius.circular(10),
                    fontSize: 14.sp,
                    onPressed: () {
                      AppHelpers.moveTo(
                          const SelectUsernameAndLocation(), context);
                    },
                  ),
                ),
              SizedBox(height: 10.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(.7),
                      fontSize: 14.sp,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        AppHelpers.moveTo(const LoginScreen(), context);
                      }
                    },
                    child: Text(
                      'Log in',
                      style: TextStyle(
                          color: AppColors.whiteColor, fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
