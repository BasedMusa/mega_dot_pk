import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/blocs/item_details_bloc.dart';
import 'package:mega_dot_pk/pages/item_detail_page.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/branded_image.dart';
import 'package:provider/provider.dart';

class ItemGridItem extends StatefulWidget {
  final int itemIndex;
  final Item item;

  ItemGridItem(this.itemIndex, this.item);

  @override
  _ItemGridItemState createState() => _ItemGridItemState();
}

class _ItemGridItemState extends State<ItemGridItem> {
  GlobalKey _key = GlobalKey();

  bool _bookmarked = false;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => ItemDetailsBLOC(widget.item),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: sizeConfig.width(.015),
          ),
          child: Consumer<ItemDetailsBLOC>(
            builder: (_, bloc, __) => InkWell(
              onTap: () => _onTap(bloc),
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).canvasColor,
                  border: Border.all(
                    color: Theme.of(context).dividerColor,
                    width: 0.4,
                  ),
                ),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: sizeConfig.height(.003),
                        ),
                        child: IconButton(
                          icon: Icon(
                            _bookmarked
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: auth.isAuthorized
                                ? _bookmarked
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).primaryIconTheme.color
                                : Colors.black.withOpacity(0),
                          ),
                          onPressed: auth.isAuthorized
                              ? () => setState(() => _bookmarked = !_bookmarked)
                              : null,
                        ),
                      ),
                    ),
                    Container(
                      key: _key,
                      padding: EdgeInsets.symmetric(
                        horizontal: sizeConfig.width(.01),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          ///Image
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(
                              top: sizeConfig.height(.005),
                              bottom: sizeConfig.height(.05),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: BrandedImage(
                                widget.item.xsThumbnailImageURL,
                                fit: BoxFit.contain,
                                height: sizeConfig.height(.11),
                              ),
                            ),
                          ),
                          ///Price
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: sizeConfig.width(.035),
                            ),
                            child: Text(
                              "${widget.item.price} PKR",
                              style: TextStyle(
                                color: Colors.green[400],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: sizeConfig.width(.035),
                            ),
                            child: Text(
                              widget.item.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.title.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.symmetric(
                              horizontal: sizeConfig.width(.035),
                            ),
                            child: Text(widget.item.brandName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.subtitle),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  _onTap(ItemDetailsBLOC bloc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailPage(widget.item, bloc),
      ),
    );
  }
}
