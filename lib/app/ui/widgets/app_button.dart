import 'package:flutter/material.dart';
import 'package:flutter_ytdlp/app/ui/styles/colors.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final bool disabled;

  const AppButton({
    super.key,
    required this.text,
    required this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: !disabled ? onTap : null,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: !disabled ? AppColors.primaryColor : AppColors.disabledColor,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
                color: !disabled
                    ? AppColors.primaryTextColor
                    : AppColors.secondaryTextColor,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
