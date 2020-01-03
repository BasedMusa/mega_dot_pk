import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SearchIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Icon(iconData());

  static IconData iconData() => defaultTargetPlatform == TargetPlatform.iOS
      ? CupertinoIcons.search
      : Icons.search;
}
