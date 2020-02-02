import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mega_dot_pk/blocs/authentication_provider_bloc.dart';
import 'package:mega_dot_pk/pages/home_page.dart';
import 'package:mega_dot_pk/pages/sign_in_page.dart';
import 'package:mega_dot_pk/utils/constants.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/cta_button.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/widgets/secondary_button.dart';
import 'package:mega_dot_pk/widgets/slide_up_page_route.dart';
import 'package:provider/provider.dart';

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
        value: SystemUiOverlayStyle.dark,
        child: Container(
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
                child: _navigationIconButton(onTap: _goToHomePage),
              ),
              Spacer(),
              _signInButton(),
              Padding(
                padding: EdgeInsets.only(
                  bottom: sizeConfig.safeArea.bottom + sizeConfig.height(.05),
                ),
              ),
            ],
          ),
        ),
      );

  _signInButton() => Container(
        width: double.maxFinite,
        child: CTAButton(
          text: "Sign In",
          onTap: _signIn,
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

  Future<void> _signIn() async {
    FirebaseUser user = await Navigator.push(
      context,
      SlideUpPageRoute(
        child: SignInPage(),
      ),
    );

    if (user != null) {
      await _ensureDisplayNameIsSet(user);

      _goToHomePage();
    }
  }

  Future<void> _ensureDisplayNameIsSet(FirebaseUser user) async {
    if (user.displayName == null || user.displayName.isEmpty)
      await Navigator.push(
        context,
        SlideUpPageRoute(
          child: _SetDisplayNamePage(),
        ),
      );
  }

  _goToHomePage() {
    if (widget.initialPage)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    else
      Navigator.pop(context);
  }
}

class _SetDisplayNamePage extends StatefulWidget {
  @override
  __SetDisplayNamePageState createState() => __SetDisplayNamePageState();
}

class __SetDisplayNamePageState extends State<_SetDisplayNamePage> {
  TextEditingController _nameController = TextEditingController();

  GlobalKey<FormState> _namePageFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: _body(),
        ),
      );

  _body() => AnnotatedRegion<SystemUiOverlayStyle>(
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
          child: Consumer<AuthenticationProviderBLOC>(
            builder: (_, bloc, __) => Form(
              key: _namePageFormKey,
              autovalidate: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: sizeConfig.width(.02)),
                    child: Text(
                      "What's your name?",
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: sizeConfig.height(.06),
                    ),
                    child: TextFormField(
                      controller: _nameController,
                      autocorrect: false,
                      validator: (String input) =>
                          input == null || input.isEmpty
                              ? "You need to fill in this field."
                              : input.trim().split(" ").length <= 1
                                  ? "You need to enter your full name."
                                  : null,
                      decoration: InputDecoration(
                        labelText: "Enter your name",
                        prefixIcon: Icon(Icons.font_download),
                        prefixText: "I'm ",
                        hintText: "Musa Usman",
                      ),
                    ),
                  ),

                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.only(
                      top: sizeConfig.height(.06),
                    ),
                    child: CTAButton(
                      onTap: bloc.taskStatus.loading
                          ? null
                          : () => _setDisplayName(bloc),
                      text: "Done",
                    ),
                  ),

                  ///Error Message Panel
                  Container(
                    padding: EdgeInsets.only(
                      top: sizeConfig.height(.01),
                    ),
                    child: AnimatedOpacity(
                      duration: Constants.animationDuration,
                      opacity: bloc.taskStatus.error ? 1 : 0,
                      child: AbsorbPointer(
                        child: SecondaryButton(
                          onTap: () {},
                          text: bloc.taskStatus.errorMessage,
                          color: Theme.of(context).errorColor,
                          multiline: true,
                          icon: Icons.error,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> _setDisplayName(AuthenticationProviderBLOC bloc) async {
    try {
      bloc.taskStatus = AsyncTaskStatus.loading();
      if (_namePageFormKey.currentState.validate()) {
        UserUpdateInfo info = UserUpdateInfo()
          ..displayName = _nameController.text;
        bloc.user.updateProfile(info);
        await bloc.autoLogin();
        Navigator.pop(context);
      }
    } catch (e) {
      print("SetDisplayNamePage: SetDisplayName: UnexpectedErrorOccured: $e");
      bloc.taskStatus = AsyncTaskStatus.error();
    }
  }
}
