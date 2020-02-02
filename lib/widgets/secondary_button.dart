import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/mixins.dart';

class SecondaryButton extends StatelessWidget with PlatformBoolMixin {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool multiline;
  final Color color;

  SecondaryButton({
    this.icon,
    this.text,
    this.multiline = false,
    @required this.onTap,
    this.color,
  }) {
    assert(this.icon != null || this.text != null,
        "You need to assign either an icon or text.");
  }

  @override
  Widget build(BuildContext context) {
    Widget _content = Container(
      padding: EdgeInsets.symmetric(
        horizontal: sizeConfig.width(.06),
        vertical: sizeConfig.height(.025),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: _color(context).withOpacity(.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          text != null
              ? Expanded(
                  child: Align(
                    alignment:
                        icon == null ? Alignment.center : Alignment.centerLeft,
                    child: Text(
                      text,
                      style: Theme.of(context).textTheme.button.copyWith(
                            color: _color(context),
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                )
              : Container(),
          icon != null
              ? Padding(
                  padding: text != null
                      ? EdgeInsets.only(left: sizeConfig.width(.025))
                      : EdgeInsets.zero,
                  child: Icon(
                    icon,
                    color: _color(context),
                  ),
                )
              : Container(),
        ],
      ),
    );

    return Container(
      margin: EdgeInsets.only(
        top: sizeConfig.height(.02),
      ),
      child: isIOS
          ? CupertinoButton(
              color: Theme.of(context).canvasColor,
              onPressed: onTap,
              borderRadius: BorderRadius.circular(12),
              padding: EdgeInsets.zero,
              child: _content,
            )
          : Material(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(12),
                splashColor: _color(context).withOpacity(.175),
                child: _content,
              ),
            ),
    );
  }

  Color _color(BuildContext context) => onTap != null
      ? color ?? Theme.of(context).primaryColor
      : Theme.of(context).disabledColor;
}
