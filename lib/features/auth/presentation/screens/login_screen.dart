import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skillradar/core/helpers/app_extensions.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/router.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/providers/provider_variables.dart';
import '../../../../core/widgets/custom_btns.dart';
import '../../../../core/widgets/error_widgets.dart';
import '../controllers/auth_controller.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final AuthController _authController = AuthController();
  bool obSecure = true;
  @override
  void initState() {
    AppHelpers.changeBottomBarColor();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void googleAuth() async {
    final loading = ref.read(accountCreatingLoadingNotifierProvider);
    if (!loading) {
      ref.read(accountCreatingLoadingNotifierProvider.notifier).change(true);
      UserCredential? credentials = await _authController.signInWithGoogle();

      if (credentials != null && credentials.user!.email != null) {
        final data = await ref.read(authListenerProvider.notifier).loginAccount(
            userId: credentials.user!.uid, email: credentials.user!.email!);
        if (data == 'set-up') {
          ref
              .read(accountCreatingLoadingNotifierProvider.notifier)
              .change(false);
          if (mounted) {
            AppHelpers.goReplacedNamed(
                routeName: AppRouter.setUpScreen, context: context);
          }
        } else if (data == 'done') {
          ref
              .read(accountCreatingLoadingNotifierProvider.notifier)
              .change(false);
          if (mounted) {
            AppHelpers.goReplacedNamed(
                routeName: AppRouter.splashScreen, context: context);
          }
        } else {
          _authController.signOutFromGoogle();
          ref
              .read(accountCreatingLoadingNotifierProvider.notifier)
              .change(false);
        }
      } else {
        ref.read(accountCreatingLoadingNotifierProvider.notifier).change(false);
      }
    }
  }

  void emailSignIn() async {
    if (!emailController.value.text.isEmail) {
      errorWidget(message: 'invalid email');
    } else {
      if (emailController.value.text.isNotEmpty &&
          passwordController.value.text.isNotEmpty) {
        ref.read(accountCreatingLoadingNotifierProvider.notifier).change(true);
        UserCredential? credentials = await _authController.signInEmailPassword(
            email: emailController.value.text,
            password: passwordController.value.text);
        if (credentials != null && credentials.user!.email != null) {
          final data = await ref
              .read(authListenerProvider.notifier)
              .loginAccount(
                  userId: credentials.user!.uid,
                  email: credentials.user!.email!);
          if (data == 'set-up') {
            ref
                .read(accountCreatingLoadingNotifierProvider.notifier)
                .change(false);
            if (mounted) {
              AppHelpers.goReplacedNamed(
                  routeName: AppRouter.setUpScreen, context: context);
            }
          } else if (data == 'done') {
            ref
                .read(accountCreatingLoadingNotifierProvider.notifier)
                .change(false);
            if (mounted) {
              AppHelpers.goReplacedNamed(
                  routeName: AppRouter.splashScreen, context: context);
            }
          } else {
            _authController.signOutFromGoogle();
            ref
                .read(accountCreatingLoadingNotifierProvider.notifier)
                .change(false);
          }
        } else {
          ref
              .read(accountCreatingLoadingNotifierProvider.notifier)
              .change(false);
        }
      } else {
        errorWidget(message: 'all fields are required');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    final accountCreatingLoading =
        ref.watch(accountCreatingLoadingNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: SvgPicture.asset(
            AppAssets.arrowIOSBoldIcon,
            colorFilter:
                const ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn),
            width: 15.w,
            height: 15.h,
          ),
        ),
        centerTitle: false,
        title: Text(
          'Log in',
          style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.w600,
                fontFamily: AppFonts.sansFont,
                color: AppColors.whiteColor,
              ),
        ),
      ),
      body: SafeArea(
        child: Container(
          width: width,
          height: height,
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 25.h),
                GestureDetector(
                  onTap: googleAuth,
                  child: Container(
                    width: width,
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 20.w),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: AppColors.whiteColor.withOpacity(.4),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 30.w,
                          height: 30.w,
                          child: Image.asset(
                            AppAssets.google,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                            color: AppColors.whiteColor.withOpacity(.7),
                            fontWeight: FontWeight.w600,
                            fontFamily: AppFonts.sansFont,
                          ),
                        ),
                      ],
                    ),
                  ),
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
                            controller: emailController,
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
                            controller: passwordController,
                            style: TextStyle(
                              color: AppColors.whiteColor.withOpacity(.7),
                            ),
                            obscureText: obSecure,
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
                                onPressed: () {
                                  setState(() {
                                    obSecure = !obSecure;
                                  });
                                },
                                icon: Icon(
                                  obSecure
                                      ? CupertinoIcons.eye_slash
                                      : CupertinoIcons.eye,
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
                SizedBox(height: 5.h),
                Align(
                  alignment: Alignment.bottomRight,
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                          color: AppColors.whiteColor.withOpacity(.7)),
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                if (accountCreatingLoading)
                  const Align(
                    alignment: Alignment.center,
                    child: CupertinoActivityIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                else
                  Hero(
                    tag: 'submit_button',
                    transitionOnUserGestures: true,
                    child: CustomBtn(
                      text: 'Log in',
                      btnColor: AppColors.primaryColor,
                      textColor: AppColors.blackColor,
                      borderRadius: BorderRadius.circular(10),
                      fontSize: 14.sp,
                      onPressed: emailSignIn,
                    ),
                  ),
                SizedBox(height: 10.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(.7),
                        fontSize: 14.sp,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        AppHelpers.goNamed(
                            routeName: AppRouter.registerScreen,
                            context: context);
                      },
                      child: Text(
                        'Sign up',
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
      ),
    );
  }
}
