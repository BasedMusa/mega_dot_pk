import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/blocs/cart_bloc.dart';
import 'package:mega_dot_pk/blocs/item_details_bloc.dart';
import 'package:mega_dot_pk/pages/all_specs_page.dart';
import 'package:mega_dot_pk/pages/cart_page.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/mixins.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/branded_error_page.dart';
import 'package:mega_dot_pk/widgets/branded_image.dart';
import 'package:mega_dot_pk/widgets/branded_loading_indicator.dart';
import 'package:mega_dot_pk/widgets/branded_table.dart';
import 'package:mega_dot_pk/widgets/cta_button.dart';
import 'package:mega_dot_pk/widgets/native_alert_dialog.dart';
import 'package:mega_dot_pk/widgets/slide_up_page_route.dart';
import 'package:mega_dot_pk/widgets/styled_appbar.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  ProductDetailPage(this.product);

  TextStyle _captionTextStyle(context) =>
      Theme.of(context).textTheme.caption.copyWith(fontSize: 14);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => ProductDetailsBLOC(product),
        child: Scaffold(
          appBar: _appBar(),
          body: _body(context),
        ),
      );

  _appBar() => StyledAppBar("${product.brandName} ${product.name}");

  _body(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ///Image
            Container(
              child: _image(context),
            ),

            ///Basic Product Details
            Container(
              child: _basicItemDetails(context),
            ),

            ///Purchase Section
            Container(
              child: _purchaseSection(context),
            ),

            ///Details Sheet
            Consumer<ProductDetailsBLOC>(
              builder: (_, bloc, __) => bloc.taskStatus.loading
                  ? Padding(
                      padding: EdgeInsets.all(
                        sizeConfig.height(.1),
                      ),
                      child: Center(
                        child: BrandedLoadingIndicator(),
                      ),
                    )
                  : bloc.taskStatus.error
                      ? Padding(
                          padding: EdgeInsets.all(
                            sizeConfig.height(.1),
                          ),
                          child: Center(
                            child: BrandedErrorPage(
                                bloc.taskStatus, bloc.loadData),
                          ),
                        )
                      : _DetailsSheet(product, bloc.productDetails),
            ),
          ],
        ),
      );

  _image(BuildContext context) => Container(
        color: Theme.of(context).cardColor,
        width: double.maxFinite,
        margin: EdgeInsets.only(
          top: sizeConfig.height(.05),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: sizeConfig.width(.125),
          vertical: sizeConfig.height(.035),
        ),
        child: BrandedImage(
          product.thumbnailImageURL,
          height: sizeConfig.height(.235),
          fit: BoxFit.cover,
        ),
      );

  _purchaseSection(BuildContext context) => Container(
        color: Theme.of(context).cardColor,
        width: double.maxFinite,
        margin: EdgeInsets.only(
          top: 1,
        ),
        padding: EdgeInsets.symmetric(
          vertical: sizeConfig.height(.02),
          horizontal: sizeConfig.width(.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Product Price",
                  style: Theme.of(context)
                      .primaryTextTheme
                      .caption
                      .copyWith(fontSize: 15),
                ),
                Text(
                  product.priceText,
                  style: Theme.of(context).primaryTextTheme.subtitle2.copyWith(
                        fontSize: 22,
                        color: Colors.green,
                      ),
                ),
              ],
            ),
            CTAButton(
              text: "Buy Now",
              onTap: () => _buyNowOnPress(context),
            ),
          ],
        ),
      );

  _basicItemDetails(BuildContext context) => Container(
        color: Theme.of(context).cardColor,
        width: double.maxFinite,
        margin: EdgeInsets.only(
          top: sizeConfig.height(.02),
        ),
        padding: EdgeInsets.only(
          top: sizeConfig.height(.02),
          bottom: sizeConfig.height(.02),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                  Padding(
                    padding: EdgeInsets.only(top: 2.0),
                    child: Text(
                      product.name,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style:
                          Theme.of(context).primaryTextTheme.headline6.copyWith(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .bodyText1
                                    .color,
                                fontWeight: FontWeight.w800,
                                fontSize: 36,
                                height: 1,
                              ),
                    ),
                  ),
                  Text(
                    product.brandName,
                    overflow: TextOverflow.ellipsis,
                    style:
                        Theme.of(context).primaryTextTheme.headline6.copyWith(
                              height: 1.25,
                              color: Theme.of(context)
                                  .primaryTextTheme
                                  .bodyText1
                                  .color,
                            ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 7.5),
                    child: Text(
                      "${product.stock} · ${product.views}",
                      overflow: TextOverflow.ellipsis,
                      style: _captionTextStyle(context),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  product.warranty != "0" && product.warranty != "3"
                      ? Padding(
                          padding: EdgeInsets.only(top: 2.5),
                          child: Text(
                            product.warranty,
                            overflow: TextOverflow.ellipsis,
                            style: _captionTextStyle(context),
                            textAlign: TextAlign.end,
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          ],
        ),
      );

  Future<void> _buyNowOnPress(BuildContext context) async {
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
      Provider.of<CartBLOC>(context, listen: false).addItem(product);
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

class _DetailsSheet extends StatefulWidget with PlatformBoolMixin {
  final Product item;
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
        ],
      );

  Widget _specsSection() {
    bool hasGeneralSpecs = widget.itemDetails.containsKey("General") &&
        widget.itemDetails["General"] is! List;

    bool hasDetailedSpecs = widget.itemDetails.length > 1;

    Widget _viewAllSpecsButton = widget.isIOS
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
            style: Theme.of(context).textTheme.headline6,
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
        color: Theme.of(context).cardColor,
        child: Padding(
          padding: EdgeInsets.only(
            right: sizeConfig.width(.05),
            left: sizeConfig.width(.05),
            top: sizeConfig.height(.01),
            bottom: sizeConfig.height(.01) + sizeConfig.safeArea.bottom,
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
