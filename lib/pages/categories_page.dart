import 'package:flutter/material.dart';
import 'package:mega_dot_pk/blocs/categories_bloc.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/mixins.dart';
import 'package:mega_dot_pk/widgets/branded_error_page.dart';
import 'package:mega_dot_pk/widgets/branded_loading_indicator.dart';
import 'package:mega_dot_pk/widgets/category_list_item.dart';
import 'package:mega_dot_pk/widgets/styled_appbar.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget with PlatformBoolMixin {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar(),
        body: _body(),
      );

  _appBar() => StyledAppBar("Categories");

  _body() => Container(
        child: Consumer<CategoriesBLOC>(
          builder: (context, bloc, __) => Container(
            child: bloc.taskStatus.loading
                ? BrandedLoadingIndicator()
                : bloc.taskStatus.error
                    ? BrandedErrorPage(bloc.taskStatus, bloc.loadData)
                    : SingleChildScrollView(
                        padding: EdgeInsets.only(
                          top: sizeConfig.height(.065),
                          bottom: sizeConfig.height(.1) +
                              sizeConfig.safeArea.bottom,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Theme.of(context).dividerColor,
                                width: 2,
                              ),
                            ),
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 15,
                                color: Theme.of(context).dividerColor,
                              ),
                            ],
                          ),
                          child: Column(
                            children: List.generate(
                              bloc.categories.length,
                              (int index) =>
                                  CategoryListItem(bloc.categories[index]),
                            ),
                          ),
                        ),
                      ),
          ),
        ),
      );
}
