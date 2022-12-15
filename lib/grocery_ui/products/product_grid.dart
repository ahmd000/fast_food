import 'package:app/grocery_ui/products/product.dart';
import 'package:app/src/models/product_model.dart';
import 'package:flutter/material.dart';

class GroceryProductGrid extends StatelessWidget {
  final List<Product> products;
  const GroceryProductGrid({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(4.0),
      sliver: SliverGrid(
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              childAspectRatio: 0.65
          ),
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return Center(
                child: SizedBox(
                    width: 108,
                    child: SingleProduct(product: products[index])
                ),
              );
            },
            childCount: products.length,
          )),
    );
  }
}
