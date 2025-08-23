import 'package:flutter/material.dart';
import 'package:flutter_ytdlp/app/ui/styles/colors.dart';

class LoadingButton extends StatefulWidget {
  final String text;
  final String endText;
  final VoidCallback onTap;
  final double width;
  final double perc;
  final bool disabled;

  const LoadingButton({
    super.key,
    required this.text,
    required this.endText,
    required this.onTap,
    required this.width,
    double? perc,
    this.disabled = false,
  }) : perc = perc ?? 0;

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> heightAnimation;
  late Animation<double> opacityAnimation;
  late Animation<double> widthAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    opacityAnimation = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(0, .3, curve: Curves.easeInOut),
      ),
    );

    heightAnimation = Tween<double>(begin: 40, end: 7).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(.15, .7, curve: Curves.easeOut),
        reverseCurve: Interval(.5, 1, curve: Curves.easeOut),
      ),
    );

    widthAnimation =
        Tween<double>(begin: widget.width / 2, end: widget.width).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(.4, 1, curve: Curves.easeOutCubic),
        reverseCurve: Interval(.4, 1, curve: Curves.easeInCubic),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.perc >= 1) controller.reverse();
    return GestureDetector(
      onTap: !widget.disabled ? onTap : null,
      child: Align(
        alignment: Alignment.centerRight,
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Container(
              height: heightAnimation.value,
              width: widthAnimation.value,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: !widget.disabled
                    ? Color.lerp(AppColors.primaryColor,
                        AppColors.containerColor, controller.value)
                    : AppColors.disabledColor,
              ),
              child: Stack(
                children: [
                  LayoutBuilder(builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      height: heightAnimation.value,
                      width: width * widget.perc,
                    );
                  }),
                  Center(
                    child: Opacity(
                      opacity: opacityAnimation.value,
                      child: Text(
                        widget.perc < 1 ? widget.text : widget.endText,
                        style: TextStyle(
                            color: !widget.disabled
                                ? AppColors.primaryTextColor
                                : AppColors.secondaryTextColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void onTap() async {
    controller.forward();
    widget.onTap();
  }
}
