import 'package:flutter/material.dart';

class SlidePageRoute extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;
  final Duration duration;

  SlidePageRoute({
    super.settings,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.direction = AxisDirection.left,
  }) : super(
         pageBuilder:
             (
               BuildContext context,
               Animation<double> animation,
               Animation<double> secondaryAnimation,
             ) => child,
         transitionDuration: duration, // Adjust duration as needed
         transitionsBuilder:
             (
               BuildContext context,
               Animation<double> animation,
               Animation<double> secondaryAnimation,
               Widget child,
             ) {
               Offset beginOffset;
               switch (direction) {
                 case AxisDirection.up:
                   beginOffset = Offset(0, 1);
                   break;
                 case AxisDirection.down:
                   beginOffset = Offset(0, -1);
                   break;
                 case AxisDirection.left:
                   beginOffset = Offset(1, 0);
                   break;
                 case AxisDirection.right:
                   beginOffset = Offset(-1, 0);
                   break;
               }

               final tween = Tween(begin: beginOffset, end: Offset.zero);
               final curvedAnimation = CurvedAnimation(
                 parent: animation,
                 curve: Curves.easeInOut, // Choose your curve
               );

               return SlideTransition(
                 position: tween.animate(curvedAnimation),
                 child: child,
               );
             },
       );
}
