import 'package:app/grocery_ui/products/product.dart';
import '../../src/models/blocks_model.dart';
import '../../src/ui/blocks/banners/banner_title.dart';
import 'package:flutter/material.dart';
import '../../src/models/product_model.dart';

class ProductScroll extends StatefulWidget {
  final List<Product> products;
  final Block block;
  const ProductScroll({Key? key, required this.products, required this.block}) : super(key: key);
  @override
  _ProductScrollState createState() => _ProductScrollState();
}

class _ProductScrollState extends State<ProductScroll> {
  @override
  Widget build(BuildContext context) {

    bool isDark = Theme.of(context).brightness == Brightness.dark;

    double padding = widget.block.mainAxisSpacing == 0 ? 16 : widget.block.mainAxisSpacing;

    double mainAxisSpacingTop = widget.block.mainAxisSpacing;
    if(widget.block.headerAlign != 'none') {
      mainAxisSpacingTop = 0;
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(widget.block.blockMargin.left, widget.block.blockMargin.top, widget.block.blockMargin.right, widget.block.blockMargin.bottom),
      sliver: SliverToBoxAdapter(
        child: Card(
          elevation: 0,
          color: isDark ? Colors.transparent : widget.block.backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.all(0),
          child: Padding(
            padding: EdgeInsets.fromLTRB(widget.block.blockPadding.left, widget.block.blockPadding.top, widget.block.blockPadding.right, widget.block.blockPadding.bottom),
            child: Column(
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(padding, 0, padding, 0),
                    child: BannerTitle(block: widget.block)),
                Container(
                  height: 220.0,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.all(16),
                    itemCount: widget.products.length,
                    itemBuilder: (context, index) {
                      return SingleProduct(product: widget.products[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

