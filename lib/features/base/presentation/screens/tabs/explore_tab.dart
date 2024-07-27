import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/entities/skill_entity.dart';
import '../../../../../core/providers/provider_variables.dart';
import '../../../../../core/widgets/error_widgets.dart';
import '../../provider/providers.dart';

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
  List<String> fetchedSkills = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
    _searchController.addListener(_filterItems);
  }

  void _fetchItems() async {
    List<SkillEntity> skill = ref.read(gobalSkillsNotifierProvider);
    List<String> skills = [];
    for (var skill in skill) {
      skills.add(skill.name);
    }
    setState(() {
      fetchedSkills = skills;
      _filteredItems = skills;
    });
  }

  void _filterItems() {
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
    final selectedSkills = ref.watch(selectedSkillsProvider);
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
          if (selectedSkills.isEmpty)
            const SizedBox()
          else
            SizedBox(height: 10.h),
          if (selectedSkills.isNotEmpty)
            const Text(
              'Selected Skills',
              style: TextStyle(
                color: AppColors.whiteColor,
                fontFamily: AppFonts.actionFont,
              ),
            ).animate().fadeIn()
          else
            const SizedBox(),
          selectedSkills.isEmpty ? const SizedBox() : SizedBox(height: 10.h),
          if (selectedSkills.isEmpty)
            const SizedBox()
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    List.generate(selectedSkills.reversed.length, (index) {
                  return Container(
                    margin: EdgeInsets.only(right: 10.w),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          fetchedSkills.add(selectedSkills[index]);
                          _filteredItems.add(selectedSkills[index]);
                        });
                        ref
                            .read(selectedSkillsProvider.notifier)
                            .removeSkill(selectedSkills[index]);
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
              return GestureDetector(
                onTap: () {
                  if (selectedSkills.length > 4) {
                    errorWidget(message: 'Skill limit exceeded');
                  } else {
                    ref.read(selectedSkillsProvider.notifier).addSkill(_filteredItems[index]);
                    setState(() {
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
    );
  }
}