import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/globals.dart';

class AllSpecsPage extends StatefulWidget {
  final Map specs;

  AllSpecsPage(this.specs);

  @override
  _AllSpecsPageState createState() => _AllSpecsPageState();
}

class _AllSpecsPageState extends State<AllSpecsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: _appBar(),
        body: _body(),
        backgroundColor: Theme.of(context).canvasColor,
      );

  _appBar() => AppBar(
        elevation: .4,
      );

  _body() => Container(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: sizeConfig.height(.045) + sizeConfig.safeArea.bottom,
          ),
          child: Column(
            children: List<Widget>.generate(
              widget.specs.keys.length,
              (i) => _generateTable(widget.specs.values.toList()[i]),
            ),
          ),
        ),
      );

  _generateTable(Map specs) {
    Widget specsTable = Container(
      margin: EdgeInsets.only(
        top: sizeConfig.height(.035),
      ),
      child: Table(
        children: _generateRows(specs),
      ),
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: sizeConfig.width(.05),
      ),
      child: specsTable,
    );
  }

  List<TableRow> _generateRows(Map<String, dynamic> specs, {int padding = 0}) {
    List<TableRow> _rows = [];

    specs.forEach((String key, dynamic value) {
      if (value is Map) {
        _rows.add(_tableRow(key, value, padding));

        _rows.addAll(_generateRows(value, padding: padding + 1));
      } else
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
