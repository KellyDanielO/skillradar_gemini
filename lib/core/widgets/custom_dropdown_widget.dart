
import 'package:flutter/material.dart';

import '../constants/colors.dart';

class CustomDropdownFormField<T> extends StatelessWidget {
  final List<DropdownMenuItem<T>> items;
  final T value;
  final String hint;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final String? label;

  const CustomDropdownFormField({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.hint = '',
    this.validator,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.whiteColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      value: value,
      hint: Text(hint),
      onChanged: onChanged,
      validator: validator,
      items: items,
      dropdownColor: AppColors.blackColor,
      style: const TextStyle(color: AppColors.whiteColor),
      iconEnabledColor: AppColors.whiteColor,
    );
  }
}