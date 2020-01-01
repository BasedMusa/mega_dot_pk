import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/branded_error_logo.dart';

class BrandedErrorPage extends StatefulWidget {
  final AsyncTaskStatus status;
  final VoidCallback onTap;

  BrandedErrorPage(this.status, this.onTap);

  @override
  _BrandedErrorPageState createState() => _BrandedErrorPageState();
}

class _BrandedErrorPageState extends State<BrandedErrorPage> {
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: widget.onTap,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              BrandedErrorLogo(),
              Padding(
                padding: EdgeInsets.only(
                  top: sizeConfig.height(.01),
                ),
                child: Text(
                  "${widget.status.errorMessage}\nTap to try again.",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .subtitle
                      .copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      );
}
