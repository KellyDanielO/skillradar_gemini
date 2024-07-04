import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:developer';

import '../../../../../core/constants/assets.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/constants/skills.dart';
import '../../../../../core/widgets/error_widgets.dart';

class SelectSkillsScreen extends ConsumerStatefulWidget {
  const SelectSkillsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SelectSkillsScreenState();
}

class _SelectSkillsScreenState extends ConsumerState<SelectSkillsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];
  List<String> selectedSkills = [];
  List<String> fetchedSkills = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();

    _searchController.addListener(_filterItems);
  }

  void _fetchItems() async {
    List<String> items = await compute(fetchItemsInIsolate, null);
    setState(() {
      fetchedSkills = items;
      _filteredItems = items;
    });
  }

  static List<String> fetchItemsInIsolate(_) {
    return skillList;
  }

  void _filterItems() {
    log('message');
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = fetchedSkills.where((item) {
        return item.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
        title: Text(
          'Select Skills',
          style: TextStyle(
            color: AppColors.whiteColor,
            fontSize: 18.sp,
            fontFamily: AppFonts.actionFont,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: selectedSkills.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              backgroundColor: AppColors.primaryColor,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.check,
              ),
            ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 20.h),
            Text(
              'Select skills you excel well in!',
              style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: AppColors.whiteColor,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppFonts.sansFont),
            ),
            selectedSkills.isEmpty ? const SizedBox() : SizedBox(height: 10.h),
            selectedSkills.isNotEmpty
                ? const Text(
                    'Selected Skills',
                    style: TextStyle(
                      color: AppColors.whiteColor,
                      fontFamily: AppFonts.actionFont,
                    ),
                  ).animate().fadeIn()
                : const SizedBox(),
            selectedSkills.isEmpty ? const SizedBox() : SizedBox(height: 10.h),
            selectedSkills.isEmpty
                ? const SizedBox()
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(selectedSkills.reversed.length,
                          (index) {
                        return Container(
                          margin: EdgeInsets.only(right: 10.w),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                fetchedSkills.add(selectedSkills[index]);
                                _filteredItems.add(selectedSkills[index]);
                                selectedSkills.removeAt(index);
                              });
                            },
                            child: Chip(
                              backgroundColor: AppColors.whiteColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              label: Text(
                                selectedSkills[index],
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontFamily: AppFonts.sansFont,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ).animate().fadeIn(),
                        );
                      }),
                    ),
                  ),
            SizedBox(height: 15.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 0.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.whiteColor.withOpacity(.7),
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: TextStyle(
                        color: AppColors.whiteColor.withOpacity(.7),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Type that desired skill....',
                        hintStyle: TextStyle(
                          color: AppColors.whiteColor.withOpacity(.7),
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.all(0),
                      ),
                    ),
                  ),
                  Icon(
                    CupertinoIcons.search,
                    color: AppColors.whiteColor.withOpacity(.7),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Wrap(
              spacing: 8.0, // Gap between adjacent items
              runSpacing: 4.0, // Gap between lines
              children: List.generate(_filteredItems.length, (index) {
                return InkWell(
                  onTap: () {
                    if (selectedSkills.length > 4) {
                      errorWidget(message: 'Skill limit exceeded');
                    } else {
                      setState(() {
                        selectedSkills.add(_filteredItems[index]);
                        fetchedSkills.removeWhere(
                            (skill) => skill == _filteredItems[index]);

                        _filteredItems.removeAt(index);
                      });
                    }
                  },
                  child: Chip(
                    backgroundColor: AppColors.blackColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    label: Text(
                      _filteredItems[index],
                      style: TextStyle(
                        color: AppColors.whiteColor,
                        fontFamily: AppFonts.sansFont,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(height: 100.h),
          ],
        ),
      ),
    );
  }
}
