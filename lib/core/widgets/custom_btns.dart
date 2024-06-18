import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/fonts.dart';
import '../providers/provider_variables.dart';

class CustomIconBtn extends ConsumerWidget {
  const CustomIconBtn({
    super.key,
    this.width,
    required this.text,
    required this.textColor,
    required this.btnColor,
    required this.fontSize,
    required this.icon,
    this.padding,
    this.borderRadius,
    this.actionBtn = false,
    required this.onPressed,
  });

  final double? width;
  final bool actionBtn;
  final String text;
  final Color textColor;
  final Color btnColor;
  final double fontSize;
  final Widget icon;
  final Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonLoadingProvider = ref.watch(buttonLoadingNotifierProvider);
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(btnColor),
            padding: WidgetStatePropertyAll(
              padding ??
                   EdgeInsets.symmetric(vertical: 10.h, horizontal: 15),
            ),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: borderRadius ??
                    BorderRadius.circular(99.0), // Adjust the value as needed
              ),
            )),
        onPressed: onPressed,
        child: actionBtn
            ? Center(
                child: !buttonLoadingProvider
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          icon,
                          SizedBox(width: 5.w),
                          Text(
                            text,
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.normal,
                              fontFamily: AppFonts.actionFont,
                              fontSize: fontSize,
                            ),
                          ).animate().fadeIn(),
                        ],
                      )
                    : SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.5,
                          color: textColor.withOpacity(.8),
                        ),
                      ).animate().fadeIn(),
              )
            : Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    icon,
                    SizedBox(width: 5.w),
                    Text(
                      text,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSize,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(),
      ),
    );
  }
}

class CustomBtn extends ConsumerWidget {
  const CustomBtn({
    super.key,
    this.width,
    required this.text,
    required this.textColor,
    required this.btnColor,
    required this.fontSize,
    this.padding,
    this.borderRadius,
    this.actionBtn = false,
    required this.onPressed,
  });

  final double? width;
  final bool actionBtn;
  final String text;
  final Color textColor;
  final Color btnColor;
  final double fontSize;
  final Function()? onPressed;
  final EdgeInsetsGeometry? padding;
  final BorderRadiusGeometry? borderRadius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonLoadingProvider = ref.watch(buttonLoadingNotifierProvider);
    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(btnColor),
            padding: MaterialStatePropertyAll(
              padding ??
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            ),
            shape: MaterialStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: borderRadius ??
                    BorderRadius.circular(99.0), // Adjust the value as needed
              ),
            )),
        onPressed: onPressed,
        child: actionBtn
            ? Center(
                child: !buttonLoadingProvider
                    ? Text(
                        text,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.normal,
                          fontFamily: AppFonts.actionFont,
                          fontSize: fontSize,
                        ),
                      ).animate().fadeIn()
                    : SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.5,
                          color: textColor.withOpacity(.8),
                        ),
                      ).animate().fadeIn(),
              )
            : Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ).animate().fadeIn(),
      ),
    );
  }
}

class OutlinedCustomBtn extends ConsumerWidget {
  const OutlinedCustomBtn({
    super.key,
    this.width,
    required this.text,
    required this.textColor,
    required this.btnColor,
    required this.fontSize,
    this.padding,
    this.actionBtn = false,
    required this.onPressed,
  });

  final double? width;
  final bool actionBtn;
  final String text;
  final Color textColor;
  final Color btnColor;
  final double fontSize;
  final Function()? onPressed;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final buttonLoadingProvider = ref.watch(buttonLoadingNotifierProvider);
    return SizedBox(
      width: width,
      child: OutlinedButton(
        style: ButtonStyle(
          side: MaterialStateProperty.all<BorderSide>(
            BorderSide(
              color: btnColor,
              width: 1,
            ),
          ),
          padding: MaterialStatePropertyAll(
            padding ?? const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
          ),
        ),
        onPressed: onPressed,
        child: actionBtn
            ? Center(
                child: !buttonLoadingProvider
                    ? Text(
                        text,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                        ),
                      ).animate().fadeIn()
                    : SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.5,
                          color: textColor.withOpacity(.8),
                        ),
                      ).animate().fadeIn(),
              )
            : Center(
                child: Text(
                  text,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                ),
              ).animate().fadeIn(),
      ),
    );
  }
}
