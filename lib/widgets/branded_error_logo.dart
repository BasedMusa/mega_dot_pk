import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/globals.dart';

class BrandedErrorLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Text(
        "////",
        style: TextStyle(
          fontWeight: FontWeight.w900,
          letterSpacing: -2,
          fontSize: sizeConfig.text(35),
          color: Theme.of(context).errorColor,
        ),
      );
}
