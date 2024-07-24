import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../../core/constants/assets.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/constants/router.dart';
import '../../../../../core/entities/user_entity.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../../core/providers/provider_variables.dart';
import '../../../../../core/widgets/error_widgets.dart';
import '../../../../../core/widgets/network_image.dart';
import '../../providers/utility_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool fileSelected = false;
  bool locating = false;
  File? selectedFile;
  UserEntity? user;

  // utilityListenerProvider
  @override
  void initState() {
    user = ref.read(gobalUserNotifierProvider);
    _nameController.text = user!.name;
    _locationController.text = user!.location!;
    _aboutController.text = user!.bio ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _aboutController.dispose();
    _locationController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void editProfile() async {
    if (_locationController.text.isEmpty || _nameController.text.isEmpty) {
      errorWidget(message: 'Name or Location can\'t be empty!');
    } else {
      String? accessToken = await AppHelpers().getData('access_token');
      String? refreshToken = await AppHelpers().getData('refresh_token');
      ref.read(editProfileLoadingNotifierProvider.notifier).change(true);
      UserEntity? user = await ref
          .read(utilityListenerProvider.notifier)
          .editProfile(
              bio: _aboutController.text,
              name: _nameController.text,
              location: _locationController.text,
              accessToken: accessToken!,
              refreshToken: refreshToken!,
              profileImage: selectedFile);
      if (user != null) {
        ref.read(gobalUserNotifierProvider.notifier).setUser(user);
        if (mounted) {
          Navigator.pop(context);
        }
      }
      ref.read(editProfileLoadingNotifierProvider.notifier).change(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    final editProfileLoading = ref.watch(editProfileLoadingNotifierProvider);
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
          'Edit Profile',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 18.sp,
            fontFamily: AppFonts.actionFont,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 90.w,
                height: 100.w,
                child: Stack(
                  children: [
                    Container(
                      width: 86.w,
                      height: 86.w,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor.withOpacity(.5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: fileSelected
                          ? Image.file(
                              selectedFile!,
                              fit: BoxFit.cover,
                            )
                          : user!.avatar != null
                              ? CustomNetworkImage(imageurl: user!.avatar!)
                              : Image.asset(
                                  AppAssets.user,
                                  fit: BoxFit.cover,
                                ),
                    ),
                    Positioned(
                      bottom: 3,
                      right: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: IconButton.filled(
                          style: const ButtonStyle(
                            backgroundColor:
                                WidgetStatePropertyAll(AppColors.primaryColor),
                          ),
                          onPressed: () async {
                            List<AssetEntity>? data = await AppHelpers()
                                .pickAssets(maxCount: 1, context: context);
                            if (data != null) {
                              final file = await data.first.file;
                              setState(() {
                                fileSelected = true;
                                selectedFile = file;
                              });
                            }
                          },
                          padding: EdgeInsets.all(5.w),
                          icon: Icon(
                            Icons.add,
                            color: AppColors.whiteColor,
                            size: 24.sp,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Name',
                  style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(.7),
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sansFont),
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _nameController,
                        style: TextStyle(
                          color: AppColors.whiteColor.withOpacity(.7),
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter name',
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
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 15.w),
                        ),
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
                  'Bio',
                  style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(.7),
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sansFont),
                ),
                SizedBox(height: 5.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _aboutController,
                        style: TextStyle(
                          color: AppColors.whiteColor.withOpacity(.7),
                        ),
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
                        maxLength: 500,
                        decoration: InputDecoration(
                          hintText: 'Describe yourself',
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
                          helperStyle: TextStyle(
                            color: AppColors.whiteColor.withOpacity(.7),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                          ),
                          contentPadding: EdgeInsets.all(15.w),
                        ),
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
                  'Location',
                  style: TextStyle(
                      color: AppColors.whiteColor.withOpacity(.7),
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sansFont),
                ),
                SizedBox(height: 5.h),
                TextField(
                  controller: _locationController,
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
                                _locationController.text = location;
                                locating = false;
                              });
                            },
                            icon: Icon(
                              Icons.location_on_outlined,
                              color: AppColors.whiteColor.withOpacity(.7),
                            ),
                          ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            if (editProfileLoading)
              const Align(
                alignment: Alignment.center,
                child: CupertinoActivityIndicator(
                  color: AppColors.primaryColor,
                ),
              )
            else
              GestureDetector(
                onTap: editProfile,
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
                      const Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Save',
                            style: TextStyle(
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
                          CupertinoIcons.check_mark_circled,
                          color: AppColors.whiteColor,
                          size: 18.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 20.h),
            Text(
              'You can also',
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.actionFont,
              ),
            ),
            SizedBox(height: 5.h),
            Container(
              width: width,
              height: 1.h,
              decoration: const BoxDecoration(
                color: AppColors.greyColor,
              ),
            ),
            ListTile(
              title: Text(
                'Add skills',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.sansFont,
                ),
              ),
              minVerticalPadding: 5.h,
              minTileHeight: 5.h,
              contentPadding: const EdgeInsets.all(0),
              onTap: () {
                AppHelpers.goNamed(
                    routeName: AppRouter.addSkillsScreen, context: context);
              },
            ),
            ListTile(
              title: Text(
                'Connect Social Accounts',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.sansFont,
                ),
              ),
              minVerticalPadding: 5.h,
              minTileHeight: 5.h,
              contentPadding: const EdgeInsets.all(0),
              onTap: () {},
            ),
            ListTile(
              title: Text(
                'Add Featured Images',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: AppFonts.sansFont,
                ),
              ),
              minVerticalPadding: 5.h,
              minTileHeight: 5.h,
              contentPadding: const EdgeInsets.all(0),
              onTap: () {
                AppHelpers.goNamed(
                    routeName: AppRouter.addFeaturedScreen, context: context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
