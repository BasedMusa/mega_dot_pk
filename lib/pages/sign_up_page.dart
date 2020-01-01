import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mega_dot_pk/utils/constants.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/widgets/light_cta_button.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _obscureText = true;

  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _reTypePasswordController;

  GlobalKey<FormState> _emailFormKey = GlobalKey();
  GlobalKey<FormState> _passwordFormKey = GlobalKey();

  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _body(),
      );

  _body() => PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[
          _emailPage(),
          _passwordPage(),
        ],
      );

  _emailPage() => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          padding: EdgeInsets.only(
            right: sizeConfig.width(.06),
            left: sizeConfig.width(.06),
            top: sizeConfig.height(.035) + sizeConfig.safeArea.top,
            bottom: sizeConfig.height(.05) + sizeConfig.safeArea.bottom,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  _navigationIconButton(onTap: () => Navigator.pop(context)),
                  Padding(
                    padding: EdgeInsets.only(
                      left: sizeConfig.width(.05),
                    ),
                    child: Text(
                      "Sign Up",
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                ],
              ),
              Form(
                key: _emailFormKey,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: sizeConfig.height(.06),
                  ),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.alternate_email),
                      hintText: "Email",
                    ),
                    validator: (String input) => null,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: sizeConfig.height(.04),
                ),
                child: LightCTAButton(
                  onTap: () => _pageController.animateToPage(1,
                      duration: Constants.animationDuration,
                      curve: Curves.easeInOut),
                  text: "Next",
                  icon: Icons.arrow_forward_ios,
                ),
              ),
            ],
          ),
        ),
      );

  _passwordPage() => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Container(
          padding: EdgeInsets.only(
            right: sizeConfig.width(.06),
            left: sizeConfig.width(.06),
            top: sizeConfig.height(.035) + sizeConfig.safeArea.top,
            bottom: sizeConfig.height(.05) + sizeConfig.safeArea.bottom,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Form(
            key: _passwordFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    _navigationIconButton(
                      icon: Platform.isIOS
                          ? Icons.arrow_back_ios
                          : Icons.arrow_back,
                      onTap: () => _pageController.animateToPage(0,
                          duration: Constants.animationDuration,
                          curve: Curves.easeInOut),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: sizeConfig.width(.05),
                      ),
                      child: Text(
                        "Set A Password",
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: sizeConfig.height(.05),
                  ),
                  child: TextFormField(
                    obscureText: _obscureText,
                    controller: _passwordController,
                    validator: (String input) => null,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: "Password",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: sizeConfig.height(.06),
                  ),
                  child: TextFormField(
                    obscureText: _obscureText,
                    controller: _reTypePasswordController,
                    validator: (String input) => null,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock_outline),
                      hintText: "Retype Password",
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: sizeConfig.height(.04),
                  ),
                  child: LightCTAButton(
                    onTap: () => Navigator.pop(context),
                    text: "Register",
                    icon: Icons.check,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  _navigationIconButton({IconData icon, VoidCallback onTap}) => Material(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(
                icon ?? Icons.clear,
                color: Colors.black,
              ),
            ),
          ),
        ),
      );
}
