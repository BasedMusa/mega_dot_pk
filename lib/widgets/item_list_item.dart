import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/branded_image.dart';

class ItemListItem extends StatefulWidget {
  final Item item;

  ItemListItem(this.item);

  @override
  _ItemListItemState createState() => _ItemListItemState();
}

class _ItemListItemState extends State<ItemListItem> {
  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          top: sizeConfig.height(.035),
        ),
        child: Container(
          height: sizeConfig.height(.18),
          margin: EdgeInsets.symmetric(
            horizontal: sizeConfig.width(.05),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Theme.of(context).canvasColor,
            border: Border.all(
              color: Theme.of(context).dividerColor,
              width: 0.4,
            ),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: sizeConfig.width(.055),
          ),
          width: double.maxFinite,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  vertical: sizeConfig.height(.025),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Center(
                    child: BrandedImage(
                      widget.item.xsThumbnailImageURL,
                      fit: BoxFit.contain,
                      height: sizeConfig.height(.08),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                  left: sizeConfig.width(.045),
                ),
                height: double.maxFinite,
                color: Theme.of(context).dividerColor,
                width: 0.4,
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    vertical: sizeConfig.height(.02),
                  ),
                  padding: EdgeInsets.only(
                    left: sizeConfig.width(.025),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.item.warranty,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        widget.item.name,
                        style: Theme.of(context).textTheme.title,
                      ),
                      Text(
                        widget.item.brandName,
                        style: Theme.of(context).textTheme.subtitle.copyWith(
                              fontSize: sizeConfig.text(17),
                            ),
                      ),
                      Spacer(),
                      Text(
                        widget.item.stock,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      Text(
                        "${widget.item.price} PKR",
                        style: Theme.of(context).textTheme.title.copyWith(
                              color: Colors.green,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
