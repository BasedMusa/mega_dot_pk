import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/widgets/native_icons.dart';

class BrandedErrorLogo extends StatelessWidget {
  final bool showRefreshIcon;
  final backgroundIsCard;

  BrandedErrorLogo({this.showRefreshIcon = false,this.backgroundIsCard = false});

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "////",
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w700,
                fontSize: sizeConfig.text(35),
                color: Theme.of(context).errorColor,
              ),
            ),
          ),
          Positioned(
            right: -3,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundIsCard?Theme.of(context).cardColor:Theme.of(context).canvasColor,
              ),
              child: showRefreshIcon
                  ? Icon(
                      NativeIcons.refresh(),
                      color: Theme.of(context).errorColor,
                    )
                  : Container(),
            ),
          ),
        ],
      );
}
