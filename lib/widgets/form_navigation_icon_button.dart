import 'package:flutter/material.dart';

class FormNavigationIconButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;

  FormNavigationIconButton({this.onTap, this.icon});

  @override
  Widget build(BuildContext context) => Material(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(
                icon ?? Icons.clear,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
}
