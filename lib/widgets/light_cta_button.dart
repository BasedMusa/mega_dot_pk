import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/globals.dart';

class LightCTAButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final bool multiline;
  final Color color;

  LightCTAButton({
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
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(
          top: sizeConfig.height(.02),
        ),
        child: Material(
          color: _color(context).withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            splashColor: _color(context).withOpacity(.175),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: sizeConfig.width(.06),
                vertical: sizeConfig.height(.025),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  text != null
                      ? Expanded(
                          child: Align(
                            alignment: icon == null
                                ? Alignment.center
                                : Alignment.centerLeft,
                            child: Text(
                              text,
                              style:
                                  Theme.of(context).textTheme.button.copyWith(
                                        color: _color(context),
                                        fontWeight: FontWeight.w600,
                                      ),
                            ),
                          ),
                        )
                      : Container(),
                  icon != null
                      ? Padding(
                          padding:
                              EdgeInsets.only(left: sizeConfig.width(.025)),
                          child: Icon(
                            icon,
                            color: _color(context),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      );

  Color _color(BuildContext context) => onTap != null
      ? color ?? Theme.of(context).primaryColor
      : Theme.of(context).disabledColor;
}
