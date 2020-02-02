import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/blocs/cart_bloc.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/branded_image.dart';
import 'package:mega_dot_pk/widgets/native_icons.dart';
import 'package:provider/provider.dart';

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
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: <Widget>[
              _itemCounterText(),
              _itemContent(),
              _actionButtons(),
            ],
          ),
        ),
      );

  _itemCounterText() => Padding(
        padding: EdgeInsets.symmetric(
          vertical: sizeConfig.height(.005),
        ),
        child: Text(
          "Qty. ${widget.itemCounter}",
          style: Theme.of(context).textTheme.subhead.copyWith(
                color: Theme.of(context).disabledColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      );

  _actionButtons() {
    Widget _deleteButtonContent = Container(
      padding: EdgeInsets.symmetric(
        vertical: sizeConfig.height(.01),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            NativeIcons.remove(),
            color: Theme.of(context).errorColor,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: sizeConfig.width(.01),
            ),
            child: Text(
              "Remove",
              style: Theme.of(context).textTheme.subtitle.copyWith(
                    color: Theme.of(context).errorColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );

    return defaultTargetPlatform == TargetPlatform.iOS
        ? CupertinoButton(
            child: _deleteButtonContent,
            onPressed: _removeFromCart,
            padding: EdgeInsets.zero,
            borderRadius: BorderRadius.circular(20),
          )
        : Material(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20),
            child: InkWell(
              onTap: _removeFromCart,
              borderRadius: BorderRadius.circular(20),
              child: _deleteButtonContent,
            ),
          );
  }

  _itemContent() => Container(
        height: sizeConfig.height(.18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: sizeConfig.width(.035),
        ),
        width: double.maxFinite,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                borderRadius: BorderRadius.circular(14),
              ),
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(
                vertical: sizeConfig.height(.025),
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BrandedImage(
                    widget.item.xsThumbnailImageURL,
                    fit: BoxFit.contain,
                    height: sizeConfig.height(.08),
                    width: sizeConfig.width(.3),
                  ),
                ),
              ),
            ),
            Container(),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(
                  vertical: sizeConfig.height(.02),
                ),
                padding: EdgeInsets.only(
                  left: sizeConfig.width(.07),
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
      );

  _removeFromCart() =>
      Provider.of<CartBLOC>(context, listen: false).removeItem(widget.item.id);
}
