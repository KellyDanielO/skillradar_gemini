import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';

class ImageViewer extends StatelessWidget {
  final String image;
  final String heroTag;
  final bool? isNetwork;
  const ImageViewer(
      {super.key, required this.image, required this.heroTag, this.isNetwork});

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
            child: isNetwork != null && isNetwork == true
                ? Image.network(
                    image,
                    fit: BoxFit.contain,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      }
                    },
                    errorBuilder: (BuildContext context, Object error,
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
                    image,
                    fit: BoxFit.contain,
                  ),
          ),
        ),
      ),
    );
  }
}
