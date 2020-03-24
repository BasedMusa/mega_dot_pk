import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/blocs/product_blocs.dart';
import 'package:mega_dot_pk/pages/brand_specific_products_page.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/mixins.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/branded_image.dart';
import 'package:provider/provider.dart';

class BrandListItem extends StatelessWidget with PlatformBoolMixin {
  final Brand brand;

  BrandListItem(this.brand);

  @override
  Widget build(BuildContext context) {
    double _width = 100;

    Widget _content = Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(bottom: sizeConfig.height(.0175)),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                width: 1,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          child: Container(
            width: _width,
            height: double.maxFinite,
            padding: EdgeInsets.symmetric(
              horizontal: sizeConfig.width(.035),
              vertical: sizeConfig.height(.0145),
            ),
            child: brand.imageURL != null && brand.imageURL.isNotEmpty
                ? BrandedImage(
                    brand.imageURL,
                    width: _width,
                    fit: BoxFit.contain,
                    backgroundIsCard: true,
                  )
                : Center(
                    child: Text(
                      brand.name,
                      style: Theme.of(context).primaryTextTheme.subtitle2,
                    ),
                  ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          width: _width,
          height: double.maxFinite,
          padding: EdgeInsets.symmetric(
            vertical: sizeConfig.height(.008),
          ),
          child: Text(
            "${brand.activeItems} Items",
            textAlign: TextAlign.center,
            style: Theme.of(context).primaryTextTheme.caption.copyWith(
                  fontStyle: FontStyle.italic,
                ),
          ),
        ),
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
    Category category =
        Provider.of<CategorySpecificProductsBLOC>(context, listen: false)
            .category;

    BrandSpecificProductsBLOC bloc =
        Provider.of<BrandSpecificProductsBLOC>(context, listen: false);

    bloc.updateBaseData(brand: brand, category: category);
    bloc.loadData();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BrandSpecificProductsPage(),
      ),
    );
  }
}
