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
        child: Column(
          children: List<Widget>.generate(
            widget.specs.keys.length,
            (i) => _generateTable(widget.specs.values.toList()[i]),
          ),
        ),
      ));

  _generateTable(Map specs) {
    Widget specsTable = Container(
      margin: EdgeInsets.symmetric(
        vertical: sizeConfig.height(.0125),
      ),
      padding: EdgeInsets.only(
        bottom: sizeConfig.height(.015),
      ),
      child: Table(
        children: List.generate(
          specs.keys.length,
          (i) => TableRow(
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
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: sizeConfig.width(.0275),
                  ),
                  child: Text(
                    specs.keys.toList()[i],
                    style: Theme.of(context).textTheme.caption.copyWith(
                          fontSize: Theme.of(context).textTheme.body1.fontSize,
                        ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: sizeConfig.width(.0275),
                  ),
                  child: Text(
                    specs.values.toList()[i] != null
                        ? specs.values.toList()[i].toString()
                        : "?",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: specs.values.toList()[i] != null
                          ? null
                          : Theme.of(context).textTheme.caption.color,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: sizeConfig.width(.05),
          vertical: sizeConfig.height(.01),
        ),
        child: specsTable,
      ),
    );
  }
}
