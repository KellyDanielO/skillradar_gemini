import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/router.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/widgets/custom_btns.dart';
import '../../../../core/widgets/network_image.dart';
import '../../../profile/presentation/providers/provider.dart';
import '../../../utils/presentation/screens/image_viewer.dart';

class ProfileCard extends ConsumerWidget {
  final String name;
  final String image;
  final String location;
  final String skill;
  final String bio;
  final String joined;
  final bool? isUrl;
  final UserEntity? user;
  final void Function() action;
  const ProfileCard({
    required this.name,
    required this.image,
    required this.location,
    required this.skill,
    required this.bio,
    required this.joined,
    required this.action,
    this.isUrl,
    this.user,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double width = ScreenUtil().screenWidth;
    double height = ScreenUtil().screenHeight;
    final transH = AppLocalizations.of(context)!;
    String heroId = AppHelpers.generateRandomId();
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFb2efa9),
            Color(0xFF95e18a),
          ],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(15.h),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                joined,
                style: TextStyle(
                    fontSize: 14.sp,
                    fontFamily: AppFonts.sansFont,
                    fontWeight: FontWeight.w600,
                    color: AppColors.blackColor),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              AppHelpers.moveTo(
                ImageViewer(
                  image: image,
                  heroTag: heroId,
                  isNetwork: isUrl,
                ),
                context,
              );
            },
            child: Container(
              width: 70.w,
              height: 70.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColors.greyColor.withOpacity(.5),
              ),
              clipBehavior: Clip.antiAlias,
              child: Hero(
                tag: heroId,
                transitionOnUserGestures: true,
                child: isUrl != null && isUrl == true
                    ? CustomNetworkImage(imageurl: image)
                    : Image.asset(
                        image,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
          Column(
            children: <Widget>[
              Text(
                name,
                style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sansFont,
                      color: AppColors.blackColor,
                    ),
              ),
              SizedBox(height: 5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.blackColor.withOpacity(.7),
                    size: 20.sp,
                  ),
                  SizedBox(width: 10.w),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: width * .6),
                    child: Text(
                      location,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontWeight: FontWeight.w500,
                            fontFamily: AppFonts.interFont,
                            color: AppColors.blackColor.withOpacity(.7),
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Container(
                width: width,
                height: .7,
                color: AppColors.blackColor.withOpacity(.5),
              ),
              SizedBox(height: 10.h),
              Text(
                skill,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w600,
                      fontFamily: AppFonts.sansFont,
                      color: AppColors.blackColor,
                    ),
              ),
              SizedBox(height: 10.h),
              Container(
                width: width,
                height: .7,
                color: AppColors.blackColor.withOpacity(.5),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: height * .2),
            child: Text(
              bio,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                    fontFamily: AppFonts.sansFont,
                    color: AppColors.blackColor.withOpacity(.7),
                  ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          CustomBtn(
            text: transH.viewProfile,
            textColor: AppColors.whiteColor,
            btnColor: AppColors.blackColor,
            fontSize: 14.sp,
            onPressed: () {
              ref.read(navigatedUserNotifierProvider.notifier).setUser(user);
              AppHelpers.goNamed(
                  routeName: AppRouter.profileScreen, context: context);
            },
            padding: EdgeInsets.symmetric(vertical: 18.h),
          )
        ],
      ),
    );
  }
}
