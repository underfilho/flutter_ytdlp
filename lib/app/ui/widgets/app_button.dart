import 'package:flutter/material.dart';
import 'package:flutter_ytdlp/app/ui/colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const AppButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.primaryColor,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: AppColors.primaryTextColor),
          ),
        ),
      ),
    );
  }
}
