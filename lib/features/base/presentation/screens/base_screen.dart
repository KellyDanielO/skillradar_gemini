import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skillradar/core/constants/colors.dart';

class BaseScreen extends ConsumerStatefulWidget {
  const BaseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BaseScreenState();
}

class _BaseScreenState extends ConsumerState<BaseScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    double height = ScreenUtil().screenHeight;
    double width = ScreenUtil().screenWidth;
    List<BottomTabs> bottomTabs = [
      BottomTabs(
        activeIcon: CupertinoIcons.house_fill,
        defaultIcon: CupertinoIcons.home,
        action: () {
          setState(() {
            _selectedIndex = 0;
          });
        },
      ),
      BottomTabs(
        activeIcon: CupertinoIcons.compass_fill,
        defaultIcon: CupertinoIcons.compass,
        action: () {
          setState(() {
            _selectedIndex = 1;
          });
        },
      ),
      BottomTabs(
        activeIcon: CupertinoIcons.bookmark_fill,
        defaultIcon: CupertinoIcons.bookmark,
        action: () {
          setState(() {
            _selectedIndex = 2;
          });
        },
      ),
      BottomTabs(
        activeIcon: CupertinoIcons.person_fill,
        defaultIcon: CupertinoIcons.person,
        action: () {
          setState(() {
            _selectedIndex = 3;
          });
        },
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          width: width,
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: SizedBox(
                  width: width,
                  height: height,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Good Morning',
                                style: TextStyle(
                                  color: AppColors.whiteColor.withOpacity(.5),
                                  fontSize: 14.sp,
                                ),
                              ),
                              Text(
                                'Kelly Daniel',
                                style: TextStyle(
                                  color: AppColors.whiteColor.withOpacity(.8),
                                  fontSize: 16.sp,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: AppColors.whiteColor.withOpacity(.7),
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: IconButton(
                              onPressed: () {},
                              icon: Icon(
                                CupertinoIcons.bell,
                                color: AppColors.whiteColor.withOpacity(.7),
                                size: 20.sp,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(height: 15.h),
                      Text(
                        'Let\'s find that skill, closest to you!',
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(
                                color: AppColors.whiteColor,
                                fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 15.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.whiteColor.withOpacity(.7),
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              'Type that desired skill....',
                              style: TextStyle(
                                color: AppColors.whiteColor.withOpacity(.7),
                              ),
                            ),
                            Icon(
                              CupertinoIcons.search,
                              color: AppColors.whiteColor.withOpacity(.7),
                            ),
                          ],
                        ),
                      ),
                    ],
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
    return Positioned(
      left: 0,
      right: 0,
      bottom: 10,
      child: Container(
        width: width - 20.w,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(30),
        ),
        padding: EdgeInsets.symmetric(vertical: 5.h),
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
              child: IconButton(
                key: ValueKey<int>(_selectedIndex),
                onPressed: bottomTabs[index].action,
                icon: Icon(
                  _selectedIndex == index
                      ? bottomTabs[index].activeIcon
                      : bottomTabs[index].defaultIcon,
                  color: _selectedIndex == index
                      ? AppColors.blackColor
                      : AppColors.blackColor.withOpacity(.6),
                  size: 24.sp,
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
  final IconData activeIcon;
  final IconData defaultIcon;
  final void Function() action;

  BottomTabs(
      {required this.activeIcon,
      required this.defaultIcon,
      required this.action});
}
