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
            color: Color(0xFFFFA23F),
          ),
          child: Text(text),
        ),
      ),
    );

    return _isIOS
        ? Material(
            borderRadius: BorderRadius.circular(18),
            color: Theme.of(context).primaryColor,
            child: InkWell(
              onTap: onTap,
              splashColor: Colors.white.withOpacity(.5),
              borderRadius: BorderRadius.circular(18),
              child: _content,
            ),
          )
        : CupertinoButton(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(18),
            padding: EdgeInsets.zero,
            onPressed: onTap,
            child: _content,
          );
  }
}
