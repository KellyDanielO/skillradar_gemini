import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:skillradar/core/helpers/app_extensions.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/router.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/providers/provider_variables.dart';
import '../../../utils/presentation/providers/utility_provider.dart';
import '../../../utils/presentation/screens/image_viewer.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final bool me;
  const ProfileScreen({super.key, required this.me});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool fileSelected = false;
  File? selectedFile;
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
  void initState() {
    AppHelpers.changeBottomBarColor();
    super.initState();
  }

  void uploadCoverPhoto() async {
    if (widget.me) {
      final data = await AppHelpers().pickAssets(
          maxCount: 1, requestType: RequestType.image, context: context);
      if (data != null) {
        final file = await data.first.file;
        setState(() {
          fileSelected = true;
          selectedFile = file;
        });
        String? accessToken = await AppHelpers().getData('access_token');
        String? refreshToken = await AppHelpers().getData('refresh_token');
        final user =
            await ref.read(utilityListenerProvider.notifier).uploadCoverPhoto(
                  coverPhoto: selectedFile!,
                  accessToken: accessToken!,
                  refreshToken: refreshToken!,
                );
        ref.read(gobalUserNotifierProvider.notifier).setUser(user);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    final transH = AppLocalizations.of(context)!;
    final user = ref.watch(gobalUserNotifierProvider);
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
          '@${user!.username}',
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
              onPressed: () {
                AppHelpers.goNamed(
                    routeName: AppRouter.menuScreen, context: context);
              },
              icon: SvgPicture.asset(
                AppAssets.menuOutlinedIcon,
                colorFilter: const ColorFilter.mode(
                    AppColors.whiteColor, BlendMode.srcIn),
                width: 15.w,
                height: 15.h,
              ),
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
                                  ImageViewer(
                                    heroTag: 'ace_background',
                                    image: user.coverPhoto ??
                                        AppAssets.background2,
                                    isNetwork: user.coverPhoto != null,
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
                                  child: fileSelected
                                      ? Image.file(
                                          selectedFile!,
                                          fit: BoxFit.cover,
                                        )
                                      : user.coverPhoto != null
                                          ? Image.network(
                                              user.coverPhoto!,
                                              fit: BoxFit.cover,
                                              loadingBuilder:
                                                  (BuildContext context,
                                                      Widget child,
                                                      ImageChunkEvent?
                                                          loadingProgress) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                } else {
                                                  return Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                      color: AppColors
                                                          .primaryColor,
                                                      value: loadingProgress
                                                                  .expectedTotalBytes !=
                                                              null
                                                          ? loadingProgress
                                                                  .cumulativeBytesLoaded /
                                                              loadingProgress
                                                                  .expectedTotalBytes!
                                                          : null,
                                                    ),
                                                  );
                                                }
                                              },
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object error,
                                                      StackTrace? stackTrace) {
                                                return const Center(
                                                  child: Icon(
                                                    Icons.error,
                                                    color: Colors.red,
                                                  ),
                                                );
                                              },
                                            )
                                          : Image.asset(
                                              AppAssets.background1,
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
                              onPressed: uploadCoverPhoto,
                              icon: widget.me
                                  ? Icon(
                                      Icons.change_circle_outlined,
                                      color: AppColors.whiteColor,
                                      size: 20.sp,
                                    )
                                  : SvgPicture.asset(
                                      AppAssets.bookmarkOutlinedIcon,
                                      colorFilter: const ColorFilter.mode(
                                          AppColors.whiteColor,
                                          BlendMode.srcIn),
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
                                  ImageViewer(
                                    image: user.avatar ?? AppAssets.avatar1,
                                    heroTag: 'ace_profile',
                                    isNetwork: user.avatar != null,
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
                              child: Hero(
                                tag: 'ace_profile',
                                transitionOnUserGestures: true,
                                child: Container(
                                  width: 86.w,
                                  height: 86.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.greyColor.withOpacity(.5),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: user.avatar != null
                                      ? Image.network(
                                          user.avatar!,
                                          fit: BoxFit.cover,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(
                                                  color: AppColors.primaryColor,
                                                  value: loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                                ),
                                              );
                                            }
                                          },
                                          errorBuilder: (BuildContext context,
                                              Object error,
                                              StackTrace? stackTrace) {
                                            return const Center(
                                              child: Icon(
                                                Icons.error,
                                                color: Colors.red,
                                              ),
                                            );
                                          },
                                        )
                                      : Image.asset(
                                          AppAssets.avatar1,
                                          fit: BoxFit.cover,
                                        ),
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
                        user.name,
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
                              user.location!,
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
                          user.skills.length,
                          (index) {
                            return Chip(
                              backgroundColor: index == 0
                                  ? AppColors.whiteColor
                                  : AppColors.blackColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              label: Text(
                                user.skills[index].name,
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
                  user.featured.isEmpty
                      ? const SizedBox.shrink()
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Featured Images',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: AppFonts.sansFont,
                                    color: AppColors.whiteColor,
                                  ),
                            ),
                            SizedBox(height: 10.h),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(backgroundAvatar.length,
                                    (index) {
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
                                            borderRadius:
                                                BorderRadius.circular(10)),
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
                      Text(
                        user.bio ?? 'No bio',
                        style: const TextStyle(
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
              child: GestureDetector(
                onTap: () => widget.me
                    ? AppHelpers.goNamed(
                        routeName: AppRouter.editProfileScreen,
                        context: context)
                    : _showBottomSheet(context, width, height),
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
                            widget.me
                                ? 'Edit'
                                : transH.connect.capitalizeFirst.toString(),
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
