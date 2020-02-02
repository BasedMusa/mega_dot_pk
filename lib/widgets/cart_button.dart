import 'package:flutter/material.dart';
import 'package:mega_dot_pk/blocs/cart_bloc.dart';
import 'package:mega_dot_pk/pages/cart_page.dart';
import 'package:mega_dot_pk/utils/constants.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/widgets/native_icons.dart';
import 'package:mega_dot_pk/widgets/slide_up_page_route.dart';
import 'package:provider/provider.dart';

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Align(
            child: IconButton(
              icon: Icon(NativeIcons.shoppingCart()),
              onPressed: () => Navigator.push(
                context,
                SlideUpPageRoute(
                  child: CartPage(
                    showAddedToCartBanner: false,
                  ),
                ),
              ),
            ),
          ),
          Consumer<CartBLOC>(builder: (_, bloc, __) {
            final bool _cartIsEmpty =
                bloc.items != null && bloc.items.isNotEmpty;
            return Positioned(
              right: sizeConfig.width(.025),
              top: sizeConfig.height(.02),
              child: AnimatedContainer(
                duration: Constants.animationDuration,
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                height: _cartIsEmpty ? 8 : 0,
                width: _cartIsEmpty ? 8 : 0,
              ),
            );
          }),
        ],
      );
}
