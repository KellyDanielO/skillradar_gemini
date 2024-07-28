import 'package:card_swiper/card_swiper.dart';
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
import '../../../../core/widgets/shimmers_widgets.dart';
import '../../../base/presentation/constants/enums.dart';
import '../../../base/presentation/provider/providers.dart';
import '../../../base/presentation/widgets/profile_card.dart';
import '../providers/provider.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  @override
  void initState() {
    loadData();
    super.initState();
  }

  void loadData() async {
    String? accessToken = await AppHelpers().getData('access_token');
    String? refreshToken = await AppHelpers().getData('refresh_token');
    ref
        .read(skillSearchStateNotifierProvider.notifier)
        .change(SkillSearchState.loading);
    final selectedSkills = ref.read(selectedSkillsProvider);

    final globalUser = ref.read(gobalUserNotifierProvider);
    if (globalUser!.skills.isNotEmpty) {
      ref.read(searchListenerProvider.notifier).searchSkill(
            ref: ref,
            skills: selectedSkills.join(','),
            accessToken: accessToken!,
            refreshToken: refreshToken!,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedSkills = ref.watch(selectedSkillsProvider);
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    final skillSearchUsers = ref.watch(skillSearchUsersNotifierProvider);
    final globalUser = ref.watch(gobalUserNotifierProvider);
    final skillSearchState = ref.watch(skillSearchStateNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blackColor,
        leadingWidth: 50.w,
        leading: FittedBox(
          child: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: SvgPicture.asset(
              AppAssets.arrowIOSBoldIcon,
              colorFilter:
                  const ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn),
              width: 15.w,
              height: 15.h,
            ),
          ),
        ),
        title: Text(
          'Skill Search',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 18.sp,
            fontFamily: AppFonts.actionFont,
          ),
        ),
        centerTitle: false,
      ),
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
            if (skillSearchState == SkillSearchState.noUsers)
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
                      style:
                          Theme.of(context).textTheme.headlineMedium!.copyWith(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppFonts.sansFont,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      'No user with your selected skillset around.',
                      style:
                          Theme.of(context).textTheme.headlineSmall!.copyWith(
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
                        text: 'Back',
                        textColor: AppColors.blackColor,
                        btnColor: AppColors.primaryColor,
                        fontSize: 14.sp,
                        onPressed: () {
                          Navigator.pop(context);
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
            if (skillSearchState == SkillSearchState.loading)
              Flexible(
                child: Swiper(
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return FeedShimmer(width: width);
                  },
                  physics: const BouncingScrollPhysics(),
                  viewportFraction: 0.7,
                  scale: 0.9,
                  loop: false,
                  scrollDirection: Axis.vertical,
                  index: 2,
                ),
              ),
            if (skillSearchState == SkillSearchState.done)
              Flexible(
                child: Swiper(
                  containerWidth: height * .6,
                  itemBuilder: (BuildContext context, int index) {
                    final element = skillSearchUsers[index];
                    return ProfileCard(
                      name: element.name,
                      isUrl: element.avatar != null,
                      image: element.avatar != null
                          ? element.avatar!
                          : AppAssets.user,
                      location: element.location!,
                      skill: AppHelpers.findFirstCommonSkillSet(
                          globalUser!.skills, selectedSkills),
                      bio: element.bio ?? 'no bio',
                      joined: AppHelpers.timeAgo(element.dateJoined),
                      action: () {},
                      user: element,
                    );
                  },
                  physics: const BouncingScrollPhysics(),
                  itemCount: skillSearchUsers.length,
                  viewportFraction: 0.6,
                  scale: 0.9,
                  loop: false,
                  scrollDirection: Axis.vertical,
                  index: skillSearchUsers.length >= 2 ? 1 : 0,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
