import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/blocs/product_blocs.dart';
import 'package:mega_dot_pk/pages/products_page.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/mixins.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/branded_image.dart';
import 'package:provider/provider.dart';

class CategoryListItem extends StatefulWidget with PlatformBoolMixin {
  final Category category;
  final Function() searchButtonCallback;

  CategoryListItem(this.category, {this.searchButtonCallback});

  @override
  _CategoryListItemState createState() => _CategoryListItemState();
}

class _CategoryListItemState extends State<CategoryListItem> {
  Map thumbnailURLs = {
    "42": "http://www.mega.pk/images/bg-bt-laptops.png",
    "57": "http://www.mega.pk/images/bg-bt-tv.png",
    "58": "http://www.mega.pk/images/bg-bt-desktopcomputer.png",
    "63": "http://www.mega.pk/images/bg-bt-mobiles.png",
    "65": "http://www.mega.pk/images/bg-bt-gconsoles.png",
    "95": "http://www.mega.pk/images/bg-bt-tablets.png",
    "114": "http://www.mega.pk/images/bg-bt-camera.png",
    "160": "http://www.mega.pk/images/bg-bt-watches.png",
  };

  @override
  Widget build(BuildContext context) {
    Widget _categoryName = Expanded(
      child: Container(
        padding: EdgeInsets.only(
          left: widget.isIOS ? sizeConfig.width(.0225) : sizeConfig.width(.03),
        ),
        child: Text(
          widget.category.name,
          style: Theme.of(context).primaryTextTheme.subtitle1,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ),
    );

    Widget _categoryImage = BrandedImage(
      thumbnailURLs[widget.category.id],
      fit: BoxFit.contain,
      height: sizeConfig.height(.085),
      width: sizeConfig.height(.085),
    );

    Widget _navigationIcon = Padding(
      padding: EdgeInsets.only(
        right: sizeConfig.width(.025),
      ),
      child: Transform.rotate(
        angle: pi,
        child: Icon(
          Icons.keyboard_backspace,
          color: Theme.of(context).iconTheme.color,
        ),
      ),
    );
    Widget _content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sizeConfig.width(.045),
        vertical: sizeConfig.height(.0165),
      ),
      child: Row(
        children: [
          _categoryImage,
          _categoryName,
          _navigationIcon,
        ],
      ),
    );
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: .5,
          ),
        ),
      ),
      child: widget.isIOS
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              color: Theme.of(context).cardColor,
              onPressed: _onTap,
              child: _content,
              borderRadius: BorderRadius.zero,
            )
          : Material(
              color: Theme.of(context).cardColor,
              child: InkWell(
                onTap: _onTap,
                child: _content,
              ),
            ),
    );
  }

  Future<void> _onTap() async {
    CategorySpecificProductsBLOC bloc =
        Provider.of<CategorySpecificProductsBLOC>(context, listen: false);

    bloc.updateBaseData(category: widget.category);
    bloc.loadData();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductsPage(widget.category),
      ),
    );
  }
}
