import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mega_dot_pk/blocs/cart_bloc.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/item_cart_list_item.dart';
import 'package:provider/provider.dart';

import '../utils/globals.dart';
import '../widgets/light_cta_button.dart';

class CartPage extends StatefulWidget {
  final bool showAddedToCartBanner;

  CartPage({this.showAddedToCartBanner = false});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _showBanner;

  @override
  void initState() {
    _showBanner = widget.showAddedToCartBanner;
    Future.delayed(
      Duration(milliseconds: 300),
      _openBanner,
    );
    Future.delayed(
      Duration(seconds: 2),
      _closeBanner,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar(),
        body: _body(),
        bottomNavigationBar: _bottomAppBar(),
      );

  _appBar() => AppBar(
        elevation: .4,
        title: Text("Your Cart"),
      );

  _bottomAppBar() => Container(
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
          left: sizeConfig.width(.05),
          right: sizeConfig.width(.05),
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
      );

  _body() => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ///Banner
          _addedToCartBanner(),

          ///Cart Items
          _cartItems(),
        ],
      );

  _addedToCartBanner() => AnimatedOpacity(
        duration: Duration(milliseconds: 50),
        opacity: _showBanner ? 1 : 0,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          height: _showBanner ? sizeConfig.height(.1) : 0,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sizeConfig.width(.075),
            ),
            child: LightCTAButton(
              onTap: _closeBanner,
              text: "Added To Cart!",
            ),
          ),
        ),
      );

  _cartItems() => Consumer<CartBLOC>(
        builder: (_, bloc, __) => Expanded(
          child: ListView.builder(
            physics: _showBanner ? NeverScrollableScrollPhysics() : null,
            padding: EdgeInsets.only(bottom: sizeConfig.height(.035)),
            itemCount: bloc.items.keys.length,
            itemBuilder: (context, int index) =>
                ItemCartListItem(bloc.items.values.toList()[index].first, bloc.items.values.toList()[index].length),
          ),
        ),
      );

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

  _openBanner() => setState(() => _showBanner = true);

  _closeBanner() => setState(() => _showBanner = false);
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
