import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/router.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/providers/provider_variables.dart';
import '../../../../core/widgets/custom_btns.dart';
import '../../../../core/widgets/error_widgets.dart';
import '../providers/auth_provider.dart';

class SelectUsernameAndLocation extends ConsumerStatefulWidget {
  const SelectUsernameAndLocation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectUsernameAndLocationState();
}

class _SelectUsernameAndLocationState
    extends ConsumerState<SelectUsernameAndLocation> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  bool locating = false;
  bool isUsername = false;
  @override
  void initState() {
    AppHelpers.changeBottomBarColor();
    super.initState();
  }

  void setUpAccount() async {
    if (usernameController.value.text.isNotEmpty &&
        locationController.value.text.isNotEmpty && isUsername) {
      ref.read(accountSetUpLoadingNotifierProvider.notifier).change(true);
      final data = await ref
          .read(authListenerProvider.notifier)
          .setUpAccount(
              location: locationController.value.text,
              username: usernameController.value.text);
      if (data) {
        ref.read(accountSetUpLoadingNotifierProvider.notifier).change(false);
        if (mounted) {
          AppHelpers.goReplacedNamed(routeName: AppRouter.setUpScreen, context: context);
        }
      } else {
        ref.read(accountSetUpLoadingNotifierProvider.notifier).change(false);
      }
    } else {
      errorWidget(message: 'all fields are required or invalid username');
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    final accountSetupLoading = ref.watch(accountSetUpLoadingNotifierProvider);
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
                    controller: usernameController,
                    style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(.7),
                    ),
                    onChanged: (value) {
                      setState(() {
                        isUsername = AppHelpers.isValidUsername(value);
                      });
                    },
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
                        color: isUsername ? AppColors.primaryColor : AppColors.whiteColor.withOpacity(.7),
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
                    controller: locationController,
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
                      suffixIcon: locating
                          ? const CupertinoActivityIndicator(
                              color: AppColors.primaryColor,
                            )
                          : IconButton(
                              onPressed: () async {
                                setState(() {
                                  locating = true;
                                });
                                final location =
                                    await AppHelpers.getCompleteAddress();
                                setState(() {
                                  locationController.text = location;
                                  locating = false;
                                });
                              },
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
              if (accountSetupLoading)
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
                      text: 'Set up',
                      btnColor: AppColors.primaryColor,
                      textColor: AppColors.blackColor,
                      borderRadius: BorderRadius.circular(10),
                      fontSize: 14.sp,
                      onPressed: setUpAccount),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
