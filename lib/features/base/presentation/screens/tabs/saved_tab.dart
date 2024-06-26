import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/assets.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/constants/skills.dart';
import '../../widgets/profile_card.dart';

class SavedTab extends ConsumerWidget {
  final double width;
  final double height;
  const SavedTab({super.key, required this.width, required this.height});

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
        SizedBox(height: 15.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: List.generate(skillList.length, (index) {
                return Container(
                  margin: EdgeInsets.only(right: 10.w),
                  child: Chip(
                    backgroundColor:
                        index == 0 ? AppColors.whiteColor : AppColors.blackColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    label: Text(
                      skillList[index],
                      style: TextStyle(
                        color: index == 0
                            ? AppColors.blackColor
                            : AppColors.whiteColor,
                        fontFamily: AppFonts.sansFont,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Flexible(
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              final element = profiles[index];
              return ProfileCard(
                name: element.name,
                image: element.image,
                location: element.location,
                skill: element.skill,
                bio: element.bio,
                joined: element.joined,
                action: element.action,
              );
            },
            itemCount: profiles.length,
            viewportFraction: 0.8,
            scale: 0.9,
            loop: false,
          ),
        ),
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
