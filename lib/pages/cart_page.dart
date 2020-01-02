import 'package:flutter/material.dart';

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
    Future.delayed(Duration(seconds: 2), () {
      _closeBanner();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: _body(),
      );

  _body() => Container(
        child: ListView(
          children: <Widget>[
            ///Back Button
            Align(
              alignment: Alignment.centerLeft,
              child: BackButton(),
            ),

            ///Banner
            _addedToCartBanner(),


          ],
        ),
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

  _closeBanner() => setState(() => _showBanner = false);
}
