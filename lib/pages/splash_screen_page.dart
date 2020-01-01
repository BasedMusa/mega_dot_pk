import 'package:flutter/material.dart';
import 'package:mega_dot_pk/pages/home_page.dart';
import 'package:mega_dot_pk/pages/account_page.dart';
import 'package:mega_dot_pk/utils/authentication_provider.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/size_config.dart';
import 'package:mega_dot_pk/widgets/branded_loading_indicator.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    _initApp();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    sizeConfig = SizeConfig.init(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _body(),
      );

  _body() => Container(
        child: Center(
          child: BrandedLoadingIndicator(),
        ),
      );

  Future<void> _initApp() async {
    AuthenticationProvider _auth = await AuthenticationProvider.autoLogin();
    auth = _auth;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => auth != null && auth.isAuthorized
            ? HomePage()
            : AccountPage(initialPage: true),
      ),
    );
  }
}
