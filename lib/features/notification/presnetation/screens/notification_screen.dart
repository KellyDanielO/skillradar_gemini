import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/router.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/widgets/custom_btns.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  List<UserProfile> profiles = [
    UserProfile(
      name: 'Ace',
      image: AppAssets.user,
      location: 'Nigeria, Port Harcourt',
      skill: 'Photographer',
      bio: 'I\'m a cool guy',
      joined: '10 mons ago',
      action: () {},
    ),
    UserProfile(
      name: 'Kelly Daniel',
      image: AppAssets.user,
      location: 'Nigeria, Port Harcourt',
      skill: 'Flutter Developer',
      bio: 'I\'m a cool guy',
      joined: '10 mons ago',
      action: () {},
    ),
    UserProfile(
      name: 'Livingstone',
      image: AppAssets.user,
      location: 'Nigeria, Port Harcourt',
      skill: 'Flutter Developer',
      bio: 'I\'m a cool guy',
      joined: '10 mons ago',
      action: () {},
    ),
    UserProfile(
      name: 'Victor Chiaka',
      image: AppAssets.user,
      location: 'Nigeria, Port Harcourt',
      skill: 'Flutter Developer',
      bio: 'I\'m a cool guy',
      joined: '10 mons ago',
      action: () {},
    ),
  ];
  List<String> tabs = ['Profile Views', 'Tried Connecting'];
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    return DefaultTabController(
      initialIndex: selectedTab,
      length: tabs.length,
      child: Scaffold(
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
            'Notifications',
            style: TextStyle(
              color: AppColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: AppHelpers.isTablet() ? 12.sp : 18.sp,
              fontFamily: AppFonts.actionFont,
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.primaryColor.withOpacity(.7),
            dividerColor: AppColors.blackColor,
            onTap: (value) {
              setState(() {
                selectedTab = value;
              });
            },
            tabs: List.generate(
              tabs.length,
              (index) => Tab(
                child: Text(
                  tabs[index],
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                        fontFamily: AppFonts.sansFont,
                        color: selectedTab == index
                            ? AppColors.primaryColor.withOpacity(.7)
                            : AppColors.whiteColor,
                      ),
                ),
              ),
            ),
          ),
          scrolledUnderElevation: 0,
          elevation: 0,
        ),
        body: Container(
          width: width,
          height: height,
          padding: EdgeInsets.only(top: 5.h),
          child: ListView.builder(
            itemCount: profiles.length,
            itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(profiles[index].image),
                radius: 30,
              ),
              titleAlignment: ListTileTitleAlignment.center,
              title: Text(
                profiles[index].name,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sansFont,
                      fontSize: 18.sp,
                      color: AppColors.whiteColor,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                profiles[index].skill,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sansFont,
                      color: AppColors.greyColor,
                    ),
              ),
              trailing: FittedBox(
                child: CustomBtn(
                  text: 'View',
                  textColor: AppColors.blackColor,
                  btnColor: AppColors.primaryColor,
                  fontSize: 14.sp,
                  width: width * .25,
                  onPressed: () {
                    AppHelpers.goNamed(
                        routeName: AppRouter.profileScreen, context: context);
                  },
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                ),
              ),
            ),
          ),
        ),
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
