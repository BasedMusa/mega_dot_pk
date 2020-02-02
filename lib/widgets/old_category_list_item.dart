import 'package:flutter/material.dart';
import 'package:mega_dot_pk/pages/browse_category_page.dart';
import 'package:mega_dot_pk/utils/constants.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/transparent_image.dart';

class OldCategoryListItem extends StatefulWidget {
  final Category category;

  OldCategoryListItem(this.category);

  @override
  _OldCategoryListItemState createState() => _OldCategoryListItemState();
}

class _OldCategoryListItemState extends State<OldCategoryListItem> {
  Map imgs = {
    "42":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQmw2M3Du3wNa02lMjCPjEMrauT3Im4NIVYAFHE0A36RBPyrTbW",
    "57":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQpEJTt1rc6uK8CCMdajv2zIanVfoK6blnu9wSgy-zdaXr3CROM",
    "58":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcSGxDptfiY2M-prQF4llYw1JwY0ku6nChBiaeTd4oKEfYOaTnDP",
    "63":
        "https://i.gadgets360cdn.com/large/Best_phones_2018_thumb_ndtv_1545054666195.jpg",
    "65":
        "https://static.digit.in/default/d60018423f1426aec6c60cdca131626912db7acb.jpeg",
    "95":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQQfungHsdTFHjriLSuvrxwjuz9GKCymxJj7uliytivhgUSxmIR",
    "114":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcRTWRf5Zx_bEbs-S9yTvAO3Z6JqEsXYaJPx-TASKv5D6smzftxo",
    "160":
        "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcT4FLxbbZGcjhkDyfMD72SXqhwX525oc8UsyBqFFDc1bYVUhdGb",
  };

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(
          top: sizeConfig.height(.0075),
        ),
        child: InkWell(
          onTap: _onTap,
          child: AnimatedContainer(
            duration: Constants.animationDuration,
            width: double.maxFinite,
            decoration: BoxDecoration(
              color: Theme.of(context).canvasColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: .4,
              ),
            ),
            child: Stack(
              children: <Widget>[
                SizedBox.expand(
                  child: Container(
                    foregroundDecoration: BoxDecoration(
                      color: Colors.black.withOpacity(.35),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: FadeInImage(
                        placeholder: MemoryImage(kTransparentImage),
                        image: NetworkImage(imgs[widget.category.id]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: sizeConfig.height(.035),
                    horizontal: sizeConfig.width(.08),
                  ),
                  child: Center(
                    child: Text(
                      widget.category.name.toUpperCase(),
                      maxLines: 1,
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontSize: 14,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  void _onTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BrowseCategoryPage(widget.category),
      ),
    );
  }
}
