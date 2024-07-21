import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/assets.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/constants/router.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../../core/providers/provider_variables.dart';
import '../../../../../core/widgets/custom_btns.dart';

class HomeTab extends ConsumerWidget {
  final double width;
  final double height;
  const HomeTab({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<UserProfile> profiles = [
      UserProfile(
        name: 'Ace',
        image: AppAssets.avatar1,
        location: 'Nigeria, Port Harcourt',
        skill: 'Photographer',
        bio: 'I\'m a cool guy',
        joined: '10 mons ago',
        action: () {},
      ),
      UserProfile(
        name: 'Kelly Daniel',
        image: AppAssets.avatar2,
        location: 'Nigeria, Port Harcourt',
        skill: 'Flutter Developer',
        bio: 'I\'m a cool guy',
        joined: '10 mons ago',
        action: () {},
      ),
      UserProfile(
        name: 'Livingstone',
        image: AppAssets.avatar3,
        location: 'Nigeria, Port Harcourt',
        skill: 'Flutter Developer',
        bio: 'I\'m a cool guy',
        joined: '10 mons ago',
        action: () {},
      ),
      UserProfile(
        name: 'Victor Chiaka',
        image: AppAssets.avatar4,
        location: 'Nigeria, Port Harcourt',
        skill: 'Flutter Developer',
        bio: 'I\'m a cool guy',
        joined: '10 mons ago',
        action: () {},
      ),
    ];
    final user = ref.watch(gobalUserNotifierProvider);
    return Column(
      children: <Widget>[
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppHelpers.getGreeting(),
                    style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(.5),
                      fontSize: 14.sp,
                    ),
                  ),
                  Text(
                    user!.name,
                    style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(.8),
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.whiteColor.withOpacity(.7),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  onPressed: () {
                    AppHelpers.goNamed(
                        routeName: AppRouter.notificationScreen,
                        context: context);
                  },
                  icon: SvgPicture.asset(
                    AppAssets.bellOutlinedIcon,
                    colorFilter: const ColorFilter.mode(
                        AppColors.whiteColor, BlendMode.srcIn),
                    width: 18.w,
                    height: 18.h,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'Let\'s find that skill, closest to you!',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.sansFont),
          ),
        ),
        SizedBox(height: 30.h),
        if (user.skills.isEmpty)
          Flexible(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  AppAssets.notFound,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10.h),
                Text(
                  'No skill found!',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.sansFont,
                      ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: width * .4,
                  child: CustomBtn(
                    text: 'Add Skills',
                    textColor: AppColors.blackColor,
                    btnColor: AppColors.primaryColor,
                    fontSize: 14.sp,
                    onPressed: () {
                      AppHelpers.goNamed(
                          routeName: AppRouter.addSkillsScreen, context: context);
                    },
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                )
              ],
            ),
          )
        else
          // Flexible(
          //   child: Swiper(
          //     itemCount: 10,
          //     itemBuilder: (BuildContext context, int index) {
          //       return FeedShimmer(width: width);
          //     },
          //     viewportFraction: 0.8,
          //     scale: 0.9,
          //     loop: false,
          //   ),
          // ),
          // Flexible(
          //   child: Swiper(
          //     itemBuilder: (BuildContext context, int index) {
          //       final element = profiles[index];
          //       return ProfileCard(
          //         name: element.name,
          //         image: element.image,
          //         location: element.location,
          //         skill: element.skill,
          //         bio: element.bio,
          //         joined: element.joined,
          //         action: element.action,
          //       );
          //     },
          //     itemCount: profiles.length,
          //     viewportFraction: 0.8,
          //     scale: 0.9,
          //     loop: false,
          //   ),
          // ),
          SizedBox(height: 30.h),
        SizedBox(height: height * .12),
      ],
    );
  }
}

class UserProfile {
  final String name;
  final String image;
  final String location;
  final String skill;
  final String bio;
  final String joined;
  final void Function() action;

  UserProfile({
    required this.name,
    required this.image,
    required this.location,
    required this.skill,
    required this.bio,
    required this.joined,
    required this.action,
  });
}
