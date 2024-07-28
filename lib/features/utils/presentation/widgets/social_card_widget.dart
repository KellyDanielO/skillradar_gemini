import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillradar/core/helpers/app_extensions.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/entities/user_entity.dart';
import '../../../../core/entities/user_social_entity.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/providers/provider_variables.dart';
import '../../../../core/widgets/network_image.dart';
import '../providers/utility_provider.dart';

class SocialBoxWidget extends ConsumerStatefulWidget {
  const SocialBoxWidget({
    super.key,
    required this.width,
    required this.userSocial,
  });

  final double width;
  final UserSocialEntity userSocial;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SocialBoxWidgetState();
}

class _SocialBoxWidgetState extends ConsumerState<SocialBoxWidget> {
  bool deleting = false;
  void removeSocial() async {
    String? accessToken = await AppHelpers().getData('access_token');
    String? refreshToken = await AppHelpers().getData('refresh_token');
    if (mounted) {
      setState(() {
        deleting = true;
      });
    }
    UserEntity? user = await ref
        .read(utilityListenerProvider.notifier)
        .removeSocial(
            id: widget.userSocial.id.toString(),
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
      width: widget.width * .21,
      height: widget.width * .21,
      decoration: BoxDecoration(
        color: AppColors.blackShadeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      // padding: EdgeInsets.all(5.w),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              AppHelpers.launchUrlNow(widget.userSocial.link);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomNetworkImage(
                imageurl: widget.userSocial.social.logo,
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton.filled(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      title: Text(
                        'Delete Account',
                        style: TextStyle(
                          fontSize: widget.width * .01 + 18,
                          fontFamily: AppFonts.actionFont,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                        ),
                      ),
                      content: Text(
                        widget.userSocial.social.name.capitalizeFirst
                            .toString(),
                        style: TextStyle(
                          fontSize: widget.width * .01 + 16,
                          color: Theme.of(context).textTheme.bodyMedium!.color,
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
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                              fontSize: widget.width * .01 + 14,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            if (!deleting) {
                              removeSocial();
                            }
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
        ],
      ),
    );
  }
}
