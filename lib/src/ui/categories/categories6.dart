import 'dart:ui';

import 'package:app/src/ui/blocks/banners/on_click.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../src/models/app_state_model.dart';
import '../../functions.dart';
import '../../models/category_model.dart';
import '../products/products/products.dart';

class Categories6 extends StatefulWidget {
  @override
  _Categories6State createState() => _Categories6State();
}

class _Categories6State extends State<Categories6> {
  late List<Category> mainCategories;
  late List<Category> subCategories;
  late Category selectedCategory;
  int mainCategoryId = 0;
  int selectedCategoryIndex = 0;
  AppStateModel appStateModel = AppStateModel();

  void onCategoryTap(Category category, BuildContext context) {
    onCategoryClick(selectedCategory, context);
    /*var filter = new Map<String, dynamic>();
    filter['id'] = category.id.toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProductsWidget(filter: filter, name: category.name)));*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appStateModel.blocks.localeText.categories),
      ),
      body: ScopedModelDescendant<AppStateModel>(
        builder: (context, child, model) {
          if (model.blocks.categories.length > 0) {
            mainCategories = model.blocks.categories
                .where((cat) => cat.parent == 0)
                .toList();
            if(mainCategories.length > 0) {
              selectedCategory = mainCategories[selectedCategoryIndex];
              subCategories = model.blocks.categories.where((cat) => cat.parent == selectedCategory.id).toList();
            }

            return buildList();
          }
          return Scaffold(
              appBar: AppBar(title: Text(appStateModel.blocks.localeText.categories),),
              body: Center(child: CircularProgressIndicator()));
        },
      ),
    );
  }

  buildList() {
    return Container(
      padding: EdgeInsets.all(0.0),
      child: ListView.builder(
          itemCount: mainCategories.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Column(
              children: <Widget>[
                CategoryRow(
                    category: mainCategories[index],
                    onCategoryTap: onCategoryTap),
                Divider(
                  height: 0,
                )
              ],
            );
          }),
    );
  }
}

class CategoryRow extends StatelessWidget {
  final Category category;
  final void Function(Category category, BuildContext context) onCategoryTap;

  CategoryRow({required this.category, required this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    Widget featuredImage = category.image != null
        ? CachedNetworkImage(
            imageUrl: category.image,
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
            placeholder: (context, url) => Container(color: Colors.black12),
            errorWidget: (context, url, error) =>
                Container(color: Colors.white),
          )
        : Container();
    return Card(
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      child: InkWell(
        onTap: () => _detail(category, context),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: [
                Container(
                  height: 170,
                  child: featuredImage,
                ),
                Container(
                  height: 170,
                  child: new BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                    child: new Container(
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                            colors: [Colors.black54, Colors.black38],
                            begin: Alignment.bottomCenter,
                            end: new Alignment(0.0, 0.0),
                            tileMode: TileMode.clamp),
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 170,
                  child: Center(
                    child: new Text(parseHtmlString(category.name),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            color: Colors.white)),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  _detail(Category category, BuildContext context) {
    onCategoryClick(category, context);
    /*var filter = new Map<String, dynamic>();
    filter['id'] = category.id.toString();
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ProductsWidget(filter: filter, name: category.name)));*/
  }
}
