import 'dart:ui';
import 'package:app/grocery_ui/widgets/block_title.dart';
import 'package:app/grocery_ui/widgets/page_with_cart.dart';
import 'package:app/src/functions.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/ui/blocks/banners/on_click.dart';
import 'package:app/src/ui/categories/categories4.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

class Categories11 extends StatefulWidget {
  const Categories11({Key? key}) : super(key: key);

  @override
  _Categories11State createState() => _Categories11State();
}

class _Categories11State extends State<Categories11> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).brightness == Brightness.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: Scaffold(
        body: PageWithCart(
          child: SafeArea(
            child: ListView(
              padding: EdgeInsets.only(bottom: 34),
              children: [
                BlockTitle(
                  title: 'all categories', subtitle: 'curated with the best range of products',
                  onTapViewAll: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Categories4()));
                  },
                ),
                ScopedModelDescendant<AppStateModel>(
                    builder: (context, child, model) {
                    return GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 0.7
                        ),
                        itemCount: model.blocks.categories.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              onCategoryClick(model.blocks.categories[index], context);
                            },
                            child: Column(
                              children: [
                                Container(
                                  height: 80,
                                  child: Card(
                                    elevation: 0.5,
                                    child: CachedNetworkImage(imageUrl: model.blocks.categories[index].image, fit: BoxFit.cover,),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(parseHtmlString(model.blocks.categories[index].name), maxLines: 2, style: Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ), textAlign: TextAlign.center,),
                                ),
                              ],
                            ),
                          );
                        }
                    );
                  }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}