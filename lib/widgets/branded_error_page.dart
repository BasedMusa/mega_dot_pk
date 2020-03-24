import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/branded_error_logo.dart';
import 'package:mega_dot_pk/widgets/native_icons.dart';

class BrandedErrorPage extends StatefulWidget {
  final AsyncTaskStatus status;
  final VoidCallback onTap;

  BrandedErrorPage(this.status, this.onTap);

  @override
  _BrandedErrorPageState createState() => _BrandedErrorPageState();
}

class _BrandedErrorPageState extends State<BrandedErrorPage> {
  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              child: BrandedErrorLogo(
                showRefreshIcon: false,
              ),
            ),
            Container(
              child: Padding(
                padding: EdgeInsets.only(
                  top: sizeConfig.height(.02),
                ),
                child: Text(
                  "${widget.status.errorMessage}",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: -2,
                    fontWeight: FontWeight.w600,
                    fontSize: sizeConfig.text(30),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: sizeConfig.height(.02),
              ),
              child: defaultTargetPlatform == TargetPlatform.iOS
                  ? Theme(
                      data: Theme.of(context).copyWith(
                        cupertinoOverrideTheme: CupertinoThemeData(
                          primaryColor: Theme.of(context).errorColor,
                        ),
                      ),
                      child: CupertinoButton.filled(
                        onPressed: widget.onTap,
                        child: Text(
                          "Retry",
                          style: Theme.of(context).primaryTextTheme.button,
                        ),
                      ),
                    )
                  : RaisedButton.icon(
                      color: Theme.of(context).errorColor,
                      onPressed: widget.onTap,
                      elevation: 0,
                      label: Text(
                        "Retry",
                        style: Theme.of(context).primaryTextTheme.button,
                      ),
                      icon: Icon(
                        NativeIcons.refresh(),
                        color: Theme.of(context).primaryTextTheme.button.color,
                      ),
                    ),
            ),
          ],
        ),
      );
}
