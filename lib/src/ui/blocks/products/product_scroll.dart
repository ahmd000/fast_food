import 'package:app/src/ui/blocks/products/wishlist_icon.dart';

import 'product_ratting.dart';
import './../../../ui/products/products/variation_product_add_to_cart.dart';
import './../../../models/blocks_model.dart';
import './../../../ui/blocks/banners/banner_title.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../functions.dart';
import './../../../models/product_model.dart';
import '../banners/on_click.dart';

class ProductCardScroll extends StatefulWidget {
  final List<Product> products;
  final Block block;
  const ProductCardScroll({Key? key, required this.products, required this.block}) : super(key: key);
  @override
  _ProductCardScrollState createState() => _ProductCardScrollState();
}

class _ProductCardScrollState extends State<ProductCardScroll> {
  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);
    final TextStyle style = theme.textTheme.bodyText2!;
    final Color captionColor = theme.textTheme.caption!.color!;
    TextStyle subtitleTextStyle =
    style.copyWith(color: captionColor, fontSize: 12.0);

    //final tileTheme = ListTileTheme.of(context);
    //final Color color = tileTheme.textColor!;
    TextStyle titleStyle = Theme.of(context).textTheme.bodyText2!;
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
                  height: widget.block.childHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      Widget title = Text(parseHtmlString(widget.products[index].name), maxLines: 2, style: titleStyle);

                      double marginLast = (index + 1) == widget.block.children.length ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;
                      double marginFirst = index == 0 ? widget.block.mainAxisSpacing : widget.block.mainAxisSpacing / 2;


                      final Widget titleText = AnimatedDefaultTextStyle(
                        style: titleStyle,
                        duration: kThemeChangeDuration,
                        maxLines: 2,
                        child: title,
                      );
                      return Container(
                        width: widget.block.childWidth,
                        child: Card(
                          elevation: widget.block.elevation,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(widget.block.borderRadius),
                          ),
                          clipBehavior: Clip.antiAlias,
                          margin: EdgeInsets.fromLTRB(marginFirst, mainAxisSpacingTop, marginLast, widget.block.mainAxisSpacing),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  onProductClick(widget.products[index], context);
                                },
                                child: Stack(
                                  children: [
                                    Container(
                                      height: 160,
                                      width: double.infinity,
                                      child: CachedNetworkImage(
                                        imageUrl: widget.products[index].images[0].src,
                                        placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                                        errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    WishListIconPositioned(id: widget.products[index].id)
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8),
                                    titleText,
                                    /*widget.products[index].description.isNotEmpty ? Column(
                                      children: [
                                        SizedBox(height: 4),
                                        Text(parseHtmlString(widget.products[index].description),
                                            maxLines: 1,
                                            style: subtitleTextStyle),
                                      ],
                                    ) : Container(),*/
                                    SizedBox(height: 4),
                                    ProductRating(ratingCount: widget.products[index].ratingCount, averageRating: widget.products[index].averageRating),
                                    VariationProductAddToCart(product: widget.products[index])
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    itemCount: widget.products.length,
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

