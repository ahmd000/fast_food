import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:app/grocery_ui/products/add_to_cart.dart';
import 'package:app/grocery_ui/products/price_widget.dart';
import 'package:app/grocery_ui/products/product_detail.dart';
import 'package:app/grocery_ui/widgets/multipath_clipper.dart';
import 'package:app/src/functions.dart';
import 'package:app/src/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SingleProduct extends StatefulWidget {
  final Product product;
  SingleProduct({
    Key? key, required this.product,
  }) : super(key: key);

  @override
  State<SingleProduct> createState() => _SingleProductState();
}

class _SingleProductState extends State<SingleProduct> {
  int percentOff = 0;
  AvailableVariation? _selectedVariation;

  @override
  void initState() {
    if(widget.product.availableVariations.length > 0) {
      _selectedVariation = widget.product.availableVariations.first;
    }
    if (widget.product.salePrice != 0) {
      percentOff = (((widget.product.regularPrice - widget.product.salePrice) / widget.product.regularPrice) * 100).round();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: SizedBox(
        width: 100.0,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        GroceryProductDetail(product: widget.product)));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Card(
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(imageUrl: widget.product.images[0].src,
                          fit: BoxFit.cover),
                    ),
                  ),
                  percentOff != 0 ? Positioned(
                    right: 0,
                    child: ClipPath(
                      clipper: MultiplePointedEdgeClipper(),
                      child: Container(
                        height: 40.0,
                        width: 30.0,
                        color: Theme.of(context).colorScheme.secondary,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Center(child: Text(percentOff.toString() + '% OFF', textAlign:TextAlign.center, style: Theme.of(context).textTheme.labelSmall!.copyWith(color: Theme.of(context).colorScheme.onSecondary),)),
                        ),
                      ),
                    ),
                  ) : Positioned(
                      right: 0, child: Container()),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: AddToCartButton(product: widget.product, variation: _selectedVariation)
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                widget.product.name,
                style: Theme.of(context).textTheme.titleSmall,
                maxLines: 1,
              ),
              Text(
                parseHtmlString(widget.product.shortDescription),
                style: Theme.of(context).textTheme.caption,
                maxLines: 1,
              ),
              PriceWidget(product: widget.product),
            ],
          ),
        ),
      ),
    );
  }
}