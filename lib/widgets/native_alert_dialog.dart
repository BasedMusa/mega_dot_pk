import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NativeAlertDialog {
  static Future<dynamic> show(BuildContext context,
      {@required String title,
      @required String content,
      List<NativeAlertDialogAction> actions}) {
    bool _isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    return _isIOS
        ? showCupertinoDialog(
            context: context,
            builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(title),
              content: Text(content),
              actions: actions
                      ?.map(
                        (NativeAlertDialogAction action) =>
                            CupertinoDialogAction(
                          child: Text(action.text),
                          isDestructiveAction: action.isDestructive,
                          isDefaultAction: action.isDefault,
                          onPressed: action.onTap,
                        ),
                      )
                      ?.toList() ??
                  [],
            ),
          )
        : showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: actions
                      ?.map(
                        (NativeAlertDialogAction action) => FlatButton(
                          child: Text(
                            action.text,
                            style: TextStyle(
                                color: action.isDestructive
                                    ? Theme.of(context).errorColor
                                    : null,
                                fontWeight:
                                    action.isDefault ? FontWeight.w700 : null),
                          ),
                          onPressed: action.onTap,
                        ),
                      )
                      ?.toList() ??
                  [],
            ),
          );
  }
}

class NativeAlertDialogAction {
  String text;
  VoidCallback onTap;
  bool isDestructive;
  bool isDefault;

  NativeAlertDialogAction(
      {@required this.text,
      this.onTap,
      this.isDestructive = false,
      this.isDefault = false});
}
