import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mega_dot_pk/utils/globals.dart';

class StyledContextMenu {
  static show(context,
      {EdgeInsets padding = EdgeInsets.zero,
      List<StyledContextMenuAction> actions}) {
    assert(actions != null && actions.isNotEmpty);

    ///iOS Only Dialog
    defaultTargetPlatform == TargetPlatform.iOS || Platform.isIOS
        ? showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => Padding(
              padding: padding ?? EdgeInsets.zero,
              child: CupertinoActionSheet(
                cancelButton: CupertinoActionSheetAction(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Close"),
                  isDefaultAction: true,
                ),
                actions: List<Widget>.generate(
                  (actions ?? []).length,
                  (i) => actions[i].isEmpty()
                      ? Container()
                      : CupertinoActionSheetAction(
                          onPressed: actions[i].onTap,
                          child: Text(
                            actions[i].text,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.subtitle2.color,
                            ),
                          ),
                          isDestructiveAction: actions[i].isDestructiveAction,
                        ),
                ),
              ),
            ),
          )
        :

        ///Other Platforms Dialog
        showModalBottomSheet(
            context: context,
            shape: BeveledRectangleBorder(),
            builder: (context) => Container(
              color: Theme.of(context).cardColor,
              child: Padding(
                padding: EdgeInsets.only(
                  top: sizeConfig.height(.02),
                  bottom: sizeConfig.height(.02) + sizeConfig.safeArea.bottom,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List<Widget>.generate(
                    actions.length,
                    (i) => !(actions[i].isEmpty())
                        ? Material(
                            color: Theme.of(context).cardColor,
                            child: InkWell(
                              onTap: actions[i].onTap,
                              child: Container(
                                width: double.maxFinite,
                                padding: EdgeInsets.symmetric(
                                  vertical: sizeConfig.height(.03),
                                  horizontal: sizeConfig.width(.05),
                                ),
                                child: Row(
                                  children: <Widget>[
                                    Icon(actions[i].iconData),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: sizeConfig.width(.035),
                                      ),
                                      child: Text(
                                        actions[i].text,
                                        style: Theme.of(context)
                                            .primaryTextTheme
                                            .subtitle2
                                            .copyWith(
                                              fontWeight:
                                                  actions[i].isDestructiveAction
                                                      ? FontWeight.w700
                                                      : null,
                                              color: actions[i]
                                                      .isDestructiveAction
                                                  ? Theme.of(context).errorColor
                                                  : null,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ),
                ),
              ),
            ),
          );
  }
}

class StyledContextMenuAction {
  String text;
  IconData iconData;
  VoidCallback onTap;
  bool isDestructiveAction;

  StyledContextMenuAction(
      {@required this.text,
      @required this.iconData,
      this.onTap,
      this.isDestructiveAction = false});

  static get empty => StyledContextMenuAction(text: null, iconData: null);

  bool isEmpty() => text == null ? true : false;
}
