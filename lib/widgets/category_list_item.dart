import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/pages/browse_category_page.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/branded_image.dart';

import '../pages/browse_category_page.dart';

class CategoryListItem extends StatefulWidget {
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
    final bool _isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    Widget _categoryName = Expanded(
      child: Container(
        padding: EdgeInsets.only(
          left: _isIOS ? sizeConfig.width(.0125) : sizeConfig.width(.03),
        ),
        child: Text(
          widget.category.name,
          style: Theme.of(context).textTheme.title,
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

    /*iOS Only*/
    Widget _navigationIcon = Padding(
      padding: EdgeInsets.only(
        right: sizeConfig.width(.025),
      ),
      child: Icon(
        Icons.navigate_next,
        color: Theme.of(context).iconTheme.color,
      ),
    );
    Widget _content = Padding(
      padding: EdgeInsets.symmetric(
        horizontal: sizeConfig.width(.025),
      ),
      child: Row(
        children: _isIOS
            ? [
                _categoryImage,
                _categoryName,
                _navigationIcon,
              ]
            : [
                _categoryName,
                _categoryImage,
              ],
      ),
    );
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.only(
        bottom: sizeConfig.width(.05),
        right: sizeConfig.width(.05),
        left: sizeConfig.width(.05),
      ),
      child: _isIOS
          ? CupertinoButton(
              padding: EdgeInsets.zero,
              color: Theme.of(context).scaffoldBackgroundColor,
              onPressed: _onTap,
              child: _content,
            )
          : Material(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: InkWell(
                onTap: _onTap,
                splashColor: Theme.of(context).splashColor,
                borderRadius: BorderRadius.circular(10),
                child: _content,
              ),
            ),
    );
  }

  Future<void> _onTap() async {
    CategoryPageReturnType returnType = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BrowseCategoryPage(widget.category),
          ),
        ) ??
        CategoryPageReturnType.Back;

    if (returnType == CategoryPageReturnType.Search)
      widget.searchButtonCallback();
  }
}
