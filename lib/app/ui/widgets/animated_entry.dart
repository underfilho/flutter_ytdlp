import 'package:flutter/material.dart';

class AnimatedEntry extends StatelessWidget {
  final WidgetBuilder builder;
  final bool isEntered;

  const AnimatedEntry(
      {super.key, required this.builder, required this.isEntered});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        );

        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: curvedAnimation,
            axisAlignment: -1,
            axis: Axis.vertical,
            child: child,
          ),
        );
      },
      child: isEntered ? builder(context) : SizedBox.shrink(),
    );
  }
}
