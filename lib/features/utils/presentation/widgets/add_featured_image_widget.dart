import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:skillradar/core/helpers/extensions.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/providers/provider_variables.dart';
import '../../../../core/widgets/custom_btns.dart';
import '../../../../core/widgets/error_widgets.dart';
import '../providers/utility_provider.dart';

class AddFeaturedImageScreen extends ConsumerStatefulWidget {
  final bool? isDataSaved;
  const AddFeaturedImageScreen({super.key, this.isDataSaved});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddFeaturedImageScreenState();
}

class _AddFeaturedImageScreenState
    extends ConsumerState<AddFeaturedImageScreen> {
  TextEditingController summary = TextEditingController();
  bool fileSelected = false;
  File? selectedFile;

  @override
  void dispose() {
    summary.dispose();
    super.dispose();
  }

  void addFeatured() async {
    final buttonLoading = ref.read(uploadingFeaturedLoadingNotifierProvider);
    if (!buttonLoading) {
      if (selectedFile.isNull || summary.text.isEmpty) {
        errorWidget(message: 'All fields are required!');
      } else {
        String? accessToken = await AppHelpers().getData('access_token');
        String? refreshToken = await AppHelpers().getData('refresh_token');
        ref
            .read(uploadingFeaturedLoadingNotifierProvider.notifier)
            .change(true);
        UserEntity? user =
            await ref.read(utilityListenerProvider.notifier).addFeatured(
                  summary: summary.text,
                  media: selectedFile!,
                  accessToken: accessToken!,
                  refreshToken: refreshToken!,
                );
        if (user != null) {
          ref.read(gobalUserNotifierProvider.notifier).setUser(user);
          if (mounted) {
            Navigator.pop(context);
          }
        }
        ref
            .read(uploadingFeaturedLoadingNotifierProvider.notifier)
            .change(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final buttonLoading = ref.watch(uploadingFeaturedLoadingNotifierProvider);
    return FittedBox(
      child: Container(
        width: width,
        constraints: BoxConstraints(
          minHeight: 350.h,
          maxHeight: keyboardHeight > 0 ? 400.h + (keyboardHeight) : 400.h,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 5.h),
            Container(
              width: 60.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: AppColors.greyColor.withOpacity(.6),
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
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
                    child: Container(
                      height: 200.h,
                      width: width,
                      decoration: BoxDecoration(
                        color: AppColors.greyColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      clipBehavior: Clip.hardEdge,
                      alignment: fileSelected ? null : Alignment.center,
                      child: fileSelected
                          ? Image.file(
                              selectedFile!,
                              fit: BoxFit.cover,
                            )
                          : Text(
                              'Upload Image',
                              style: TextStyle(
                                color: AppColors.blackColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: AppFonts.interFont,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Summary',
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
                              controller: summary,
                              style: TextStyle(
                                color: AppColors.whiteColor.withOpacity(.7),
                              ),
                              maxLength: 50,
                              decoration: InputDecoration(
                                hintText:
                                    'A quick description about the image....',
                                hintStyle: TextStyle(
                                  color: AppColors.whiteColor.withOpacity(.7),
                                ),
                                helperStyle: TextStyle(
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
                  if (buttonLoading)
                    const Center(
                      child: CupertinoActivityIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  else
                    CustomBtn(
                      text: 'Upload',
                      textColor: AppColors.whiteColor,
                      btnColor: AppColors.primaryColor,
                      fontSize: AppHelpers.isTablet() ? 10.sp : 16.sp,
                      onPressed: addFeatured,
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
