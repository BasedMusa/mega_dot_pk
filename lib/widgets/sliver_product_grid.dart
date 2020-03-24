import 'package:flutter/material.dart';
import 'package:mega_dot_pk/utils/models.dart';
import 'package:mega_dot_pk/widgets/product_grid_item.dart';

class SliverProductsGrid extends StatefulWidget {
  final List<Product> products;

  SliverProductsGrid(this.products);

  @override
  _SliverProductsGridState createState() => _SliverProductsGridState();
}

class _SliverProductsGridState extends State<SliverProductsGrid> {
  @override
  Widget build(BuildContext context) => SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: .65,
          mainAxisSpacing: 2.5,
          crossAxisSpacing: 2.5,
        ),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) =>
              ProductGridItem(index, widget.products[index]),
          childCount: widget.products.length,
        ),
      );
}
