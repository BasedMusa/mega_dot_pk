import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/globals.dart';

class LightCTAButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  LightCTAButton({
    this.icon,
    this.text,
    @required this.onTap,
    this.color,
  }) {
    assert(this.icon != null || this.text != null, "You need to assign either an icon or text.");
  }

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(
          top: sizeConfig.height(.02),
        ),
        child: Material(
          color: _color(context).withOpacity(0.15),
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            splashColor: _color(context).withOpacity(.175),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: sizeConfig.width(.06),
                vertical: sizeConfig.height(.025),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  text != null
                      ? Text(
                          text,
                          style: Theme.of(context).textTheme.button.copyWith(
                                color: _color(context),
                                fontWeight: FontWeight.w600,
                              ),
                        )
                      : Container(),
                  text != null && icon != null ? Spacer() : Container(),
                  icon != null
                      ? Icon(
                          icon,
                          color: _color(context),
                        )
                      : Container(),
                ],
              ),
            ),
          ),
        ),
      );

  Color _color(BuildContext context) => color ?? Theme.of(context).primaryColor;
}
