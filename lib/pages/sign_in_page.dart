import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/widgets/light_cta_button.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _obscureText = true;

  TextEditingController _emailController;
  TextEditingController _passwordController;

  GlobalKey _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _body(),
      );

  _body() => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: InkWell(
          onTap: () {
            print("hhh");
          },
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
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      _navigationIconButton(
                        onTap: () => Navigator.pop(context),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          left: sizeConfig.width(.05),
                        ),
                        child: Text(
                          "Login",
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
                      controller: _emailController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.alternate_email),
                        hintText: "Email",
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: sizeConfig.height(.025),
                    ),
                    child: TextFormField(
                      obscureText: _obscureText,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          splashColor: Colors.grey.withOpacity(0),
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: _obscureText
                                ? Theme.of(context).unselectedWidgetColor
                                : Theme.of(context).primaryColor,
                          ),
                          onPressed: () =>
                              setState(() => _obscureText = !_obscureText),
                        ),
                        hintText: "Password",
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(
                      top: sizeConfig.height(.03),
                    ),
                    child: LightCTAButton(
                      onTap: () => Navigator.pop(context),
                      text: "Next",
                      icon: Icons.arrow_forward_ios,
                    ),
                  ),
                ],
              ),
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
