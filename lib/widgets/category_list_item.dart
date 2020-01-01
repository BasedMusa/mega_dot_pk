import 'package:flutter/material.dart';
import 'package:mega_dot_pk/pages/category_page.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/transparent_image.dart';

class CategoryListItem extends StatefulWidget {
  final Category category;

  CategoryListItem(this.category);

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
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(
          bottom: sizeConfig.width(.05),
          right: sizeConfig.width(.05),
          left: sizeConfig.width(.05),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: InkWell(
            onTap: _onTap,
            splashColor: Theme.of(context).splashColor,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              child: Stack(
                children: <Widget>[
                  Container(
                    width: double.maxFinite,
                    padding: EdgeInsets.symmetric(
                      vertical: sizeConfig.height(.025),
                      horizontal: sizeConfig.width(.065),
                    ),
                    child: Text(
                      widget.category.name,
                      style: Theme.of(context).textTheme.title,
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: 10,
                    bottom: 10,
                    child: Container(
                      width: sizeConfig.height(.1),
                      height: sizeConfig.height(.1),
                      child: FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: NetworkImage(thumbnailURLs[widget.category.id]),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  void _onTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryPage(widget.category),
      ),
    );
  }
}
