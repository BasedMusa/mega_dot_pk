import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/globals.dart';

class BrandedTable extends StatefulWidget {
  final Map<String, dynamic> specs;
  final String searchQuery;

  BrandedTable(this.specs, {this.searchQuery});

  @override
  _BrandedTableState createState() => _BrandedTableState();
}

class _BrandedTableState extends State<BrandedTable> {
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
      } else if (widget.searchQuery == null ||
          key.toLowerCase().contains(widget.searchQuery.toLowerCase()))
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
                      fontSize: Theme.of(context).textTheme.bodyText2.fontSize,
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
