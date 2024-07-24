import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/assets.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/providers/provider_variables.dart';
import '../../../../../core/widgets/custom_btns.dart';
import '../../widgets/add_featured_image_screen.dart';
import '../../widgets/featured_image.dart';

class FeaturedScreen extends ConsumerStatefulWidget {
  const FeaturedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeaturedScreenState();
}

class _FeaturedScreenState extends ConsumerState<FeaturedScreen> {
  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
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
          'Featured',
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
        child: user!.featured.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    AppAssets.notFound,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'No featured image found!',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: AppColors.whiteColor,
                          fontWeight: FontWeight.bold,
                          fontFamily: AppFonts.sansFont,
                        ),
                  ),
                ],
              )
            : ListView.builder(
                itemCount: user.featured.length,
                itemBuilder: (context, index) => FeaturedImageWidget(
                  width: width,
                  image: user.featured[index].media,
                  summary: user.featured[index].summary,
                  id: user.featured[index].id,
                ),
              ),
      ),
      bottomNavigationBar: user.featured.length >= 5
          ? null
          : Container(
              width: width,
              height: height * .09,
              padding: EdgeInsets.all(10.w),
              child: Builder(builder: (context) {
                return CustomBtn(
                  text: 'Add Featured Image',
                  textColor: AppColors.blackColor,
                  btnColor: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(10),
                  fontSize: 14.sp,
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return const AddFeaturedImageScreen();
                      },
                    );
                  },
                );
              }),
            ),
    );
  }
}
