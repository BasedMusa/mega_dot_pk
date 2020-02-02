import 'package:flutter/material.dart';
import 'package:mega_dot_pk/pages/home_page.dart';
import 'package:mega_dot_pk/pages/account_page.dart';
import 'package:mega_dot_pk/blocs/authentication_provider_bloc.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/size_config.dart';
import 'package:mega_dot_pk/widgets/branded_loading_indicator.dart';
import 'package:provider/provider.dart';

class SplashScreenPage extends StatefulWidget {
  @override
  _SplashScreenPageState createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void didChangeDependencies() {
    sizeConfig = SizeConfig.init(context);
    _initApp();

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
    AuthenticationProviderBLOC auth =
        Provider.of<AuthenticationProviderBLOC>(context);

    await auth.autoLogin();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) =>
            auth.isAuthorized ? HomePage() : AccountPage(initialPage: true),
      ),
    );
  }
}
