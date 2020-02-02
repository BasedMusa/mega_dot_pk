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
        vertical: sizeConfig.height(.0185),
      ),
      child: DefaultTextStyle(
        style: Theme.of(context).textTheme.subtitle.copyWith(
              color: Theme.of(context).canvasColor,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: sizeConfig.width(.06),
          ),
          padding: EdgeInsets.symmetric(
            vertical: sizeConfig.height(.01),
            horizontal: sizeConfig.width(.05),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: onTap != null
                ? Color(0xFFFFA23F)
                : Theme.of(context).disabledColor,
          ),
          child: Center(child: Text(text)),
        ),
      ),
    );

    return _isIOS
        ? CupertinoButton(
            color: Theme.of(context).cupertinoOverrideTheme.primaryColor,
            borderRadius: BorderRadius.circular(12),
            padding: EdgeInsets.zero,
            onPressed: onTap,
            child: Container(
              child: _content,
            ),
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
