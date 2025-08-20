import 'package:flutter/material.dart';
import 'package:flutter_ytdlp/app/ui/colors.dart';

class InputText extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final String? hint;
  final Widget? rightIcon;
  final FocusNode? focusNode;

  const InputText(
      {super.key,
      this.onChanged,
      this.controller,
      this.hint,
      this.rightIcon,
      this.focusNode});

  @override
  Widget build(BuildContext context) {
    return TextSelectionTheme(
      data: TextSelectionThemeData(
        cursorColor: AppColors.primaryColor,
        selectionColor: AppColors.primaryColor,
        selectionHandleColor: AppColors.primaryColor,
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.containerColor,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none),
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.secondaryTextColor),
          suffixIcon: rightIcon,
        ),
        onChanged: onChanged,
        focusNode: focusNode,
        style: TextStyle(color: AppColors.primaryTextColor),
      ),
    );
  }
}
