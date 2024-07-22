import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/constants/assets.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/fonts.dart';
import '../../../../../core/entities/skill_entity.dart';
import '../../../../../core/entities/user_entity.dart';
import '../../../../../core/helpers/functions.dart';
import '../../../../../core/providers/provider_variables.dart';
import '../../../../../core/widgets/error_widgets.dart';
import '../../providers/initialize_provider.dart';

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
    final data = ref.read(gobalUserNotifierProvider);
    for (var skill in data!.skills) {
      selectedSkills.add(skill.name);
      fetchedSkills.removeWhere((data) => data == skill.name);
    }
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

  void saveSkills() async {
    if (selectedSkills.isEmpty) {
      errorWidget(message: 'please select a skill');
    } else {
      String? accessToken = await AppHelpers().getData('access_token');
      String? refreshToken = await AppHelpers().getData('refresh_token');
      ref.read(addingSkillsLoadingNotifierProvider.notifier).change(true);
      UserEntity? user =
          await ref.read(initializeListenerProvider.notifier).addSkills(
                skills: selectedSkills.join(','),
                accessToken: accessToken!,
                refreshToken: refreshToken!,
              );
      if (user != null) {
        ref.read(gobalUserNotifierProvider.notifier).setUser(user);
        if (mounted) {
          Navigator.pop(context);
        }
      }
      ref.read(addingSkillsLoadingNotifierProvider.notifier).change(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final addingSkillsLoading = ref.watch(addingSkillsLoadingNotifierProvider);
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
              onPressed: saveSkills,
              backgroundColor: AppColors.primaryColor,
              shape: const CircleBorder(),
              child: addingSkillsLoading
                  ? const CupertinoActivityIndicator()
                  : const Icon(
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
                return GestureDetector(
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
