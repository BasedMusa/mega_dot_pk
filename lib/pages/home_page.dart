import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:mega_dot_pk/blocs/authentication_provider_bloc.dart';
import 'package:mega_dot_pk/widgets/cart_button.dart';
import 'package:mega_dot_pk/widgets/cta_button.dart';
import 'package:mega_dot_pk/widgets/branded_loading_indicator.dart';
import 'package:mega_dot_pk/pages/account_page.dart';
import 'package:mega_dot_pk/widgets/branded_error_page.dart';
import 'package:mega_dot_pk/widgets/category_list_item.dart';
import 'package:mega_dot_pk/blocs/categories_bloc.dart';
import 'package:mega_dot_pk/utils/constants.dart';
import 'package:mega_dot_pk/widgets/native_alert_dialog.dart';
import 'package:mega_dot_pk/widgets/native_icons.dart';
import 'package:mega_dot_pk/widgets/secondary_button.dart';
import 'package:mega_dot_pk/widgets/slide_up_page_route.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../utils/globals.dart';
import '../widgets/branded_loading_indicator.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageViewController =
      PageController(initialPage: 1, keepPage: true);

  int _pageIndex = 1;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _body(),
        bottomNavigationBar: _bottomNavigationBar(),
        backgroundColor: Theme.of(context).canvasColor,
      );

  _bottomNavigationBar() => _BottomNavigationBar(
        selectedIndex: _pageIndex,
        onPageChanged: _onPageChanged,
      );

  _body() => Container(
        child: PageView(
          controller: _pageViewController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            _homePage(),
            _browsePage(),
            _profilePage(),
          ],
        ),
      );

  _homePage() => Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: sizeConfig.height(.01),
            horizontal: sizeConfig.width(.05),
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                  top: sizeConfig.height(.0015) + sizeConfig.safeArea.top,
                ),
                child: Text(
                  "Home",
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              SecondaryButton(
                text: "Shop Now",
                icon: Icons.arrow_forward_ios,
                onTap: () => _onPageChanged(1),
              ),
              Provider.of<AuthenticationProviderBLOC>(context).isAuthorized ==
                      false
                  ? SecondaryButton(
                      text: "Get More Features By Signing Up!",
                      icon: Icons.person_add,
                      onTap: () => Navigator.push(
                        context,
                        SlideUpPageRoute(
                          child: AccountPage(),
                        ),
                      ),
                      color: Colors.grey[700],
                    )
                  : Container(),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SecondaryButton(
                      text: "Call",
                      icon: NativeIcons.callSolid(),
                      onTap: () => _launchURL(Constants.landlinePhoneNumber),
                      color: Colors.green,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: sizeConfig.width(.01),
                    ),
                  ),
                  Expanded(
                    child: SecondaryButton(
                      text: "Our Facebook",
                      icon: Icons.whatshot,
                      onTap: () =>
                          _launchURL("https://www.facebook.com/mega.pk"),
                      color: Colors.blue[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  _browsePage() => Container(
        child: Consumer<CategoriesBLOC>(
          builder: (context, bloc, __) => Container(
            child: bloc.taskStatus.loading
                ? BrandedLoadingIndicator()
                : bloc.taskStatus.error
                    ? BrandedErrorPage(bloc.taskStatus, bloc.loadData)
                    : NestedScrollView(
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) => [
                          SliverAppBar(
                            elevation: 0.4,
                            stretch: false,
                            centerTitle: true,
                            primary: true,
                            pinned: true,
                            expandedHeight: sizeConfig.height(.3),
                            actions: <Widget>[
                              CartButton(),
                              IconButton(
                                icon: Icon(NativeIcons.search()),
                                onPressed: () => _onPageChanged(0),
                              )
                            ],
                            flexibleSpace: Container(
                              padding: EdgeInsets.only(
                                top: sizeConfig.height(.035),
                              ),
                              child: Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: Duration(milliseconds: 100),
                                  curve: Curves.easeInQuint,
                                  style: innerBoxIsScrolled
                                      ? Theme.of(context).textTheme.title
                                      : Theme.of(context).textTheme.display1,
                                  child: Text("Browse"),
                                ),
                              ),
                            ),
                          ),
                        ],
                        body: ListView.builder(
                          padding: EdgeInsets.only(
                            top: defaultTargetPlatform == TargetPlatform.iOS
                                ? sizeConfig.height(.03)
                                : 0,
                            bottom: sizeConfig.height(.03),
                          ),
                          physics: BouncingScrollPhysics(),
                          itemCount: bloc.categories.length,
                          itemBuilder: (context, i) => CategoryListItem(
                            bloc.categories[i],
                            searchButtonCallback: () => _onPageChanged(0),
                          ),
                        ),
                      ),
          ),
        ),
      );

  _profilePage() => Consumer<AuthenticationProviderBLOC>(
        builder: (_, bloc, __) => Container(
          margin: EdgeInsets.symmetric(
            horizontal: sizeConfig.width(.1),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  bloc.isAuthorized
                      ? bloc.user.displayName ?? "No Name User"
                      : "Login",
                  style: Theme.of(context).textTheme.display1,
                ),
                bloc.isAuthorized
                    ? CTAButton(
                        text: "Sign Out",
                        onTap: () async {
                          bool confirmedByUser = await NativeAlertDialog.show(
                            context,
                            title: "Are you sure?",
                            content:
                                "You will have log back in to your account, to view your profile and order items.",
                            actions: [
                              NativeAlertDialogAction(
                                text: "Cancel",
                                onTap: () {
                                  Navigator.pop(context, false);
                                },
                              ),
                              NativeAlertDialogAction(
                                text: "Sign Out",
                                isDestructive: true,
                                onTap: () {
                                  Navigator.pop(context, true);
                                },
                              ),
                            ],
                          );
                          if (confirmedByUser) bloc.signOut();
                        },
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      );

  _onPageChanged(int index) => setState(
        () {
          _pageIndex = index;
          _pageViewController.animateToPage(index,
              duration: Constants.animationDuration, curve: Curves.easeInOut);
        },
      );

  Future<void> _launchURL(String url) async => await canLaunch(url)
      ? await launch(url)
      : print('HomePage: LaunchURL: CannotLaunchURL: $url');
}

class _BottomNavigationBar extends StatefulWidget {
  final Function(int) onPageChanged;
  final int selectedIndex;

  _BottomNavigationBar(
      {@required this.onPageChanged, @required this.selectedIndex});

  @override
  __BottomNavigationBarState createState() => __BottomNavigationBarState();
}

class __BottomNavigationBarState extends State<_BottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    {
      bool _isIOS = defaultTargetPlatform == TargetPlatform.iOS;

      Color _selectedIconColor = Theme.of(context).primaryColor;
      Color _unselectedIconColor = _isIOS
          ? Theme.of(context).unselectedWidgetColor
          : Theme.of(context).textTheme.title.color;

      double _indicatorSize = _isIOS ? 2.5 : 4;

      List<IconData> _icons = [
        NativeIcons.home(),
        widget.selectedIndex == 1
            ? NativeIcons.browseSolid()
            : NativeIcons.browse(),
        widget.selectedIndex == 2
            ? NativeIcons.personSolid()
            : NativeIcons.person(),
      ];

      List<String> _titles = ["Home", "Browse", "Profile"];

      double blockWidth = sizeConfig.width(1) / _icons.length;
      double selectedBlockEndPosition = blockWidth * (widget.selectedIndex + 1);

      double indicatorLeftMargin =
          selectedBlockEndPosition - (blockWidth / 2) - 2;
      if (_isIOS)
        return CupertinoTabBar(
            onTap: (int i) => widget.onPageChanged(i),
            items: List.generate(
              _icons.length,
              (i) => BottomNavigationBarItem(
                icon: Icon(
                  _icons[i],
                  color: widget.selectedIndex == i
                      ? _selectedIconColor
                      : _unselectedIconColor,
                ),
                title: Text(
                  _titles[i],
                  style: TextStyle(
                    color: widget.selectedIndex == i
                        ? _selectedIconColor
                        : _unselectedIconColor,
                  ),
                ),
              ),
            ));
      else
        return AnimatedContainer(
          duration: Constants.animationDuration,
          padding: EdgeInsets.only(
            top: sizeConfig.height(.015),
            bottom: sizeConfig.height(.015) + sizeConfig.safeArea.bottom,
          ),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).dividerColor,
            ),
            borderRadius: BorderRadius.circular(sizeConfig.height(.039)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(
                    _icons.length,
                    (i) => Flexible(
                      child: AnimatedContainer(
                        duration: Constants.animationDuration,
                        width: blockWidth,
                        padding: widget.selectedIndex == i
                            ? EdgeInsets.only(
                                bottom: sizeConfig.height(.005),
                              )
                            : EdgeInsets.only(
                                top: sizeConfig.height(.005),
                              ),
                        child: IconButton(
                          icon: Icon(
                            _icons[i],
                            color: widget.selectedIndex == i
                                ? _selectedIconColor
                                : _unselectedIconColor,
                          ),
                          onPressed: () => widget.onPageChanged(i),
                        ),
                      ),
                    ),
                  )),
              AnimatedContainer(
                duration: Duration(milliseconds: 200),
                margin: EdgeInsets.only(
                  left: indicatorLeftMargin,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                height: _indicatorSize,
                width: _indicatorSize,
              ),
            ],
          ),
        );
    }
  }
}
