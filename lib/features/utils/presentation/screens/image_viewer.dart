import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';

class ImageViewer extends StatelessWidget {
  final String image;
  final String heroTag;
  const ImageViewer({super.key, required this.image, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
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
      ),
      body: SizedBox(
        width: width,
        height: height,
        child: Hero(
          tag: heroTag,
          transitionOnUserGestures: true,
          child: InteractiveViewer(
            panEnabled: true, // Enable panning
            minScale: 0.5, // Minimum zoom scale
            maxScale: 4.0,
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
