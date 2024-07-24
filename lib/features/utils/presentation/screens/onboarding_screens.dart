
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/router.dart';
import '../../../../core/constants/sizes.dart';
import '../../../../core/helpers/functions.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {

  late String image;

  final List<String> _imageUrls = [
    'assets/images/onboarding1.jpg',
    'assets/images/onboarding2.jpg',
    'assets/images/onboarding3.jpg',
  ];

  @override
  void initState() {
    super.initState();
    AppHelpers.changeBottomBarColor();

    image = AppHelpers.getRandomValue(_imageUrls);
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preloadImages();
  }

  void _preloadImages() async {
    for (String imageUrl in _imageUrls) {
      await precacheImage(AssetImage(imageUrl), context);
    }
  }



  @override
  Widget build(BuildContext context) {
    double height = ScreenUtil().screenHeight;
    double width = ScreenUtil().screenWidth;
    final transH = AppLocalizations.of(context)!;
    return Scaffold(
      body: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(image),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomRight,
              colors: [
                Colors.transparent,
                Colors.black,
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 200.w,
                  height: 200.w,
                  child: Image.asset(
                    AppAssets.logo3,
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  transH.welcomeMsgTitle,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: AppSizes.bigSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  transH.welcomeMsgBody,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: AppSizes.mediumSize,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                InkWell(
                  onTap: () {
                    AppHelpers.goNamed(
                        routeName: AppRouter.loginScreen, context: context);
                  },
                  child: Container(
                    width: width,
                    decoration: BoxDecoration(
                      color: AppColors.whiteColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              transH.getStarted,
                              style: const TextStyle(
                                color: AppColors.blackColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                              color: AppColors.blackColor,
                              borderRadius: BorderRadius.circular(50)),
                          child: Icon(
                            CupertinoIcons.arrow_right,
                            color: AppColors.whiteColor,
                            size: 18.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
