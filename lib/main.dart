import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constants/colors.dart';

import 'core/constants/sizes.dart';
import 'features/utils/presentation/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp(
        title: 'Skill Radar',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.blackColor,
          textTheme: TextTheme(
              bodyMedium: TextStyle(
                  color: AppColors.whiteColor, fontSize: AppSizes.normalSize)),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.blackColor,
            scrolledUnderElevation: 0,
            elevation: 0,
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
