import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/globals.dart';

class BrandedErrorLogo extends StatelessWidget {
  final bool showRefreshIcon;

  BrandedErrorLogo({this.showRefreshIcon = false});

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Text(
            "////",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              letterSpacing: -2,
              fontSize: sizeConfig.text(35),
              color: Theme.of(context).errorColor,
            ),
          ),
          Positioned(
            right: -3,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).canvasColor,
              ),
              child: showRefreshIcon
                  ? Icon(
                      defaultTargetPlatform == TargetPlatform.iOS
                          ? CupertinoIcons.refresh
                          : Icons.refresh,
                      color: Theme.of(context).errorColor,
                    )
                  : Container(),
            ),
          ),
        ],
      );
}
