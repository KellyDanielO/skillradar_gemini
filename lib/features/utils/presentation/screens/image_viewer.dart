import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/widgets/network_image.dart';

class ImageViewer extends StatelessWidget {
  final String image;
  final String heroTag;
  final bool? isNetwork;
  final String? summary;
  const ImageViewer(
      {super.key, required this.image, required this.heroTag, this.isNetwork, this.summary});

  @override
  Widget build(BuildContext context) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    print(isNetwork);
    return Scaffold(
      // appBar: AppBar(
      //   leadingWidth: 50.w,
      //   leading: FittedBox(
      //     child: IconButton(
      //       onPressed: () => Navigator.pop(context),
      //       icon: SvgPicture.asset(
      //         AppAssets.arrowIOSBoldIcon,
      //         colorFilter:
      //             const ColorFilter.mode(AppColors.whiteColor, BlendMode.srcIn),
      //         width: 15.w,
      //         height: 15.h,
      //       ),
      //     ),
      //   ),
      // ),
      body: SizedBox(
        width: width,
        height: height,
        child: Stack(
          children: [
            Positioned.fill(
              child: Hero(
                tag: heroTag,
                transitionOnUserGestures: true,
                child: InteractiveViewer(
                  panEnabled: true, // Enable panning
                  minScale: 0.5, // Minimum zoom scale
                  maxScale: 4.0,
                  child: isNetwork != null && isNetwork == true
                      ? CustomNetworkImage(
                          imageurl: image,
                          fit: BoxFit.contain,
                        )
                      : Image.asset(
                          image,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            Positioned(
              top: 30.h,
              left: 10,
              child: IconButton.filled(
                onPressed: () => Navigator.pop(context),
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    AppColors.blackColor.withOpacity(.6),
                  ),
                ),
                icon: SvgPicture.asset(
                  AppAssets.arrowIOSBoldIcon,
                  colorFilter: const ColorFilter.mode(
                      AppColors.whiteColor, BlendMode.srcIn),
                  width: 15.w,
                  height: 15.h,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              child: summary != null ? Container(
                width: width,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                color: AppColors.blackColor.withOpacity(.9),
                child: Text(
                  summary!,
                  style: TextStyle(
                    color: AppColors.whiteColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.sansFont,
                  ),
                  softWrap: true,
                ),
              ) : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
