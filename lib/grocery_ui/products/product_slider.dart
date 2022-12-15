import 'package:app/grocery_ui/products/product.dart';
import 'package:app/grocery_ui/widgets/block_title.dart';
import 'package:app/src/models/product_model.dart';
import 'package:app/src/ui/products/products/products.dart';
import 'package:flutter/material.dart';

class GroceryProductScroll extends StatefulWidget {
  final String title;
  final String? description;
  final List<Product> products;
  const GroceryProductScroll({Key? key, required this.title, this.description, required this.products}) : super(key: key);

  @override
  _GroceryProductScrollState createState() => _GroceryProductScrollState();
}

class _GroceryProductScrollState extends State<GroceryProductScroll> {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(0.0),
      sliver: SliverToBoxAdapter(
        child: GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              child: Column(
                children: [
                  BlockTitle(
                    title: widget.title, subtitle: widget.description,
                    onTapViewAll: () {
                      var filter = new Map<String, dynamic>();
                      //TODO Replace 0 with first product category id
                      filter['id'] = '0';
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ProductsWidget(filter: filter)));
                    },
                  ),
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
      ),
    );
  }
}

