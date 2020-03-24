import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:mega_dot_pk/blocs/authentication_provider_bloc.dart';
import 'package:mega_dot_pk/pages/account_page.dart';
import 'package:mega_dot_pk/pages/categories_page.dart';
import 'package:mega_dot_pk/pages/search_page.dart';
import 'package:mega_dot_pk/utils/constants.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/mixins.dart';
import 'package:mega_dot_pk/widgets/native_context_menu.dart';
import 'package:mega_dot_pk/widgets/styled_appbar.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar(),
        body: _body(),
      );

  _appBar() => StyledAppBar(
        "Welcome",
        centerTitle: false,
      );

  _body() => Container(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              _SearchBar(),
              _MainButtons(),
            ],
          ),
        ),
      );
}

class _SearchBar extends StatefulWidget with PlatformBoolMixin {
  @override
  __SearchBarState createState() => __SearchBarState();
}

class __SearchBarState extends State<_SearchBar> {
  final TextEditingController _searchTextController = TextEditingController();
  bool _hasContent = false;
  bool _isActive = false;

  @override
  void initState() {
    _searchTextController.addListener(() {
      setState(() {
        _isActive = true;

        if (_searchTextController.text.isNotEmpty)
          _hasContent = true;
        else
          _hasContent = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(
          horizontal: sizeConfig.width(.02),
        ),
        margin: EdgeInsets.only(
          top: sizeConfig.height(.05),
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor,
              width: .5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 15,
              color: Theme.of(context).dividerColor,
            ),
          ],
        ),
        child: TextField(
          controller: _searchTextController,
          textInputAction: TextInputAction.search,
          onSubmitted: (String input) => _search(context),
          decoration: InputDecoration(
            prefixIcon:
                Icon(widget.isIOS ? CupertinoIcons.search : Icons.search),
            suffixIcon: AnimatedOpacity(
              opacity: _isActive ? 1 : 0,
              duration: Duration(milliseconds: 50),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      widget.isIOS ? CupertinoIcons.clear_circled : Icons.clear,
                    ),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      _searchTextController.clear();
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        _isActive = false;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(widget.isIOS
                        ? CupertinoIcons.forward
                        : Icons.arrow_forward),
                    color: _hasContent
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).disabledColor,
                    onPressed: _hasContent ? () => _search(context) : null,
                  ),
                ],
              ),
            ),
            hintText: "Search Products",
            contentPadding: EdgeInsets.symmetric(
              vertical: sizeConfig.height(.0275),
              horizontal: sizeConfig.width(.05),
            ),
          ),
        ),
      );

  void _search(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchPage(_searchTextController.text),
      ),
    );
  }
}

class _MainButtons extends StatefulWidget with PlatformBoolMixin {
  @override
  State<StatefulWidget> createState() => _MainButtonsState();
}

class _MainButtonsState extends State<_MainButtons> {
  @override
  Widget build(BuildContext context) {
    AuthenticationProviderBLOC auth =
        Provider.of<AuthenticationProviderBLOC>(context);

    List<Widget> otherReportsListItems = [
      _listItem(
        Icons.view_headline,
        "Categories",
        _seeCategory,
        color: Theme.of(context).primaryColor,
      ),
      _listItem(
        LineAwesomeIcons.phone,
        "Call",
        _call,
        color: Colors.green,
      ),
      _listItem(
        LineAwesomeIcons.whatsapp,
        "WhatsApp",
        _whatsApp,
        color: Colors.green,
      ),
      _listItem(
        LineAwesomeIcons.facebook_official,
        "Facebook",
        _facebook,
        color: Colors.blue,
      ),
      auth.isAuthorized
          ? Container()
          : Padding(
              padding: EdgeInsets.only(
                top: sizeConfig.height(.02),
              ),
              child: _listItem(
                Icons.person_add,
                "Sign Up",
                _signUp,
                color: Theme.of(context).primaryColor,
              ),
            ),
    ];

    return Container(
      margin: EdgeInsets.only(
        top: sizeConfig.height(.05),
      ),
      child: Column(
        children: otherReportsListItems,
      ),
    );
  }

  _listItem(IconData iconData, String text, GestureTapCallback onTap,
      {Color color}) {
    Widget _content = Container(
      padding: EdgeInsets.symmetric(
        vertical: sizeConfig.height(.03),
        horizontal: sizeConfig.width(.05),
      ),
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: .75,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              right: sizeConfig.width(.035),
            ),
            child: Icon(
              iconData,
              color: color ?? Theme.of(context).iconTheme.color,
            ),
          ),
          Text(
            text,
            style: Theme.of(context).primaryTextTheme.subtitle1,
          ),
          Spacer(),
          Transform.rotate(
            angle: pi,
            child: Icon(
              Icons.keyboard_backspace,
              color: Theme.of(context).iconTheme.color,
            ),
          )
        ],
      ),
    );

    return widget.isIOS
        ? CupertinoButton(
            padding: EdgeInsets.zero,
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.zero,
            child: _content,
            onPressed: onTap,
          )
        : Material(
            color: Theme.of(context).cardColor,
            child: InkWell(
              child: _content,
              onTap: onTap,
            ),
          );
  }

  void _seeCategory() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CategoriesPage(),
        ),
      );

  void _whatsApp() => _launchURL(
      "https://api.whatsapp.com/send?phone=${Constants.mobilePhoneNumber}&text=Asalam-u-alaikum!");

  Future<void> _call() async {
    await StyledContextMenu.show(
      context,
      actions: Constants.allPhoneNumbers
          .map(
            (String phoneNumber) => StyledContextMenuAction(
              iconData: LineAwesomeIcons.phone,
              text: phoneNumber,
              onTap: () {
                _launchURL("tel:$phoneNumber");
                return phoneNumber;
              },
            ),
          )
          .toList(),
    );
  }

  void _facebook() => _launchURL("https://www.facebook.com/mega.pk");

  void _signUp() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AccountPage(),
      ),
    );
  }

  Future<void> _launchURL(String url) async => await canLaunch(url)
      ? await launch(url)
      : print('HomePage: LaunchURL: CannotLaunchURL: $url');
}
