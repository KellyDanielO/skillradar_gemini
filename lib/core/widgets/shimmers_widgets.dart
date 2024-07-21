import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../constants/colors.dart';

class ProfileCardShimmer extends StatelessWidget {
  const ProfileCardShimmer({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.greyColor.withOpacity(.5),
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(15.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              ShimmerBox(width: 50.w, height: 10.h),
              ShimmerBox(width: 35.w, height: 35.w),
            ],
          ),
          ShimmerBox(
            width: 70.w,
            height: 70.h,
            borderRadius: BorderRadius.circular(15),
          ),
          Column(
            children: <Widget>[
              ShimmerBox(width: 50.w, height: 15.h),
              ShimmerBox(width: width * .4, height: 10.h),
            ],
          ),
          Column(
            children: <Widget>[
              ShimmerBox(width: width, height: .7),
              SizedBox(height: 10.h),
              ShimmerBox(width: 60.w, height: 10.h),
              SizedBox(height: 10.h),
              ShimmerBox(width: width, height: .7),
            ],
          ),
          ShimmerBox(width: 60.w, height: 10.h),
          ShimmerBox(width: width, height: 35.h),
        ],
      ),
    );
  }
}

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadiusGeometry? borderRadius;
  const ShimmerBox(
      {super.key,
      required this.width,
      required this.height,
      this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      margin: const EdgeInsets.only(bottom: 10.0),
      decoration: BoxDecoration(
        color: AppColors.greyColor.withOpacity(.5),
        borderRadius: borderRadius ?? BorderRadius.circular(99),
      ),
    );
  }
}

class FeedShimmer extends StatelessWidget {
  const FeedShimmer({
    super.key,
    required this.width,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.greyColor.withOpacity(.5),
      highlightColor: AppColors.primaryColor,
      child: ProfileCardShimmer(width: width),
    );
  }
}
