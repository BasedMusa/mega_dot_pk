import 'package:mega_dot_pk/widgets/branded_loading_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mega_dot_pk/pages/account_page.dart';
import 'package:mega_dot_pk/widgets/branded_error_page.dart';
import 'package:mega_dot_pk/widgets/category_list_item.dart';
import 'package:mega_dot_pk/widgets/light_cta_button.dart';
import 'package:mega_dot_pk/blocs/categories_bloc.dart';
import 'package:mega_dot_pk/utils/constants.dart';
import 'package:mega_dot_pk/widgets/slide_up_page_route.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController _pageViewController =
      PageController(initialPage: 2, keepPage: true);

  int _pageIndex = 2;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar(),
        bottomNavigationBar: _bottomNavigationBar(),
        body: _body(),
        backgroundColor: Colors.white,
      );

  _appBar() => AppBar(
        elevation: 0.6,
        centerTitle: false,
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
            _searchPage(),
            _homePage(),
            _browsePage(),
            _favouritesPage(),
            _profilePage(),
          ],
        ),
      );

  _searchPage() => Container(
        child: Center(
          child: Text(
            "Search",
            style: Theme.of(context).textTheme.display1,
          ),
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
              LightCTAButton(
                text: "Shop Now",
                icon: Icons.arrow_forward_ios,
                onTap: () => _onPageChanged(2),
              ),
              auth.isAuthorized == false
                  ? LightCTAButton(
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
                    child: LightCTAButton(
                      text: "Call",
                      icon: Icons.call,
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
                    child: LightCTAButton(
                      text: "Our Social",
                      icon: FontAwesomeIcons.facebookF,
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
                        headerSliverBuilder: (context, _) => [
                          SliverAppBar(
                            elevation: 0,
                            stretch: false,
                            centerTitle: true,
                            expandedHeight: sizeConfig.height(.15),
                            flexibleSpace: Container(
                              child: Center(
                                child: Text(
                                  "Browse",
                                  style: Theme.of(context).textTheme.display1,
                                ),
                              ),
                            ),
                          ),
                        ],
                        body: ListView.builder(
                          padding: EdgeInsets.symmetric(
                            vertical: sizeConfig.height(.03),
                          ),
                          physics: BouncingScrollPhysics(),
                          itemCount: bloc.categories.length,
                          itemBuilder: (context, i) => CategoryListItem(
                            bloc.categories[i],
                          ),
                        ),
                      ),
          ),
        ),
      );

  _favouritesPage() => Container(
        child: Center(
          child: Text(
            "Favourites",
            style: Theme.of(context).textTheme.display1,
          ),
        ),
      );

  _profilePage() => Container(
        margin: EdgeInsets.symmetric(
          horizontal: sizeConfig.width(.1),
        ),
        child: Center(
          child: Text(
            "Login",
            style: Theme.of(context).textTheme.display1,
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
      Color selectedIconColor = Theme.of(context).primaryColor;
      Color unselectedIconColor = Colors.black;

      List<IconData> icons = [
        Icons.search,
        Icons.home,
        Icons.shopping_basket,
        widget.selectedIndex == 3 ? Icons.favorite : Icons.favorite_border,
        widget.selectedIndex == 4 ? Icons.person : Icons.person_outline
      ];

      double blockWidth = sizeConfig.width(1) / icons.length;
      double selectedBlockEndPosition = blockWidth * (widget.selectedIndex + 1);

      double indicatorLeftMargin =
          selectedBlockEndPosition - (blockWidth / 2) - 2;

      return Container(
        padding: EdgeInsets.only(
          top: sizeConfig.height(.015),
          bottom: sizeConfig.height(.015) + sizeConfig.safeArea.bottom,
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).dividerColor),
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
                  icons.length,
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
                          icons[i],
                          color: widget.selectedIndex == i
                              ? selectedIconColor
                              : unselectedIconColor,
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
              height: 4,
              width: 4,
            )
          ],
        ),
      );
    }
  }
}
