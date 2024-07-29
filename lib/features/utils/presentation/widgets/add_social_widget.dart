import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillradar/core/helpers/app_extensions.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/entities/social_entity.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/providers/provider_variables.dart';
import '../../../../core/widgets/custom_btns.dart';
import '../../../../core/widgets/custom_dropdown_widget.dart';
import '../../../../core/widgets/error_widgets.dart';
import '../../../../core/widgets/network_image.dart';
import '../providers/utility_provider.dart';

class AddSocialWidget extends ConsumerStatefulWidget {
  final List<SocialEntity> socials;
  const AddSocialWidget({super.key, required this.socials});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddSocialWidgetState();
}

class _AddSocialWidgetState extends ConsumerState<AddSocialWidget> {
  TextEditingController link = TextEditingController();
  late SocialEntity selectedSocial;
  @override
  void initState() {
    selectedSocial = widget.socials.first;
    super.initState();
  }

  @override
  void dispose() {
    link.dispose();
    super.dispose();
  }

  void addSocial() async {
    final buttonLoading = ref.read(addingSocialLoadingNotifierProvider);
    if (!buttonLoading) {
      if (link.text.isEmpty) {
        errorWidget(message: 'All fields are required!');
      } else {
        String? accessToken = await AppHelpers().getData('access_token');
        String? refreshToken = await AppHelpers().getData('refresh_token');
        ref.read(addingSocialLoadingNotifierProvider.notifier).change(true);
        UserEntity? user =
            await ref.read(utilityListenerProvider.notifier).addSocial(
                  social: selectedSocial.name,
                  link: link.text,
                  accessToken: accessToken!,
                  refreshToken: refreshToken!,
                );
        if (user != null) {
          ref.read(gobalUserNotifierProvider.notifier).setUser(user);
          if (mounted) {
            Navigator.pop(context);
          }
        }
        ref.read(addingSocialLoadingNotifierProvider.notifier).change(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final buttonLoading = ref.watch(addingSocialLoadingNotifierProvider);
    return FittedBox(
      child: Container(
        width: width,
        constraints: BoxConstraints(
          minHeight: 250.h,
          maxHeight: keyboardHeight > 0 ? 250.h + (keyboardHeight) : 250.h,
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
                  Row(
                    children: <Widget>[
                      Container(
                        width: 60.w,
                        height: 60.w,
                        decoration: BoxDecoration(
                          color: AppColors.blackShadeColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: EdgeInsets.all(10.w),
                        child: CustomNetworkImage(
                          imageurl: selectedSocial.logo,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: CustomDropdownFormField<SocialEntity>(
                          label: 'Choose an option',
                          hint: 'Please select an option',
                          value: selectedSocial,
                          items: widget.socials.map((SocialEntity value) {
                            return DropdownMenuItem<SocialEntity>(
                              value: value,
                              child:
                                  Text(value.name.capitalizeFirst.toString()),
                            );
                          }).toList(),
                          onChanged: (SocialEntity? newValue) {
                            setState(() {
                              selectedSocial = newValue!;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return 'Please select an option';
                            }
                            return null;
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
                        'Link',
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
                              controller: link,
                              style: TextStyle(
                                color: AppColors.whiteColor.withOpacity(.7),
                              ),
                              keyboardType: TextInputType.url,
                              decoration: InputDecoration(
                                hintText: 'Paste in link...',
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
                      text: 'Add',
                      textColor: AppColors.whiteColor,
                      btnColor: AppColors.primaryColor,
                      fontSize: AppHelpers.isTablet() ? 10.sp : 16.sp,
                      onPressed: addSocial,
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
