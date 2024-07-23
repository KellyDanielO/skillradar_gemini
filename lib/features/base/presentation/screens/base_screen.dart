import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/assets.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/router.dart';
import '../../../../core/helpers/functions.dart';
import '../../../../core/providers/provider_variables.dart';
import '../../../../core/widgets/error_widgets.dart';
import '../constants/enums.dart';
import '../controllers/base_controllers.dart';
import '../provider/providers.dart';
import 'tabs/explore_tab.dart';
import 'tabs/home_tab.dart';
import 'tabs/saved_tab.dart';

class BaseScreen extends ConsumerStatefulWidget {
  const BaseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BaseScreenState();
}

class _BaseScreenState extends ConsumerState<BaseScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  @override
  void initState() {
    AppHelpers.changeBottomBarColor();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final globalUser = ref.read(gobalUserNotifierProvider);
      if (globalUser!.skills.isEmpty) {
        ref.read(feedStateNotifierProvider.notifier).change(FeedState.noSkill);
      } else {
        BaseController().fetchFeedData(ref: ref);
        if (globalUser.avatar != null) {
          AppHelpers().precacheNetworkImages(context, [globalUser.avatar!]);
        }
        if (globalUser.coverPhoto != null) {
          AppHelpers().precacheNetworkImages(context, [globalUser.coverPhoto!]);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = ScreenUtil().screenHeight;
    ref.watch(feedStateNotifierProvider);
    double width = ScreenUtil().screenWidth;
    List<BottomTabs> bottomTabs = [
      BottomTabs(
        activeIcon: AppAssets.homeBoldIcon,
        defaultIcon: AppAssets.homeOutlinedIcon,
        action: () {
          _pageController.animateToPage(0,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        },
        doubleTap: () async {
          final globalUser = ref.read(gobalUserNotifierProvider);
          if (globalUser!.skills.isNotEmpty) {
            BaseController().fetchFeedData(ref: ref);
          } else {
            errorWidget(message: 'Please add a skill');
          }
        },
      ),
      BottomTabs(
        activeIcon: AppAssets.compassBoldIcon,
        defaultIcon: AppAssets.compassOutlinedIcon,
        action: () {
          _pageController.animateToPage(1,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        },
      ),
      BottomTabs(
        activeIcon: AppAssets.bookmarkBoldIcon,
        defaultIcon: AppAssets.bookmarkOutlinedIcon,
        action: () {
          _pageController.animateToPage(2,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut);
        },
      ),
      BottomTabs(
        activeIcon: AppAssets.userBoldIcon,
        defaultIcon: AppAssets.userOutlinedIcon,
        action: () {
          AppHelpers.goNamed(
              routeName: AppRouter.profileScreen, context: context);
        },
      ),
    ];
    List<Widget> tabWidgets = [
      HomeTab(width: width, height: height),
      ExploreTab(width: width, height: height),
      SavedTab(width: width, height: height),
    ];
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: width,
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: SizedBox(
                  width: width,
                  height: height,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: tabWidgets.length,
                    onPageChanged: (value) {
                      setState(() {
                        _selectedIndex = value;
                      });
                    },
                    itemBuilder: (context, index) => tabWidgets[index],
                  ),
                ),
              ),
              bottomNavigationArea(width, bottomTabs),
            ],
          ),
        ),
      ),
    );
  }

  Positioned bottomNavigationArea(double width, List<BottomTabs> bottomTabs) {
    final feedState = ref.watch(feedStateNotifierProvider);
    return Positioned(
      left: 0,
      right: 0,
      bottom: 10,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Container(
          width: width - 20.w,
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(100),
          ),
          padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              bottomTabs.length,
              (index) => AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: InkWell(
                  key: ValueKey<int>(_selectedIndex),
                  onTap: bottomTabs[index].action,
                  onDoubleTap: bottomTabs[index].doubleTap,
                  child: index == 0 && feedState == FeedState.loading
                      ? const CupertinoActivityIndicator(
                          color: AppColors.primaryColor,
                        )
                      : SvgPicture.asset(
                          _selectedIndex == index
                              ? bottomTabs[index].activeIcon
                              : bottomTabs[index].defaultIcon,
                          colorFilter: ColorFilter.mode(
                            _selectedIndex == index
                                ? AppColors.blackColor
                                : AppColors.blackColor.withOpacity(.6),
                            BlendMode.srcIn,
                          ),
                          width: 22.w,
                          height: 22.h,
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BottomTabs {
  final String activeIcon;
  final String defaultIcon;
  final void Function() action;
  final void Function()? doubleTap;

  BottomTabs(
      {required this.activeIcon,
      required this.defaultIcon,
      this.doubleTap,
      required this.action});
}
