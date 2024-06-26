import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:skillradar/core/helpers/app_extensions.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/helpers/functions.dart';
import '../../../utils/presentation/screens/image_viewer.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  List<String> userSkills = ['Photograher', 'Fashionista'];
  void _showBottomSheet(BuildContext context, double width, double height) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return BottomSheetContent(
          width: width,
          height: height,
        );
      },
    );
  }

  List<String> backgroundAvatar = [
    AppAssets.background3,
    AppAssets.background1,
    AppAssets.background2,
  ];

  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    final transH = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
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
          '@Ace',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 18.sp,
            fontFamily: AppFonts.actionFont,
          ),
        ),
        centerTitle: true,
        actions: [
          Container(            
            margin: EdgeInsets.only(right: 10.w),
            child: IconButton(
              onPressed: () {},
              icon: Icon(CupertinoIcons.bars, color: AppColors.whiteColor,)
            ),
          ),
        ],
      ),
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Stack(
          children: [
            Positioned.fill(
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 5.h),
                  SizedBox(
                    width: width,
                    height: height * .31,
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: GestureDetector(
                            onTap: () {
                              AppHelpers.moveTo(
                                  const ImageViewer(
                                    image: AppAssets.background2,
                                    heroTag: 'ace_background',
                                  ),
                                  context);
                            },
                            child: SizedBox(
                              width: width * .88,
                              height: height * .25,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Hero(
                                  tag: 'ace_background',
                                  transitionOnUserGestures: true,
                                  child: Image.asset(
                                    AppAssets.background2,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.greyColor.withOpacity(.3),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            margin: EdgeInsets.only(right: 10.w),
                            child: IconButton(
                              onPressed: () {},
                              icon: SvgPicture.asset(
                                AppAssets.bookmarkOutlinedIcon,
                                colorFilter: const ColorFilter.mode(
                                    AppColors.whiteColor, BlendMode.srcIn),
                                width: 15.w,
                                height: 15.h,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: -10,
                          left: (width - 100.w) / 2 - 20.w,
                          child: GestureDetector(
                            onTap: () {
                              AppHelpers.moveTo(
                                  const ImageViewer(
                                    image: AppAssets.avatar1,
                                    heroTag: 'ace_profile',
                                  ),
                                  context);
                            },
                            child: Container(
                              width: 100.w,
                              height: 100.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color: AppColors.blackColor, width: 8),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: const Hero(
                                tag: 'ace_profile',
                                transitionOnUserGestures: true,
                                child: CircleAvatar(
                                  backgroundImage:
                                      AssetImage(AppAssets.avatar1),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 15.h),
                  Column(
                    children: <Widget>[
                      Text(
                        'Ace',
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppFonts.sansFont,
                                  color: AppColors.whiteColor,
                                ),
                      ),
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.location_on_outlined,
                            color: AppColors.whiteColor,
                            size: 20.sp,
                          ),
                          SizedBox(width: 10.w),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: width * .6),
                            child: Text(
                              'Port Harcourt, Nigeria',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: AppFonts.interFont,
                                    color: AppColors.whiteColor,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        transH.skills.capitalizeFirst.toString(),
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppFonts.sansFont,
                                  color: AppColors.whiteColor,
                                ),
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 8.0, // Gap between adjacent items
                        runSpacing: 4.0, // Gap between lines
                        children: List.generate(
                          userSkills.length,
                          (index) {
                            return Chip(
                              backgroundColor: index == 0
                                  ? AppColors.whiteColor
                                  : AppColors.blackColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              label: Text(
                                userSkills[index],
                                style: TextStyle(
                                  color: index == 0
                                      ? AppColors.blackColor
                                      : AppColors.whiteColor,
                                  fontFamily: AppFonts.sansFont,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Featured Images',
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppFonts.sansFont,
                                  color: AppColors.whiteColor,
                                ),
                      ),
                      SizedBox(height: 10.h),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children:
                              List.generate(backgroundAvatar.length, (index) {
                            return Container(
                              margin: EdgeInsets.only(right: 10.w),
                              child: InkWell(
                                onTap: () {
                                  AppHelpers.moveTo(
                                      ImageViewer(
                                        image: backgroundAvatar[index],
                                        heroTag: backgroundAvatar[index],
                                      ),
                                      context);
                                },
                                child: Container(
                                  width: width * .75,
                                  height: height * .15,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
                                  clipBehavior: Clip.antiAlias,
                                  child: Hero(
                                    tag: backgroundAvatar[index],
                                    transitionOnUserGestures: true,
                                    child: Image.asset(
                                      backgroundAvatar[index],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        transH.about.capitalizeFirst.toString(),
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: AppFonts.sansFont,
                                  color: AppColors.whiteColor,
                                ),
                      ),
                      SizedBox(height: 10.h),
                      const Text(
                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                        style: TextStyle(
                          color: AppColors.greyColor,
                        ),
                      ),
                      SizedBox(height: 100.h),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 10,
              child: InkWell(
                onTap: () => _showBottomSheet(context, width, height),
                child: Container(
                  width: width - 40.w,
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
                            transH.connect.capitalizeFirst.toString(),
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
                          borderRadius: BorderRadius.circular(50),
                        ),
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
            ),
          ],
        ),
      ),
    );
  }
}

class BottomSheetContent extends StatelessWidget {
  final double width;
  final double height;
  const BottomSheetContent(
      {super.key, required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: const BoxDecoration(
        color: AppColors.blackShadeColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      child: Column(
        children: [
          SizedBox(height: 10.h),
          Text(
            'Connect Via',
            style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.sansFont),
          ),
          SizedBox(height: 10.h),
          SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(maxHeight: height * .4),
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 16.0, // Gap between adjacent items
                runSpacing: 16.0, // Gap between lines
                children: List.generate(
                  SocialIcons.all.length,
                  (index) {
                    return SizedBox(
                      width: 50.w,
                      height: 50.h,
                      child: Image.asset(SocialIcons.all[index]),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
