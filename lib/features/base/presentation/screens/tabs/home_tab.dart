import 'package:card_swiper/card_swiper.dart';
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
import '../../../../../core/widgets/shimmers_widgets.dart';
import '../../constants/enums.dart';
import '../../provider/providers.dart';
import '../../widgets/profile_card.dart';

class HomeTab extends ConsumerStatefulWidget {
  final double width;
  final double height;
  const HomeTab({super.key, required this.width, required this.height});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeTabState();
}

class _HomeTabState extends ConsumerState<HomeTab> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(gobalUserNotifierProvider);
    double width = widget.width;
    double height = widget.height;
    final feedState = ref.watch(feedStateNotifierProvider);
    final feedUsers = ref.watch(feedUsersNotifierProvider);
    final globalUser = ref.watch(gobalUserNotifierProvider);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: Column(
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
          if (feedState == FeedState.noSkill)
            Flexible(
              key: const ValueKey(1),
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
                            routeName: AppRouter.addSkillsScreen,
                            context: context);
                      },
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                  )
                ],
              ),
            ),
          if (feedState == FeedState.noUsers)
            Flexible(
              key: const ValueKey(2),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    AppAssets.notFound,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Sorry!',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.sansFont,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'No user with your skillest around you.',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 16.sp,
                          fontFamily: AppFonts.sansFont,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    width: width * .4,
                    child: CustomBtn(
                      text: 'Add other skills',
                      textColor: AppColors.blackColor,
                      btnColor: AppColors.primaryColor,
                      fontSize: 14.sp,
                      onPressed: () {
                        AppHelpers.goNamed(
                            routeName: AppRouter.addSkillsScreen,
                            context: context);
                      },
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  SizedBox(
                    width: width * .4,
                    child: OutlinedCustomBtn(
                      text: 'Invite friends',
                      textColor: AppColors.whiteColor,
                      btnColor: AppColors.primaryColor,
                      fontSize: 14.sp,
                      onPressed: () {},
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                    ),
                  ),
                ],
              ),
            ),
          if (feedState == FeedState.loading)
            Flexible(
              key: const ValueKey(3),
              child: Swiper(
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return FeedShimmer(width: width);
                },
                viewportFraction: 0.8,
                scale: 0.9,
                loop: false,
              ),
            ),
          if (feedState == FeedState.none)
            Flexible(
              key: const ValueKey(4),
              child: Swiper(
                itemBuilder: (BuildContext context, int index) {
                  final element = feedUsers[index];
                  return ProfileCard(
                    name: element.name,
                    isUrl: element.avatar != null,
                    image:
                        element.avatar != null ? element.avatar! : AppAssets.user,
                    location: element.location!,
                    skill: AppHelpers.findFirstCommonSkill(globalUser!, element)
                        .name,
                    bio: element.bio ?? 'no bio',
                    joined: AppHelpers.timeAgo(element.dateJoined),
                    action: () {},
                    user: element,
                  );
                },
                itemCount: feedUsers.length,
                viewportFraction: 0.8,
                scale: 0.9,
                loop: false,
              ),
            ),
          SizedBox(height: 30.h),
          SizedBox(height: height * .12),
        ],
      ),
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
