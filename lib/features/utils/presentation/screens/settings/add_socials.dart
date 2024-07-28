import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/assets.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/providers/provider_variables.dart';
import '../../../../../core/widgets/custom_btns.dart';
import '../../widgets/add_social_widget.dart';
import '../../widgets/social_card_widget.dart';

class AddSocialsScreen extends ConsumerStatefulWidget {
  const AddSocialsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddSocialsScreenState();
}

class _AddSocialsScreenState extends ConsumerState<AddSocialsScreen> {
  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    final user = ref.watch(gobalUserNotifierProvider);
    final socials = ref.watch(gobalSocialsNotifierProvider);
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
          'Socials',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 18.sp,
            fontFamily: AppFonts.actionFont,
          ),
        ),
        centerTitle: true,
      ),
      body: user!.socials.isNotEmpty
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Wrap(
                spacing: 10.0, // Gap between adjacent items
                runSpacing: 16.0, // Gap between lines
                children: List.generate(
                  user.socials.length,
                  (index) {
                    return SocialBoxWidget(
                      width: width,
                      userSocial: user.socials[index],
                    );
                  },
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  AppAssets.notFound,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10.h),
                Text(
                  'No linked social account!',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontFamily: AppFonts.sansFont,
                      ),
                ),
              ],
            ),
      bottomNavigationBar: Container(
        width: width,
        height: height * .09,
        padding: EdgeInsets.all(10.w),
        child: Builder(builder: (context) {
          return CustomBtn(
            text: 'Add Social Account',
            textColor: AppColors.blackColor,
            btnColor: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10),
            fontSize: 14.sp,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return AddSocialWidget(
                    socials: socials,
                  );
                },
              );
            },
          );
        }),
      ),
    );
  }
}
