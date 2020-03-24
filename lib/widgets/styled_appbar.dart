import 'package:flutter/material.dart';

class StyledAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titleText;
  final bool centerTitle;
  final Widget trailing;

  StyledAppBar(this.titleText, {this.centerTitle, this.trailing});

  @override
  Widget build(BuildContext context) => Container(
        child: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: Text(this.titleText),
          centerTitle: this.centerTitle,
          actions: trailing != null ? <Widget>[trailing] : null,
        ),
      );

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
