import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rive/rive.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/widgets/custom_btns.dart';
import '../../../base/presentation/screens/base_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  var riveUrl = 'assets/rive/login_bear.riv';
  SMITrigger? failTrigger, successTrigar;
  SMIBool? isHandsUp, isChecking;
  SMINumber? lookNum;
  StateMachineController? stateMachineController;
  Artboard? artboard;

  @override
  void initState() {
    AppHelpers.changeBottomBarColor();
    initAnimation();
    super.initState();
  }

  void initAnimation() async {
    await RiveFile.initialize();
    rootBundle.load(riveUrl).then((value) {
      RiveFile file = RiveFile.import(value);
      Artboard art = file.mainArtboard;
      stateMachineController =
          StateMachineController.fromArtboard(art, 'Login Machine');
      if (stateMachineController != null) {
        art.addController(stateMachineController!);
        for (var element in stateMachineController!.inputs) {
          if (element.name == 'isChecking') {
            isChecking = element as SMIBool;
          } else if (element.name == 'isHandsUp') {
            isHandsUp = element as SMIBool;
          } else if (element.name == 'trigSuccess') {
            successTrigar = element as SMITrigger;
          } else if (element.name == 'trigFail') {
            failTrigger = element as SMITrigger;
          } else if (element.name == 'numLook') {
            lookNum = element as SMINumber;
          }
        }
      }
      setState(() => artboard = art);
    });
  }

  void lookAround() {
    isChecking?.change(true);
    isHandsUp?.change(false);
    lookNum?.change(0);
    setState(() {
      
    });
  }

  void moveEyes(value) {
    lookNum?.change(value.length.toDouble);
  }

  void handsUpOnEyes() {
    isHandsUp?.change(true);
    isChecking?.change(false);
  }

  void loginClick() {
    isHandsUp?.change(false);
    isChecking?.change(false);
    if (emailController.text == 'email' &&
        passwordController.text == 'password') {
      successTrigar?.fire();

      AppHelpers.moveTo(const BaseScreen(), context);
    } else {
      failTrigger?.fire();
    }
    setState(() {});
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
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
                if (artboard != null)
                  Center(
                    child: Container(
                      height: 200.h,
                      width: 200.h,
                      clipBehavior: Clip.antiAlias,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Rive(artboard: artboard!),
                    ),
                  ),
                SizedBox(height: 10.h),
                Text(
                  'Log in with one of the following options',
                  style: TextStyle(
                    color: AppColors.whiteColor.withOpacity(.7),
                  ),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                        AppAssets.googleBoldIcon,
                        colorFilter: const ColorFilter.mode(
                            AppColors.whiteColor, BlendMode.srcIn),
                        width: 15.w,
                        height: 15.h,
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
                            onChanged: ((value) => moveEyes(value)),
                            onTap: lookAround,
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
                            onTap: handsUpOnEyes,
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
                Hero(
                  tag: 'submit_button',
                  transitionOnUserGestures: true,
                  child: CustomBtn(
                    text: 'Log in',
                    btnColor: AppColors.primaryColor,
                    textColor: AppColors.blackColor,
                    borderRadius: BorderRadius.circular(10),
                    fontSize: 14.sp,
                    onPressed: () {
                      loginClick();
                    },
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
                        AppHelpers.moveTo(const SignupScreen(), context);
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
