import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/constants.dart';

class SlideUpPageRoute<T> extends PageRouteBuilder<T> {
  final Widget child;

  SlideUpPageRoute({
    Key key,
    @required this.child,
    RouteSettings settings,
  }) : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return child;
          },
          transitionDuration: Constants.animationDuration,
          settings: settings,
          transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) =>
              SlideTransition(
            transformHitTests: false,
            position: Tween<Offset>(
              begin: const Offset(0.0, 1.0),
              end: Offset.zero,
            ).animate(animation),
            child: new SlideTransition(
              position: new Tween<Offset>(
                begin: Offset.zero,
                end: const Offset(0.0, -1.0),
              ).animate(secondaryAnimation),
              child: child,
            ),
          ),
        );
}
