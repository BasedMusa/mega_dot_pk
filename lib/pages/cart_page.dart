import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mega_dot_pk/blocs/cart_bloc.dart';
import 'package:mega_dot_pk/utils/constants.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/form_navigation_icon_button.dart';
import 'package:mega_dot_pk/widgets/item_cart_list_item.dart';
import 'package:mega_dot_pk/widgets/native_icons.dart';
import 'package:mega_dot_pk/widgets/secondary_button.dart';
import 'package:provider/provider.dart';
import 'package:mega_dot_pk/utils/globals.dart';

class CartPage extends StatefulWidget {
  final bool showAddedToCartBanner;

  CartPage({this.showAddedToCartBanner = false});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _showBanner;
  bool _showAppBarBorder = false;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _handleBanner();

    _scrollController.addListener(() {
      if (_scrollController.offset > sizeConfig.height(.01))
        setState(() {
          _showAppBarBorder = true;
        });
      else
        setState(() {
          _showAppBarBorder = false;
        });
    });

    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _body(),
        bottomNavigationBar: _bottomAppBar(),
        backgroundColor: Theme.of(context).canvasColor,
      );

  _bottomAppBar() => Selector<CartBLOC, bool>(
        selector: (_, CartBLOC bloc) => bloc.hasItems,
        builder: (_, bool hasItems, __) => hasItems
            ? Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).canvasColor,
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 0.4,
                  ),
                ),
                padding: EdgeInsets.only(
                  top: sizeConfig.height(.025),
                  bottom: sizeConfig.safeArea.bottom + sizeConfig.height(.05),
                  left: sizeConfig.width(.06),
                  right: sizeConfig.width(.06),
                ),
                width: double.maxFinite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Total",
                          style: Theme.of(context).textTheme.caption.copyWith(
                                fontSize: sizeConfig.text(15),
                              ),
                        ),
                        Text(
                          _calculateTotalAmount(),
                          style: Theme.of(context).textTheme.title.copyWith(
                                color: Colors.green,
                              ),
                        ),
                      ],
                    ),
                    _PlaceOrderButton(),
                  ],
                ),
              )
            : Container(
                height: 0,
                width: 0,
              ),
      );

  _body() => Container(
        padding: EdgeInsets.only(
          right: sizeConfig.width(.06),
          left: sizeConfig.width(.06),
          top: sizeConfig.height(.035) + sizeConfig.safeArea.top,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Consumer<CartBLOC>(
          builder: (_, bloc, __) => Column(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              AnimatedContainer(
                duration: Constants.animationDuration,
                padding: EdgeInsets.only(bottom: sizeConfig.height(.015)),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: _showAppBarBorder
                          ? Theme.of(context).dividerColor
                          : Colors.white.withOpacity(0),
                    ),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    FormNavigationIconButton(
                      onTap: () => Navigator.pop(context),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: sizeConfig.width(.05),
                      ),
                      child: Text(
                        "Your Cart",
                        style: Theme.of(context).textTheme.title,
                      ),
                    ),
                    Spacer(),
                    bloc.hasItems &&
                            (bloc.items.length > 1 ||
                                bloc.items.values.first.length > 1)
                        ? _clearCartButton()
                        : Container(),
                  ],
                ),
              ),

              ///Banner
              _addedToCartBanner(),

              ///Cart Items
              _cartItems(),
            ],
          ),
        ),
      );

  _addedToCartBanner() => AnimatedOpacity(
        duration: Duration(milliseconds: 50),
        opacity: _showBanner ? 1 : 0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: _showBanner ? sizeConfig.height(.1) : 0,
          child: SecondaryButton(
            onTap: _closeBanner,
            text: "Added To Cart!",
          ),
        ),
      );

  _cartItems() => Expanded(
        child: Consumer<CartBLOC>(
          builder: (_, bloc, __) => AnimatedCrossFade(
            firstChild: Container(
              height: double.maxFinite,
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.only(bottom: sizeConfig.height(.035)),
                itemCount: bloc.items.keys.length,
                itemBuilder: (context, int index) => ItemCartListItem(
                    bloc.items.values.toList()[index].first,
                    bloc.items.values.toList()[index].length),
              ),
            ),
            secondChild: Center(
              child: Text(
                "Empty",
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: -2,
                  fontWeight: FontWeight.w600,
                  fontSize: sizeConfig.text(30),
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ),
            crossFadeState: bloc.hasItems
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: Constants.animationDuration,
          ),
        ),
      );

  _clearCartButton() {
    bool _isIOS = defaultTargetPlatform == TargetPlatform.iOS;
    Widget _content = Container(
      child: Row(
        children: <Widget>[
          Icon(
            NativeIcons.remove(),
            color: _isIOS
                ? Theme.of(context).errorColor
                : Theme.of(context).canvasColor,
          ),
          Text(
            "Clear All",
            style: Theme.of(context).textTheme.button.copyWith(
                  color: _isIOS ? Theme.of(context).errorColor : null,
                ),
          ),
        ],
      ),
    );

    return _isIOS
        ? CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: _clearCart,
            child: _content,
          )
        : Material(
            color: Theme.of(context).errorColor,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              onTap: _clearCart,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: sizeConfig.width(.03),
                  vertical: sizeConfig.height(.01),
                ),
                child: _content,
              ),
            ),
          );
  }

  String _calculateTotalAmount() {
    final currencyFormat = new NumberFormat("#,##0.00", "en_US");

    Map<String, List<Item>> cartItems = Provider.of<CartBLOC>(context).items;

    int totalAmount = 0;

    cartItems.forEach((String key, List<Item> value) {
      value.forEach((Item item) {
        int price = int.parse(item.price.replaceAll(",", ""));
        totalAmount += price;
      });
    });

    return "${currencyFormat.format(totalAmount)} PKR";
  }

  _handleBanner() {
    _showBanner = widget.showAddedToCartBanner;
    if (_showBanner)
      Future.delayed(
        Duration(milliseconds: 300),
        () {
          if (this.mounted) _openBanner();
        },
      );
    Future.delayed(
      Duration(seconds: 2),
      () {
        if (this.mounted) _closeBanner();
      },
    );
  }

  _openBanner() => setState(() => _showBanner = true);

  _closeBanner() => setState(() => _showBanner = false);

  _clearCart() => Provider.of<CartBLOC>(context, listen: false).clear(context);
}

class _PlaceOrderButton extends StatefulWidget {
  _PlaceOrderButton();

  @override
  _PlaceOrderButtonState createState() => _PlaceOrderButtonState();
}

class _PlaceOrderButtonState extends State<_PlaceOrderButton> {
  @override
  Widget build(BuildContext context) => Material(
        borderRadius: BorderRadius.circular(18),
        color: Theme.of(context).primaryColor,
        child: InkWell(
          onTap: _onTap,
          splashColor: Colors.white.withOpacity(.5),
          borderRadius: BorderRadius.circular(18),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: sizeConfig.height(.0185),
            ),
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.subtitle.copyWith(
                    color: Theme.of(context).canvasColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
              child: Container(
                margin: EdgeInsets.symmetric(
                  horizontal: sizeConfig.width(.06),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: sizeConfig.height(.01),
                  horizontal: sizeConfig.width(.05),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFFFFA23F),
                ),
                child: Text("Place Order"),
              ),
            ),
          ),
        ),
      );

  Future<void> _onTap() async {}
}
