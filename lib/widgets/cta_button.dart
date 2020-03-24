import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/globals.dart';

class CTAButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  CTAButton({@required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    bool _isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    Widget _content = Container(
      padding: EdgeInsets.symmetric(
        vertical: sizeConfig.height(.02),
        horizontal: sizeConfig.width(.05),
      ),
      margin: EdgeInsets.symmetric(
        horizontal: sizeConfig.width(.06),
      ),
      child: Text(
        text,
        style: Theme.of(context).primaryTextTheme.button,
      ),
    );

    return _isIOS
        ? CupertinoButton(
            color: Theme.of(context).cupertinoOverrideTheme.primaryColor,
            borderRadius: BorderRadius.circular(12),
            padding: EdgeInsets.zero,
            onPressed: onTap,
            child: _content,
          )
        : Material(
            borderRadius: BorderRadius.circular(12),
            color: onTap != null
                ? Theme.of(context).primaryColor
                : Theme.of(context).disabledColor,
            child: InkWell(
              onTap: onTap,
              splashColor: Colors.white.withOpacity(.5),
              borderRadius: BorderRadius.circular(12),
              child: _content,
            ),
          );
  }
}
