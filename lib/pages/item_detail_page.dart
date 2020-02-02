import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/blocs/cart_bloc.dart';
import 'package:mega_dot_pk/blocs/item_details_bloc.dart';
import 'package:mega_dot_pk/blocs/items_bloc.dart';
import 'package:mega_dot_pk/pages/account_page.dart';
import 'package:mega_dot_pk/pages/all_specs_page.dart';
import 'package:mega_dot_pk/pages/cart_page.dart';
import 'package:mega_dot_pk/blocs/authentication_provider_bloc.dart';
import 'package:mega_dot_pk/utils/constants.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/branded_error_page.dart';
import 'package:mega_dot_pk/widgets/branded_image.dart';
import 'package:mega_dot_pk/widgets/branded_loading_indicator.dart';
import 'package:mega_dot_pk/widgets/branded_table.dart';
import 'package:mega_dot_pk/widgets/cart_button.dart';
import 'package:mega_dot_pk/widgets/native_alert_dialog.dart';
import 'package:mega_dot_pk/widgets/native_icons.dart';
import 'package:mega_dot_pk/widgets/secondary_button.dart';
import 'package:mega_dot_pk/widgets/slide_up_page_route.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailPage extends StatefulWidget {
  final Item item;
  final ItemDetailsBLOC bloc;

  ItemDetailPage(this.item, this.bloc);

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar(),
        body: _body(widget.bloc),
        bottomNavigationBar: _bottomAppBar(),
        backgroundColor: Theme.of(context).canvasColor,
      );

  _appBar() => AppBar(
        elevation: 0.4,
        actions: <Widget>[
          CartButton(),
          Padding(
            padding: EdgeInsets.only(right: 6),
            child: IconButton(
              icon: Icon(
                widget.item.wished
                    ? NativeIcons.wishSolid()
                    : NativeIcons.wish(),
                color: widget.item.wished
                    ? Constants.wishIconColor
                    : Theme.of(context).primaryIconTheme.color,
              ),
              onPressed: () {
                AuthenticationProviderBLOC bloc =
                    Provider.of<AuthenticationProviderBLOC>(context);
                if (bloc.isAuthorized)
                  Navigator.push(
                    context,
                    SlideUpPageRoute(
                      child: AccountPage(),
                    ),
                  );
                else
                  Provider.of<ItemsBLOC>(context)
                      .toggleItemWished(widget.item);
              },
            ),
          ),
        ],
      );

  _bottomAppBar() => Container(
        height: sizeConfig.safeArea.bottom + sizeConfig.height(.1),
        padding: EdgeInsets.only(bottom: sizeConfig.safeArea.bottom),
        decoration: BoxDecoration(
          color: Theme.of(context).canvasColor,
          border: Border.all(
              color: Theme.of(context).unselectedWidgetColor.withOpacity(.1)),
          borderRadius: BorderRadius.circular(sizeConfig.height(.039)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sizeConfig.width(.05),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: sizeConfig.width(.02),
                  ),
                  child: _ShopButton(widget.item),
                ),
              ),
              SecondaryButton(
                icon: Icons.call,
                color: Colors.green,
                onTap: () async => await canLaunch(
                        Constants.landlinePhoneNumber)
                    ? await launch(Constants.landlinePhoneNumber)
                    : print(
                        'HomePage: LaunchURL: CannotLaunchURL: ${Constants.landlinePhoneNumber}'),
              ),
            ],
          ),
        ),
      );

  _body(ItemDetailsBLOC bloc) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ///Body Content
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(
                      top: sizeConfig.height(.035),
                    ),
                    child: _image(),
                  ),
                  Container(
                    child: _basicItemDetails(),
                  ),
                ],
              ),
            ),

            ///Details Sheet
            AnimatedCrossFade(
              firstChild: Padding(
                padding: EdgeInsets.all(
                  sizeConfig.height(.1),
                ),
                child: Center(
                    child: bloc.taskStatus.loading == true
                        ? BrandedLoadingIndicator()
                        : BrandedErrorPage(bloc.taskStatus, bloc.loadData)),
              ),
              secondChild: _DetailsSheet(widget.item, bloc.itemDetails),
              crossFadeState: bloc.taskStatus.loading || bloc.taskStatus.error
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 750),
            ),
          ],
        ),
      );

  _image() => Container(
        margin: EdgeInsets.symmetric(
          horizontal: sizeConfig.width(.125),
        ),
        child: BrandedImage(
          widget.item.thumbnailImageURL,
          height: sizeConfig.height(.225),
          fit: BoxFit.cover,
        ),
      );

  _basicItemDetails() => Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(
          top: sizeConfig.height(.035),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Divider(),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: sizeConfig.width(.05),
              ),
              margin: EdgeInsets.only(
                top: sizeConfig.height(.01),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "${widget.item.stock} · ${widget.item.views} views",
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                    textAlign: TextAlign.end,
                  ),
                  widget.item.warranty != "0" && widget.item.warranty != "3"
                      ? Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Text(
                            widget.item.warranty,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.caption,
                            textAlign: TextAlign.end,
                          ),
                        )
                      : Container(),
                  Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: Text(
                      widget.item.name,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.title.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 36,
                            height: 1.35,
                          ),
                    ),
                  ),
                  Text(
                    widget.item.brandName,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(height: 1.25),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _ShopButton extends StatefulWidget {
  final Item item;

  _ShopButton(this.item);

  @override
  __ShopButtonState createState() => __ShopButtonState();
}

class __ShopButtonState extends State<_ShopButton> {
  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(
          top: sizeConfig.height(.02),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(18),
          color: Theme.of(context).primaryColor,
          child: InkWell(
            onTap: _onTap,
            splashColor: Colors.white.withOpacity(.5),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              height: double.maxFinite,
              padding: EdgeInsets.symmetric(
                vertical: sizeConfig.height(.0185),
              ),
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.subtitle.copyWith(
                      color: Theme.of(context).canvasColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: sizeConfig.width(.06),
                        vertical: sizeConfig.height(.01),
                      ),
                      child: Text("${widget.item.price} PKR"),
                    ),
                    Spacer(),
                    Container(
                      margin: EdgeInsets.only(
                        right: sizeConfig.width(.06),
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: sizeConfig.height(.01),
                        horizontal: sizeConfig.width(.05),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFFFFA23F),
                      ),
                      child: Text("Buy Now"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Future<void> _onTap() async {
    bool confirmedByUser = await NativeAlertDialog.show(
      context,
      title: "Buy Now",
      content: "Are you sure you want to buy this product?",
      actions: [
        NativeAlertDialogAction(
          text: "Cancel",
          onTap: () {
            Navigator.pop(context, false);
          },
        ),
        NativeAlertDialogAction(
          text: "Yes",
          isDefault: true,
          onTap: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );

    if (confirmedByUser) {
      Provider.of<CartBLOC>(context, listen: false).addItem(widget.item);
      await Navigator.push(
        context,
        SlideUpPageRoute(
          child: CartPage(
            showAddedToCartBanner: true,
          ),
        ),
      );
    }
  }
}

class _DetailsSheet extends StatefulWidget {
  final Item item;
  final Map itemDetails;

  _DetailsSheet(this.item, this.itemDetails);

  @override
  __DetailsSheetState createState() => __DetailsSheetState();
}

class __DetailsSheetState extends State<_DetailsSheet> {
  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ///Divider
          Divider(),

          ///Specs Section
          widget.itemDetails.isNotEmpty ? _specsSection() : Container(),

          ///Divider
//          Divider(),
        ],
      );

  Widget _specsSection() {
    bool hasGeneralSpecs = widget.itemDetails.containsKey("General") &&
        widget.itemDetails["General"] is! List;

    bool hasDetailedSpecs = widget.itemDetails.length > 1;

    Widget _viewAllSpecsButton = defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoButton(
            padding: EdgeInsets.zero,
            child: Row(
              children: <Widget>[
                Text(hasGeneralSpecs ? "See All" : "View"),
                Padding(
                  padding: EdgeInsets.only(
                    left: sizeConfig.width(.01),
                  ),
                  child: Icon(Icons.navigate_next),
                ),
              ],
            ),
            onPressed: _seeAllSpecs,
          )
        : IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: _seeAllSpecs,
          );

    if (hasGeneralSpecs) {
      Map generalSpecs = widget.itemDetails["General"];

      Widget specsBar = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Specs",
            style: Theme.of(context).textTheme.title,
          ),
          hasDetailedSpecs ? _viewAllSpecsButton : Container(),
        ],
      );

      Widget specsTable = Container(
        margin: EdgeInsets.symmetric(
          vertical: sizeConfig.height(.0125),
        ),
        padding: EdgeInsets.only(
          bottom: sizeConfig.height(.015),
        ),
        child: BrandedTable(generalSpecs),
      );

      return Container(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sizeConfig.width(.05),
            vertical: sizeConfig.height(.01),
          ),
          child: Column(
            children: <Widget>[
              specsBar,
              specsTable,
            ],
          ),
        ),
      );
    } else
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: sizeConfig.height(.025),
          horizontal: sizeConfig.width(.05),
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment:
                    hasDetailedSpecs ? Alignment.centerLeft : Alignment.center,
                child: Text(
                  hasDetailedSpecs
                      ? "Detailed Specifications"
                      : "Specs Not Available",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    letterSpacing: -1,
                    fontWeight: FontWeight.w600,
                    fontSize: sizeConfig.text(20),
                    color: Theme.of(context).disabledColor,
                  ),
                ),
              ),
            ),
            hasDetailedSpecs ? _viewAllSpecsButton : Container(),
          ],
        ),
      );
  }

  void _seeAllSpecs() => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AllSpecsPage("Specs - ${widget.item.name}", widget.itemDetails),
        ),
      );
}
