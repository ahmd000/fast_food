import 'package:app/grocery_ui/bloc/product_scroll_bloc.dart';
import 'package:app/grocery_ui/products/product.dart';
import 'package:app/grocery_ui/widgets/block_title.dart';
import 'package:app/src/functions.dart';
import 'package:app/src/models/category_model.dart';
import 'package:app/src/models/product_model.dart';
import 'package:app/src/ui/products/products/products.dart';
import 'package:flutter/material.dart';

class CategoryProductScroll extends StatefulWidget {
  final Category category;
  final ProductsBloc productsBloc = ProductsBloc();
  CategoryProductScroll({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryProductScrollState createState() => _CategoryProductScrollState();
}

class _CategoryProductScrollState extends State<CategoryProductScroll> {

  @override
  void initState() {
    widget.productsBloc.fetchAllProducts(widget.category.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(0.0),
      sliver: SliverToBoxAdapter(
        child: GestureDetector(
          onTap: () {},
          child: StreamBuilder(
              stream: widget.productsBloc.allProducts,
              builder: (context, AsyncSnapshot<List<Product>> snapshot) {
              return snapshot.hasData && snapshot.data != null && snapshot.data!.length > 5 ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Container(
                  child: Column(
                    children: [
                      BlockTitle(
                        title: parseHtmlString(widget.category.name), subtitle: widget.category.description,
                        onTapViewAll: () {
                          var filter = new Map<String, dynamic>();
                          filter['id'] = widget.category.id.toString();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProductsWidget(filter: filter, name: widget.category.name)));
                        },
                      ),
                      Container(
                        height: 220.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.all(16),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return SingleProduct(product: snapshot.data![index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ) : Container();
            }
          ),
        ),
      ),
    );
  }
}

