import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/constants/skills.dart';

class ExploreTab extends ConsumerStatefulWidget {
  final double width;
  final double height;
  const ExploreTab({super.key, required this.width, required this.height});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreTabState();
}

class _ExploreTabState extends ConsumerState<ExploreTab> {
  final TextEditingController _searchController = TextEditingController();
  List<String> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();

    _searchController.addListener(_filterItems);
  }

  void _fetchItems() async {
    List<String> items = await compute(fetchItemsInIsolate, null);
    setState(() {
      _filteredItems = items;
    });
  }

  static List<String> fetchItemsInIsolate(_) {
    return skillList;
  }

  void _filterItems() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = skillList.where((item) {
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: ListView(
        children: <Widget>[
          SizedBox(height: 20.h),
          Text(
            'Discover that skill, hobby, occupation, closest to you!',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
                fontFamily: AppFonts.sansFont),
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
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.0, // Gap between adjacent items
            runSpacing: 4.0, // Gap between lines
            children: List.generate(_filteredItems.length, (index) {
              return Chip(
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
              );
            }),
          ),
          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}
