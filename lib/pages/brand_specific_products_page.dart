import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/blocs/product_blocs.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/widgets/branded_error_page.dart';
import 'package:mega_dot_pk/widgets/branded_loading_indicator.dart';
import 'package:mega_dot_pk/widgets/sliver_product_grid.dart';
import 'package:mega_dot_pk/widgets/styled_appbar.dart';
import 'package:provider/provider.dart';

class BrandSpecificProductsPage extends StatelessWidget {
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar(context),
        body: _body(context),
      );

  _appBar(BuildContext context) {
    BrandSpecificProductsBLOC bloc =
        Provider.of<BrandSpecificProductsBLOC>(context, listen: false);

    return StyledAppBar("${bloc.brand?.name} ${bloc.category?.name}");
  }

  _body(BuildContext context) => Consumer<BrandSpecificProductsBLOC>(
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

  _bodyContent(BrandSpecificProductsBLOC bloc) => CupertinoScrollbar(
        child: CustomScrollView(
          slivers: <Widget>[
            ///Products Grid
            SliverPadding(
              padding: EdgeInsets.only(
                top: sizeConfig.height(.05),
                bottom: sizeConfig.height(.1) + sizeConfig.safeArea.bottom,
              ),
              sliver: SliverProductsGrid(bloc.products),
            ),
          ],
        ),
      );
}
