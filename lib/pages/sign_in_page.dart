import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mega_dot_pk/blocs/authentication_provider_bloc.dart';
import 'package:mega_dot_pk/utils/constants.dart';
import 'package:mega_dot_pk/widgets/cta_button.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/widgets/branded_loading_indicator.dart';
import 'package:mega_dot_pk/widgets/form_navigation_icon_button.dart';
import 'package:mega_dot_pk/widgets/light_cta_button.dart';
import 'package:mega_dot_pk/widgets/native_icons.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _phoneNumberController = TextEditingController();

  TextEditingController _pinCodeController = TextEditingController();

  PageController _pageController = PageController();

  GlobalKey<FormState> _phonePageFormKey = GlobalKey();

  GlobalKey<FormState> _verificationPageFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _body(),
      );

  @override
  void dispose() {
    _phoneNumberController?.dispose();
    _pinCodeController?.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  _body() => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: PageView(
          controller: _pageController,
          children: <Widget>[
            _enterPhoneNumberPage(),
            _enterCodePage(),
          ],
        ),
      );

  _enterPhoneNumberPage() => Container(
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
            key: _phonePageFormKey,
            autovalidate: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    FormNavigationIconButton(
                      onTap: bloc.taskStatus.loading
                          ? null
                          : () => Navigator.pop(context),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: sizeConfig.width(.05),
                      ),
                      child: Text(
                        "Sign In",
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                    Spacer(),
                    bloc.taskStatus.loading
                        ? BrandedLoadingIndicator()
                        : Container(),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: sizeConfig.height(.06),
                  ),
                  child: TextFormField(
                    controller: _phoneNumberController,
                    validator: (String input) => input == null || input.isEmpty
                        ? "Please enter your phone number."
                        : null,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Enter Phone Number",
                      prefixIcon: Icon(Icons.call),
                      prefixText: "+92 ",
                      hintText: "3XX XXXXXX",
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
                        : () => _startVerificationProcess(bloc),
                    text: "Next",
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
                      child: LightCTAButton(
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
      );

  _enterCodePage() => Container(
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
            key: _verificationPageFormKey,
            autovalidate: true,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    FormNavigationIconButton(
                      onTap: bloc.taskStatus.loading
                          ? null
                          : () => _pageController.animateToPage(0,
                              duration: Constants.animationDuration,
                              curve: Curves.elasticInOut),
                      icon: NativeIcons.back(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: sizeConfig.width(.05),
                      ),
                      child: Text(
                        "Verification",
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                    Spacer(),
                    bloc.taskStatus.loading
                        ? BrandedLoadingIndicator()
                        : Container(),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: sizeConfig.height(.04),
                  ),
                  child: Text(
                    "We sent a 6 digit PIN code to your provided phone number. When you receive it, enter it here.",
                    style: Theme.of(context).textTheme.subtitle,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: sizeConfig.height(.035),
                  ),
                  child: TextFormField(
                    controller: _pinCodeController,
                    validator: (String input) => input == null || input.isEmpty
                        ? "Please enter PIN Code."
                        : null,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Enter PIN Code",
                      prefixIcon: Icon(Icons.fiber_pin),
                      hintText: "XXXXXX",
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
                        : () => _verifyCode(bloc),
                    text: "Verify",
                  ),
                ),

                Container(
                  width: double.maxFinite,
                  padding: EdgeInsets.only(
                    top: sizeConfig.height(.01),
                  ),
                  child: LightCTAButton(
                    onTap: bloc.taskStatus.loading ||
                            bloc.autoRetrievalTimedOut == false
                        ? null
                        : () => _startVerificationProcess(bloc),
                    text: "Resend Code",
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
                      child: LightCTAButton(
                        onTap: () {},
                        multiline: true,
                        text: bloc.taskStatus.errorMessage,
                        color: Theme.of(context).errorColor,
                        icon: Icons.error,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Future<void> _startVerificationProcess(
      AuthenticationProviderBLOC bloc) async {
    if (_phonePageFormKey.currentState.validate()) {
      String phoneNumber = "+92${_phoneNumberController.text}";
      await bloc.sendCodeToPhoneNumber(
          phoneNumber, _onCodeSent, _onAuthenticationSuccessful);
    }
  }

  void _verifyCode(AuthenticationProviderBLOC bloc) {
    if (_verificationPageFormKey.currentState.validate()) {
      String code = _pinCodeController.text;
      bloc.verifyCode(code, _onAuthenticationSuccessful);
    }
  }

  void _onCodeSent() {
    _pageController.animateToPage(1,
        duration: Constants.animationDuration, curve: Curves.elasticInOut);
  }

  void _onAuthenticationSuccessful(FirebaseUser firebaseUser) =>
      Navigator.pop(context, firebaseUser);
}
