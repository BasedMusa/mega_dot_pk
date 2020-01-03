import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/branded_image.dart';

class ItemCartListItem extends StatefulWidget {
  final Item item;
  final int itemCounter;

  ItemCartListItem(this.item, this.itemCounter);

  @override
  _ItemCartListItemState createState() => _ItemCartListItemState();
}

class _ItemCartListItemState extends State<ItemCartListItem> {
  @override
  void initState() {
    assert(widget.itemCounter >= 1,
        "This should be atleast 1, else there is probably an error in the logic.");
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.only(
          top: sizeConfig.height(.035),
        ),
        child: Stack(
          children: <Widget>[
            ///Main Cart List Item
            Container(
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
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.title,
                          ),
                          Text(
                            widget.item.brandName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style:
                                Theme.of(context).textTheme.subtitle.copyWith(
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

            ///Item Counter
            widget.itemCounter > 1
                ? Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: sizeConfig.width(.075),
                      vertical: sizeConfig.height(.01),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: sizeConfig.width(.015),
                      vertical: sizeConfig.height(.005),
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).primaryColor,
                    ),
                    child: Text(
                      "${widget.itemCounter} Items",
                      style: Theme.of(context).textTheme.caption.copyWith(
                            fontSize: 12,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                    ),
                  )
                : Container(),
          ],
        ),
      );
}
