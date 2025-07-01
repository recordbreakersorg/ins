import 'package:flutter/material.dart';

class FadePageRoute extends PageRouteBuilder {
  final Function(BuildContext) builder;
  final Duration duration;
  FadePageRoute({
    super.settings,
    required this.builder,
    this.duration = const Duration(milliseconds: 100),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) =>
             builder(context),
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           const curve = Curves.easeInOut;
           final curvedAnimation = CurvedAnimation(
             parent: animation,
             curve: curve,
           );
           return FadeTransition(opacity: curvedAnimation, child: child);
         },
         transitionDuration: const Duration(milliseconds: 400),
       );
}
