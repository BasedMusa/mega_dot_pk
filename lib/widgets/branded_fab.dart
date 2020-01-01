import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/globals.dart';

class BrandedFAB extends StatefulWidget {
  final IconData icon;
  final VoidCallback onPressed;

  BrandedFAB({@required this.icon, this.onPressed});

  @override
  _BrandedFABState createState() => _BrandedFABState();
}

class _BrandedFABState extends State<BrandedFAB> {
  @override
  Widget build(BuildContext context) => Container(
        margin: sizeConfig.safeArea,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.onPressed != null
              ? Theme.of(context).primaryColor
              : Theme.of(context).disabledColor.withOpacity(.15),
        ),
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Icon(
              widget.icon,
              color: widget.onPressed != null
                  ? Theme.of(context).canvasColor
                  : Theme.of(context).disabledColor,
              size: 35,
            ),
          ),
        ),
      );
}
