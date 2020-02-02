import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/globals.dart';
import 'package:mega_dot_pk/widgets/branded_table.dart';
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
                    labelText: "Search through specs...",
                    hintText: "Processor...",
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
      child: BrandedTable(specs, searchQuery: _searchQuery),
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sizeConfig.width(.05),
      ),
      child: specsTable,
    );
  }
}
