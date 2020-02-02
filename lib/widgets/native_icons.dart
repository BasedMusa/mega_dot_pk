import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NativeIcons {
  static IconData search() => defaultTargetPlatform == TargetPlatform.iOS
      ? CupertinoIcons.search
      : Icons.search;

  static IconData home() => defaultTargetPlatform == TargetPlatform.iOS
      ? CupertinoIcons.home
      : Icons.home;

  static IconData browse() => defaultTargetPlatform == TargetPlatform.iOS
      ? CupertinoIcons.collections
      : Icons.shopping_basket;

  static IconData browseSolid() => defaultTargetPlatform == TargetPlatform.iOS
      ? CupertinoIcons.collections_solid
      : Icons.shopping_basket;

  static IconData favorite() => defaultTargetPlatform == TargetPlatform.iOS
      ? CupertinoIcons.heart
      : Icons.favorite_border;

  static IconData favoriteSolid() => defaultTargetPlatform == TargetPlatform.iOS
      ? CupertinoIcons.heart_solid
      : Icons.favorite;

  static IconData person() => defaultTargetPlatform == TargetPlatform.iOS
      ? CupertinoIcons.person
      : Icons.person_outline;

  static IconData personSolid() => defaultTargetPlatform == TargetPlatform.iOS
      ? CupertinoIcons.person_solid
      : Icons.person;

  static IconData callSolid() => defaultTargetPlatform == TargetPlatform.iOS
      ? Icons.call
      : Icons.call;

  static IconData refresh() => defaultTargetPlatform == TargetPlatform.iOS
      ? CupertinoIcons.refresh
      : Icons.refresh;

  static IconData back() => defaultTargetPlatform == TargetPlatform.iOS
      ? CupertinoIcons.back
      : Icons.arrow_back;
}
