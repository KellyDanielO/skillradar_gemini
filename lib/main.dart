import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';


import 'package:firebase_core/firebase_core.dart';

import 'core/constants/colors.dart';

import 'core/constants/router.dart';
import 'core/constants/sizes.dart';
import 'core/providers/provider_variables.dart';
import 'l10n/l10n.dart';
import 'firebase_options.dart';


void main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final languageProvider = ref.watch(languageNotifierProvider);
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp.router(
        title: 'Skill Radar',
        builder: FToastBuilder(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
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
        supportedLocales: L10n.all,
        locale: languageProvider,
        routerConfig: AppRouter.router,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
      ),
    );
  }
}
