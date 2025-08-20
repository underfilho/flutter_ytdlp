import 'package:flutter/material.dart';
import 'package:flutter_ytdlp/app/ui/colors.dart';

const _thumbSize = 20.0;
const _padSize = 4.0;

class AppSwitch extends StatelessWidget {
  final ValueChanged<bool> onChanged;
  final bool enabled;
  final String? label;

  const AppSwitch(
      {super.key, required this.onChanged, required this.enabled, this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!enabled),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 100),
            decoration: BoxDecoration(
              color:
                  enabled ? AppColors.primaryColor : AppColors.containerColor,
              borderRadius: BorderRadius.circular(30),
            ),
            width: (_thumbSize + _padSize) * 2,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
              padding: EdgeInsets.all(_padSize),
              child: Container(
                width: _thumbSize,
                height: _thumbSize,
                decoration: BoxDecoration(
                    shape: BoxShape.circle, color: AppColors.primaryTextColor),
              ),
            ),
          ),
          if (label != null) ...[
            SizedBox(width: 10),
            Text(
              label!,
              style: TextStyle(
                  color: AppColors.primaryTextColor,
                  fontWeight: FontWeight.bold),
            ),
          ]
        ],
      ),
    );
  }
}
