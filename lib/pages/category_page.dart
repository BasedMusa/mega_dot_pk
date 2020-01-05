import 'dart:ui';
import 'dart:math';
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/cupertino.dart' hide NestedScrollView;
import 'package:flutter/material.dart' hide NestedScrollView;
import 'package:mega_dot_pk/blocs/filters_bloc.dart';
import 'package:mega_dot_pk/blocs/items_bloc.dart';
import 'package:mega_dot_pk/utils/constants.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/branded_error_page.dart';
import 'package:mega_dot_pk/widgets/branded_fab.dart';
import 'package:mega_dot_pk/widgets/item_grid_item.dart';
import 'package:mega_dot_pk/widgets/branded_loading_indicator.dart';
import 'package:mega_dot_pk/widgets/native_icons.dart';
import 'package:mega_dot_pk/widgets/slide_up_page_route.dart';
import 'package:provider/provider.dart';
import '../utils/globals.dart';

class CategoryPage extends StatefulWidget {
  final Category category;

  CategoryPage(this.category);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  ScrollController _headerScrollController = ScrollController();

  bool _headerScrolledOver = false;

  @override
  void initState() {
    super.initState();
    _headerScrollController.addListener(_statusBarShadowListener);
  }

  @override
  void dispose() {
    _headerScrollController?.removeListener(_statusBarShadowListener);
    _headerScrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => ItemsBLOC(widget.category),
        child: Scaffold(
          body: _body(),
          floatingActionButton: _headerScrolledOver ? _fab() : null,
        ),
      );

  _appBar() => SliverAppBar(
        elevation: .4,
        centerTitle: true,
        expandedHeight: sizeConfig.height(.4),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: <Widget>[
          IconButton(
            icon: Icon(NativeIcons.search()),
            onPressed: () =>
                Navigator.pop(context, CategoryPageReturnType.Search),
          )
        ],
        flexibleSpace: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(widget.category.name,
                    style: Theme.of(context).textTheme.display1),
                Text(widget.category.description),
              ],
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: sizeConfig.width(.04),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: _SortButton()),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: sizeConfig.width(.025),
                  ),
                ),
                Expanded(
                  child: _FilterButton(widget.category),
                ),
              ],
            ),
          ),
        ),
      );

  _fab() => BrandedFAB(
        icon: Icons.keyboard_arrow_up,
        onPressed: () => _headerScrollController.animateTo(
          0,
          duration: Constants.animationDuration,
          curve: Curves.easeInOut,
        ),
      );

  _body() => NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxScrolled) =>
            [_appBar()],
        controller: _headerScrollController,
        body: Consumer<ItemsBLOC>(
          builder: (context, bloc, _) => Container(
            child: bloc.taskStatus.loading &&
                    (bloc.items == null || bloc.items.isEmpty)
                ? BrandedLoadingIndicator()
                : bloc.taskStatus.error
                    ? BrandedErrorPage(bloc.taskStatus, bloc.loadData)
                    : Stack(
                        children: <Widget>[
                          _ItemsGridView(bloc),
                          AnimatedContainer(
                            duration: Constants.animationDuration,
                            height: _headerScrolledOver
                                ? sizeConfig.safeArea.top +
                                    sizeConfig.height(.035)
                                : 0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Theme.of(context).scaffoldBackgroundColor,
                                    Colors.white.withOpacity(0),
                                  ]),
                            ),
                          ),
                        ],
                      ),
          ),
        ),
      );

  _statusBarShadowListener() => _headerScrollController.position.pixels >=
          _headerScrollController.position.maxScrollExtent
      ? setState(() => _headerScrolledOver = true)
      : setState(() => _headerScrolledOver = false);
}

class _ItemsGridView extends StatefulWidget {
  final ItemsBLOC bloc;

  _ItemsGridView(this.bloc);

  @override
  __ItemsGridViewState createState() => __ItemsGridViewState();
}

class __ItemsGridViewState extends State<_ItemsGridView>
    with AutomaticKeepAliveClientMixin {
  GlobalKey _gridViewKey = GlobalKey();
  GlobalKey _lazyLoadingIndicatorKey = GlobalKey();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification notification) {
        notification.disallowGlow();
        return true;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: _onScroll,
        child: NestedScrollViewInnerScrollPositionKeyWidget(
          _gridViewKey,
          CustomScrollView(
            slivers: <Widget>[
              SliverPadding(
                padding: EdgeInsets.only(
                  top: sizeConfig.height(.035),
                  right: sizeConfig.width(.01),
                  left: sizeConfig.width(.01),
                ),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: .75,
                    mainAxisSpacing: 25,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, i) => ItemGridItem(i, widget.bloc.items[i]),
                    childCount: widget.bloc.items?.length ?? 0,
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(
                  bottom: sizeConfig.height(.1) + sizeConfig.safeArea.bottom,
                ),
                sliver: SliverToBoxAdapter(
                  child: _lazyLoadingIndicator(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _lazyLoadingIndicator() => AnimatedOpacity(
        opacity: widget.bloc.hasMore ?? false ? 1 : 0,
        duration: Constants.animationDuration,
        child: Container(
          key: _lazyLoadingIndicatorKey,
          padding: EdgeInsets.only(
            top: sizeConfig.height(.1),
          ),
          width: double.maxFinite,
          child: BrandedLoadingIndicator(),
        ),
      );

  bool _onScroll(ScrollNotification notification) {
    RenderBox lazyLoadingIndicatorRenderBox =
        _lazyLoadingIndicatorKey?.currentContext?.findRenderObject();

    double lazyLoadTriggerPosition = notification.metrics.maxScrollExtent -
        (lazyLoadingIndicatorRenderBox?.size?.height ?? 200);
    double currentPosition = notification.metrics.pixels;

    bool _listScrolledCompletely = currentPosition >= lazyLoadTriggerPosition;

    if (_listScrolledCompletely) {
      ItemsBLOC bloc = Provider.of<ItemsBLOC>(context, listen: false);
      if (bloc.taskStatus.loading == false)
        bloc.loadData(
            brandFilter: bloc.brand,
            sortingFilter: bloc.sorting,
            lazyLoading: true);
    }

    return true;
  }
}

class _SortButton extends StatefulWidget {
  @override
  __SortButtonState createState() => __SortButtonState();
}

class __SortButtonState extends State<_SortButton> {
  @override
  Widget build(BuildContext context) => Material(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).canvasColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: _onTap,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: sizeConfig.width(.035),
              vertical: sizeConfig.height(.01) + 4,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context).dividerColor,
                width: .4,
              ),
            ),
            child: Selector<ItemsBLOC, Sorting>(
              selector: (BuildContext context, ItemsBLOC bloc) => bloc.sorting,
              builder: (_, sorting, __) => Row(
                children: <Widget>[
                  Icon(
                    Icons.sort,
                    color: sorting != null
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).iconTheme.color,
                  ),
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.only(
                        left: sizeConfig.width(.025),
                      ),
                      child: Text(
                        sorting?.name ?? "Sort",
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.button.copyWith(
                              color: sorting != null
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).textTheme.body1.color,
                            ),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: sorting != null
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).iconTheme.color,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> _onTap() async {
    ItemsBLOC bloc = Provider.of<ItemsBLOC>(context, listen: false);

    List<Sorting> _sortingOptions = [
      Sorting(0, "Name A - Z"),
      Sorting(1, "Name Z - A"),
      Sorting(2, "Price Lowest First"),
      Sorting(3, "Price Highest First"),
    ];

    if (bloc.sorting != null) _sortingOptions.add(Sorting(4, "Clear"));

    int value;

    value = await showMenu(
      context: context,
      position: buttonBottomLeftPosition(),
      initialValue: bloc.sorting?.value,
      items: _sortingOptions
          .map(
            (Sorting sorting) => PopupMenuItem(
              value: sorting.value,
              child: Text(
                sorting.name,
                style: Theme.of(context).textTheme.subtitle.copyWith(
                      fontWeight: bloc.sorting?.value == sorting.value
                          ? FontWeight.w700
                          : null,
                    ),
              ),
            ),
          )
          .toList(),
    );

    if (value != null)
      value == 4
          ? bloc.loadData(brandFilter: bloc.brand)
          : bloc.loadData(
              sortingFilter: _sortingOptions[value],
              brandFilter: bloc.brand,
            );
  }

  RelativeRect buttonBottomLeftPosition() {
    final RenderBox button = context.findRenderObject();
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(button.size.bottomLeft(Offset.zero),
            ancestor: overlay),
        button.localToGlobal(button.size.bottomLeft(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );
    return position;
  }
}

class _FilterButton extends StatefulWidget {
  final Category category;

  _FilterButton(this.category);

  @override
  __FilterButtonState createState() => __FilterButtonState();
}

class __FilterButtonState extends State<_FilterButton> {
  @override
  Widget build(BuildContext context) => Selector<ItemsBLOC, String>(
        selector: (context, ItemsBLOC bloc) => bloc.brand?.name,
        builder: (_, value, __) => Material(
          color: value != null
              ? Theme.of(context).primaryColor
              : Theme.of(context).textTheme.body1.color,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: _onTap,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: sizeConfig.width(.035),
                vertical: sizeConfig.height(.01) + 4,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.filter_list,
                    color: Theme.of(context).textTheme.button.color,
                  ),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                        horizontal: sizeConfig.width(.025),
                      ),
                      child: Text(
                        value != null ? "\"$value\" Only" : "Filter Brands",
                        maxLines: 1,
                        style: Theme.of(context).textTheme.button,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

  Future<void> _onTap() async {
    ItemsBLOC bloc = Provider.of<ItemsBLOC>(context, listen: false);

    Brand brand = await Navigator.push(
      context,
      SlideUpPageRoute(
        child: _FilterPage(
          widget.category,
          bloc.brand,
        ),
      ),
    );
    bloc.loadData(brandFilter: brand, sortingFilter: bloc.sorting);
  }
}

class _FilterPage extends StatefulWidget {
  final Category category;
  final Brand selectedBrand;

  _FilterPage(this.category, this.selectedBrand);

  @override
  __FilterPageState createState() => __FilterPageState();
}

class __FilterPageState extends State<_FilterPage> {
  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => FiltersBLOC(widget.category),
        child: Scaffold(
          appBar: _appBar(),
          body: _body(),
        ),
      );

  _appBar() => AppBar(
        elevation: 0.6,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text("Filter Brands"),
        leading: IconButton(
          icon: Transform.rotate(
            angle: pi / 2,
            child: Icon(Icons.chevron_right),
          ),
          onPressed: () => Navigator.pop(
            context,
            widget.selectedBrand,
          ),
        ),
        actions: <Widget>[
          widget.selectedBrand != null
              ? CupertinoButton(
                  child: Text(
                    "Clear",
                    style: TextStyle(
                      color: Theme.of(context).errorColor,
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                )
              : Container(),
        ],
      );

  _body() => Consumer<FiltersBLOC>(
        builder: (BuildContext buildContext, FiltersBLOC bloc, __) =>
            bloc.taskStatus.loading
                ? BrandedLoadingIndicator()
                : bloc.taskStatus.error
                    ? BrandedErrorPage(
                        bloc.taskStatus,
                        bloc.loadData,
                      )
                    : bloc.brands.length == 0
                        ? _noFiltersAvailable()
                        : Container(
                            child: ListView.builder(
                              itemCount: bloc.brands.length,
                              itemBuilder: (context, i) =>
                                  _filterListItem(bloc.brands[i]),
                            ),
                          ),
      );

  _noFiltersAvailable() => Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "No Filters Found",
                textAlign: TextAlign.center,
                style: TextStyle(
                  letterSpacing: -2,
                  fontWeight: FontWeight.w600,
                  fontSize: sizeConfig.text(30),
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ],
          ),
        ),
      );

  _filterListItem(Brand brand) => Column(
        children: <Widget>[
          ListTile(
            dense: true,
            onTap: () => Navigator.pop(context, brand),
            title: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: sizeConfig.width(.01),
                  ),
                  child: Text(
                    brand.name,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: sizeConfig.width(.025),
                  ),
                  child: Text(
                    "${brand.totalItems} Items",
                    style: Theme.of(context).textTheme.caption.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            height: 0,
          ),
        ],
      );
}

enum CategoryPageReturnType { Search, Back }
