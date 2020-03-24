import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/blocs/authentication_provider_bloc.dart';
import 'package:mega_dot_pk/blocs/product_blocs.dart';
import 'package:mega_dot_pk/pages/product_detail_page.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/mixins.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/branded_image.dart';
import 'package:provider/provider.dart';

class ProductGridItem extends StatelessWidget with PlatformBoolMixin {
  final int itemIndex;
  final Product product;

  ProductGridItem(this.itemIndex, this.product);

  bool get wished => product.wished;

  @override
  Widget build(BuildContext context) {
    Widget _bottomLayer = Container(
      height: double.maxFinite,
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(
        horizontal: sizeConfig.width(.05),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(
              top: sizeConfig.height(.04),
            ),
            alignment: Alignment.center,
            child: BrandedImage(
              product.xsThumbnailImageURL,
              height: sizeConfig.height(.165),
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: sizeConfig.height(.02),
            ),
            child: Text(
              product.priceText,
              style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                    color: Colors.green,
                    fontSize: 18,
                  ),
            ),
          ),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).primaryTextTheme.subtitle1.copyWith(
                  fontSize: 20,
                  height: 1.2,
                ),
          ),
          Text(
            product.brandName,
            style: Theme.of(context).primaryTextTheme.subtitle2,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            product.stock,
            style: Theme.of(context)
                .primaryTextTheme
                .caption
                .copyWith(height: 1.5),
          ),
        ],
      ),
    );

    Icon _wishIcon = Icon(
      wished
          ? isIOS ? CupertinoIcons.heart_solid : Icons.favorite
          : isIOS ? CupertinoIcons.heart : Icons.favorite_border,
      color: Theme.of(context).primaryIconTheme.color,
    );

    Widget _topLayer = Container(
      alignment: Alignment.topRight,
      child: isIOS
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              child: _wishIcon,
              onPressed: () => _toggleWished(context),
            )
          : IconButton(
              icon: _wishIcon,
              onPressed: () => _toggleWished(context),
            ),
    );

    bool isAuthorized =
        Provider.of<AuthenticationProviderBLOC>(context).isAuthorized;

    Widget _content = Stack(
      children: <Widget>[
        _bottomLayer,
        isAuthorized ? _topLayer : Container(),
      ],
    );

    return isIOS
        ? CupertinoButton(
            child: _content,
            onPressed: () => _onTap(context),
            padding: EdgeInsets.zero,
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.zero,
          )
        : Material(
            color: Theme.of(context).cardColor,
            child: InkWell(
              child: _content,
              onTap: () => _onTap(context),
            ),
          );
  }

  void _onTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailPage(product),
      ),
    );
  }

  void _toggleWished(BuildContext context) =>
      Provider.of<CategorySpecificProductsBLOC>(context, listen: false)
          .toggleItemWished(product);
}
