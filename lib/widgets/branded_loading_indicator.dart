import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mega_dot_pk/utils/constants.dart';
import 'package:mega_dot_pk/utils/globals.dart';

class BrandedLoadingIndicator extends StatefulWidget {
  @override
  _BrandedLoadingIndicatorState createState() =>
      _BrandedLoadingIndicatorState();
}

class _BrandedLoadingIndicatorState extends State<BrandedLoadingIndicator>
    with SingleTickerProviderStateMixin {
  Animation animation;
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0, end: 1).animate(animationController)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      });

    animationController.repeat(min: 0, max: 1, reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Center(
        child: Container(
          child: AnimatedDefaultTextStyle(
            duration: Constants.animationDuration,
            style: TextStyle(
              color: Color.lerp(
                  Theme.of(context).iconTheme.color.withOpacity(.05),
                  Theme.of(context).iconTheme.color.withOpacity(.7),
                  animation.value),
            ),
            child: Text(
              "////",
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w700,
                letterSpacing: 0,
                fontSize: sizeConfig.text(35),
              ),
            ),
          ),
        ),
      );
}
