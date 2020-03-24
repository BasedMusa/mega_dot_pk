import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/blocs/product_blocs.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/brand_list_item.dart';
import 'package:mega_dot_pk/widgets/branded_error_page.dart';
import 'package:mega_dot_pk/widgets/branded_loading_indicator.dart';
import 'package:mega_dot_pk/widgets/sliver_product_grid.dart';
import 'package:mega_dot_pk/widgets/styled_appbar.dart';
import 'package:provider/provider.dart';

class ProductsPage extends StatefulWidget {
  final Category category;

  ProductsPage(this.category);

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar(),
        body: _body(context),
      );

  _appBar() => StyledAppBar(widget.category.name);

  _body(BuildContext context) => Consumer<CategorySpecificProductsBLOC>(
        builder: (_, bloc, __) => bloc.taskStatus.loading
            ? BrandedLoadingIndicator()
            : bloc.taskStatus.error
                ? BrandedErrorPage(bloc.taskStatus, bloc.loadData)
                : bloc.hasItems && bloc.taskStatus.loading == false
                    ? Container(
                        child: _bodyContent(bloc),
                      )
                    : Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: sizeConfig.width(.1),
                          ),
                          child: Text(
                            "No Products Found",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              letterSpacing: -2,
                              fontWeight: FontWeight.w600,
                              fontSize: sizeConfig.text(30),
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                        ),
                      ),
      );

  _bodyContent(CategorySpecificProductsBLOC bloc) => CupertinoScrollbar(
        child: CustomScrollView(
          slivers: <Widget>[
            ///Products Title
            SliverToBoxAdapter(
              child: _title("Brands"),
            ),

            ///Brand List (Horizontal)
            SliverToBoxAdapter(
              child: Container(
                height: sizeConfig.height(.1),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) =>
                      BrandListItem(widget.category.brands[index]),
                  itemCount: widget.category.brands.length,
                ),
              ),
            ),

            ///Products Title
            SliverToBoxAdapter(
              child: _title("Products"),
            ),

            ///Products Grid
            SliverPadding(
              padding: EdgeInsets.only(
                bottom: sizeConfig.height(.1) + sizeConfig.safeArea.bottom,
              ),
              sliver: SliverProductsGrid(bloc.products),
            ),
          ],
        ),
      );

  Widget _title(String text) => Padding(
        padding: EdgeInsets.only(
          top: sizeConfig.height(.05),
          bottom: sizeConfig.height(.008),
          left: sizeConfig.width(.05),
          right: sizeConfig.width(.05),
        ),
        child: Text(
          text,
          style: Theme.of(context).primaryTextTheme.headline6.copyWith(
                color: Theme.of(context).primaryTextTheme.subtitle2.color,
              ),
        ),
      );
}
