import 'package:app/grocery_ui/products/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import './../../../models/product_model.dart';
import './../../../models/app_state_model.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({
    Key? key,
    required this.product,
  }) : super(key: key);
  final Product product;
  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          print(model.blocks.settings.pageLayout.product);
          return GroceryProductDetail(product: widget.product);
    });
  }
}
