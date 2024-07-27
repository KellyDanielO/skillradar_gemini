import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/providers/provider_variables.dart';
import '../../../../core/widgets/network_image.dart';
import '../providers/utility_provider.dart';
import '../screens/image_viewer.dart';

class FeaturedImageWidget extends ConsumerStatefulWidget {
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
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _FeaturedImageWidgetState();
}

class _FeaturedImageWidgetState extends ConsumerState<FeaturedImageWidget> {
  bool deleting = false;
  void removeFeatured() async {
    String? accessToken = await AppHelpers().getData('access_token');
    String? refreshToken = await AppHelpers().getData('refresh_token');
    if (mounted) {
      setState(() {
        deleting = true;
      });
    }
    UserEntity? user = await ref
        .read(utilityListenerProvider.notifier)
        .removeFeatured(
            id: widget.id,
            accessToken: accessToken!,
            refreshToken: refreshToken!);
    if (user != null) {
      ref.read(gobalUserNotifierProvider.notifier).setUser(user);

      if (mounted) {
        setState(() {
          deleting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      clipBehavior: Clip.antiAlias,
      margin: EdgeInsets.only(bottom: 10.h),
      width: widget.width,
      child: Stack(
        children: [
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  AppHelpers.moveTo(
                      ImageViewer(
                        heroTag:
                            'featured_image${widget.image}${widget.summary}',
                        image: widget.image,
                        isNetwork: true,
                        summary: widget.summary,
                      ),
                      context);
                },
                child: Container(
                  width: widget.width,
                  constraints: BoxConstraints(minHeight: 250.h),
                  child: Hero(
                    tag: 'featured_image${widget.image}${widget.summary}',
                    child: CustomNetworkImage(imageurl: widget.image),
                  ),
                ),
              ),
              Container(
                width: widget.width,
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
                color: AppColors.whiteColor.withOpacity(.9),
                child: Text(
                  widget.summary,
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
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        title: Text(
                          'Delete featured',
                          style: TextStyle(
                            fontSize: widget.width * .01 + 18,
                            fontFamily: AppFonts.actionFont,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        content: Text(
                          widget.summary,
                          style: TextStyle(
                            fontSize: widget.width * .01 + 16,
                            color:
                                Theme.of(context).textTheme.bodyMedium!.color,
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .color,
                                fontSize: widget.width * .01 + 14,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              removeFeatured();
                            },
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: AppColors.redColor,
                                fontSize: widget.width * .01 + 14,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                style: const ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(AppColors.redColor),
                ),
                icon: deleting
                    ? const CupertinoActivityIndicator()
                    : Icon(
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
