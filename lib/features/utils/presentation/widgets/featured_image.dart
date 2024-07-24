import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/widgets/network_image.dart';
import '../screens/image_viewer.dart';

class FeaturedImageWidget extends StatelessWidget {
  const FeaturedImageWidget({
    super.key,
    required this.width,
    required this.image,
    required this.summary,
    required this.id,
  });

  final double width;
  final String image;
  final String summary;
  final String id;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(bottom: 10.h),
      width: width,
      child: Stack(
        children: [
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  AppHelpers.moveTo(
                      ImageViewer(
                        heroTag: 'featured_image$image$summary',
                        image: image,
                        isNetwork: true,
                        summary: summary,
                      ),
                      context);
                },
                child: Container(
                  width: width,
                  constraints: BoxConstraints(minHeight: 250.h),
                  child: Hero(
                    tag: 'featured_image$image$summary',
                    child: CustomNetworkImage(imageurl: image),
                  ),
                ),
              ),
              Container(
                width: width,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                color: AppColors.whiteColor.withOpacity(.9),
                child: Text(
                  summary,
                  style: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.sansFont,
                  ),
                  softWrap: true,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              margin: EdgeInsets.all(10.w),
              child: IconButton.filled(
                onPressed: () {},
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.redColor),
                ),
                icon: Icon(
                  CupertinoIcons.trash,
                  color: AppColors.whiteColor,
                  size: 18.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
