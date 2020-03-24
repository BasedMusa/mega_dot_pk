import 'package:flutter/material.dart';
import 'package:mega_dot_pk/widgets/styled_appbar.dart';

class SearchPage extends StatefulWidget {
  final String searchKeyword;

  SearchPage(this.searchKeyword);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar(),
        body: _body(),
      );

  _appBar() => StyledAppBar("Results \"${widget.searchKeyword}\"");

  _body() => Container();
}
