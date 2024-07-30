import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/assets.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../../core/providers/provider_variables.dart';
import '../../../../../core/widgets/shimmers_widgets.dart';
import '../../constants/enums.dart';
import '../../provider/providers.dart';
import '../../widgets/profile_card.dart';

class SavedTab extends ConsumerWidget {
  final double width;
  final double height;
  const SavedTab({super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedProfileState = ref.watch(savedProfileStateNotifierProvider);
    final savedProfileUsers = ref.watch(savedUsersNotifierProvider);
    final globalUser = ref.watch(gobalUserNotifierProvider);
    return Column(
      children: <Widget>[
        SizedBox(height: 10.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Saved Profiles',
                style: TextStyle(
                  color: AppColors.whiteColor.withOpacity(.8),
                  fontSize: 20.sp,
                  fontFamily: AppFonts.actionFont,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.whiteColor.withOpacity(.7),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: IconButton(
                  onPressed: () {},
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
            'Profiles which you saved across all skills !',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.sansFont),
          ),
        ),
        SizedBox(height: 20.h),
        if (savedProfileState == SavedProfileState.noUser || savedProfileUsers.isEmpty)
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
                  'No saved profile found!',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.sansFont,
                      ),
                )
              ],
            ),
          ),
        if (savedProfileState == SavedProfileState.loading)
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
        if (savedProfileState == SavedProfileState.none || savedProfileUsers.isNotEmpty)
          Flexible(
            key: const ValueKey(4),
            child: Swiper(
              itemBuilder: (BuildContext context, int index) {
                final element = savedProfileUsers[index].profile;
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
                  action: () {
                  },
                  user: element,
                );
              },
              itemCount: savedProfileUsers.length,
              viewportFraction: 0.8,
              scale: 0.9,
              loop: false,
            ),
          ),
        SizedBox(height: 30.h),
        SizedBox(height: height * .12),
      ],
    );
  }
}
