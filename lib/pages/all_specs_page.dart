import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/widgets/native_icons.dart';

import '../utils/globals.dart';

class AllSpecsPage extends StatefulWidget {
  final String title;
  final Map specs;

  AllSpecsPage(this.title, this.specs);

  @override
  _AllSpecsPageState createState() => _AllSpecsPageState();
}

class _AllSpecsPageState extends State<AllSpecsPage> {
  bool _searchMode = false;

  String _searchQuery = "";

  TextEditingController _searchFieldController = TextEditingController();

  FocusNode _searchFieldFocusNode = FocusNode();

  ScrollController _pageScrollController = ScrollController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar(),
        body: _body(),
        backgroundColor: Theme.of(context).canvasColor,
      );

  @override
  void dispose() {
    _pageScrollController?.dispose();
    _searchFieldController?.dispose();
    _searchFieldFocusNode?.dispose();
    super.dispose();
  }

  _appBar() => AppBar(
        elevation: .4,
        title: Text(widget.title),
        actions: <Widget>[
          AnimatedCrossFade(
            firstChild: IconButton(
                icon: Icon(
                  NativeIcons.search(),
                ),
                onPressed: () async {
                  await _pageScrollController.animateTo(0,
                      duration: Duration(milliseconds: 150),
                      curve: Curves.easeInToLinear);

                  setState(() => _searchMode = true);

                  _searchFieldFocusNode.requestFocus();
                }),
            secondChild: IconButton(
              icon: Icon(
                defaultTargetPlatform == TargetPlatform.iOS
                    ? CupertinoIcons.clear_circled
                    : Icons.clear,
              ),
              onPressed: () => setState(() {
                if (_searchFieldFocusNode.hasFocus)
                  _searchFieldFocusNode.unfocus();
                _searchFieldController.clear();
                _searchQuery = "";
                _searchMode = false;
              }),
            ),
            crossFadeState: _searchMode
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: Duration(milliseconds: 150),
          ),
        ],
      );

  _body() => Container(
        child: SingleChildScrollView(
          controller: _pageScrollController,
          padding: EdgeInsets.only(
            bottom: sizeConfig.height(.045) + sizeConfig.safeArea.bottom,
          ),
          child: Column(
            children: <Widget>[
              ///Search Field
              AnimatedContainer(
                duration: Duration(milliseconds: 100),
                height: _searchMode ? sizeConfig.height(.055) : 0,
                margin: EdgeInsets.only(
                  top: sizeConfig.height(.025),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: sizeConfig.width(.05),
                ),
                child: TextField(
                  focusNode: _searchFieldFocusNode,
                  controller: _searchFieldController,
                  onChanged: (String query) =>
                      setState(() => _searchQuery = query),
                  decoration: InputDecoration(
                    hintText: "Search through specs...",
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: sizeConfig.width(.04),
                    ),
                  ),
                ),
              ),

              ///Specs
              Column(
                children: List<Widget>.generate(
                  widget.specs.keys.length,
                  (i) => _generateTable(widget.specs.values.toList()[i], i),
                ),
              ),
            ],
          ),
        ),
      );

  _generateTable(Map specs, int index) {
    Widget specsTable = Container(
      margin: index != 0
          ? EdgeInsets.only(
              top: sizeConfig.height(.035),
            )
          : EdgeInsets.only(
              top: sizeConfig.height(.0175),
            ),
      child: _SpecsTable(specs, _searchQuery),
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sizeConfig.width(.05),
      ),
      child: specsTable,
    );
  }
}

class _SpecsTable extends StatefulWidget {
  final Map specs;
  final String searchQuery;

  _SpecsTable(this.specs, this.searchQuery);

  @override
  __SpecsTableState createState() => __SpecsTableState();
}

class __SpecsTableState extends State<_SpecsTable> {
  @override
  Widget build(BuildContext context) => Table(
        children: _generateRows(widget.specs),
      );

  List<TableRow> _generateRows(Map<String, dynamic> specs, {int padding = 0}) {
    List<TableRow> _rows = [];

    specs.forEach((String key, dynamic value) {
      if (value is Map) {
        List<TableRow> _subRows = _generateRows(value, padding: padding + 1);

        if (_subRows.isNotEmpty) {
          _rows.addAll(_subRows);
          _rows.add(_tableRow(key, value, padding));
        }
      } else if (key.toLowerCase().contains(widget.searchQuery.toLowerCase()))
        _rows.add(_tableRow(key, value, padding));
    });

    return _rows;
  }

  TableRow _tableRow(String key, dynamic value, int padding) => TableRow(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Theme.of(context).dividerColor.withOpacity(.75),
              width: .5,
            ),
          ),
        ),
        children: [
          TableCell(
            child: Container(
              margin: EdgeInsets.only(left: 20.0 * padding),
              padding: EdgeInsets.symmetric(
                vertical: sizeConfig.width(.0275),
              ),
              child: Text(
                key,
                style: Theme.of(context).textTheme.caption.copyWith(
                      fontSize: Theme.of(context).textTheme.body1.fontSize,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
          ),
          TableCell(
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: sizeConfig.width(.0275),
              ),
              child: value is bool
                  ? Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        value == true ? Icons.check : Icons.clear,
                        color: value == true ? Colors.green : null,
                        size: 18,
                      ),
                    )
                  : value is Map
                      ? Align(
                          alignment: Alignment.centerRight,
                          child: Text(""),
                        )
                      : Text(
                          value != null ? value.toString() : "?",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: value != null
                                ? null
                                : Theme.of(context).textTheme.caption.color,
                          ),
                          textAlign: TextAlign.end,
                        ),
            ),
          ),
        ],
      );
}
