import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mega_dot_pk/pages/home_page.dart';
import 'package:mega_dot_pk/pages/login_page.dart';
import 'package:mega_dot_pk/pages/sign_up_page.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/widgets/light_cta_button.dart';
import 'package:mega_dot_pk/widgets/slide_up_page_route.dart';

class AccountPage extends StatefulWidget {
  final bool initialPage;

  AccountPage({this.initialPage = false});

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _body(),
      );

  _body() => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                "https://images.pexels.com/photos/973506/pexels-photo-973506.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260",
              ),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: sizeConfig.width(.05),
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: sizeConfig.height(.035) + sizeConfig.safeArea.top,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: _navigationIconButton(
                  onTap: () => widget.initialPage
                      ? Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(),
                          ),
                        )
                      : Navigator.pop(context),
                ),
              ),
              Spacer(),
              _signUpButton(),
              _logInButton(),
              Padding(
                padding: EdgeInsets.only(
                  bottom: sizeConfig.safeArea.bottom + sizeConfig.height(.05),
                ),
              ),
            ],
          ),
        ),
      );

  _signUpButton() => Container(
        width: double.maxFinite,
        child: LightCTAButton(
          text: "Sign Up",
          onTap: () => Navigator.push(
            context,
            SlideUpPageRoute(
              child: SignUpPage(),
            ),
          ),
          color: Colors.white,
        ),
      );

  _logInButton() => Container(
        margin: EdgeInsets.only(
          top: sizeConfig.height(.02),
        ),
        child: InkWell(
          onTap: () => Navigator.push(
            context,
            SlideUpPageRoute(
              child: LoginPage(),
            ),
          ),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: sizeConfig.width(.06),
              vertical: sizeConfig.height(.025),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: Colors.white,
            ),
            child: Center(
              child: Text(
                "Log In",
                style: Theme.of(context).textTheme.button.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
        ),
      );

  _navigationIconButton({IconData icon, VoidCallback onTap}) => Material(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white.withOpacity(.25),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(
                icon ?? Icons.clear,
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
}
