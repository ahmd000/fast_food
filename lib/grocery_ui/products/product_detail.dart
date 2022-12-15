import 'package:app/grocery_ui/blocks/blocks.dart';
import 'package:app/grocery_ui/blocks/category_product_scroll.dart';
import 'package:app/grocery_ui/products/add_to_cart.dart';
import 'package:app/grocery_ui/products/price_widget.dart';
import 'package:app/grocery_ui/products/product_slider.dart';
import 'package:app/grocery_ui/search.dart';
import 'package:app/grocery_ui/widgets/multipath_clipper.dart';
import 'package:app/grocery_ui/widgets/page_with_cart.dart';
import 'package:app/src/blocs/product_detail_bloc.dart';
import 'package:app/src/config.dart';
import 'package:app/src/functions.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/category_model.dart';
import 'package:app/src/models/product_model.dart';
import 'package:app/src/models/releated_products.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GroceryProductDetail extends StatefulWidget {
  final Product product;
  final ProductDetailBloc productDetailBloc = ProductDetailBloc();
  GroceryProductDetail({Key? key, required this.product}) : super(key: key);

  @override
  State<GroceryProductDetail> createState() => _GroceryProductDetailState();
}

class _GroceryProductDetailState extends State<GroceryProductDetail> {

  int percentOff = 0;
  AvailableVariation? _selectedVariation;
  final appStateModel = AppStateModel();
  List<Category> categories = [];
  ScrollController _scrollController = new ScrollController();
  int _toCount = 5;

  @override
  void initState() {
    widget.productDetailBloc.getProduct(widget.product);
    widget.productDetailBloc.product.listen((event) => _process(event));
    widget.productDetailBloc.getProductsDetails(widget.product.id);

    //ADDED this in product stream add event
    /*if(widget.product.availableVariations.length > 0) {
      _selectedVariation = widget.product.availableVariations.first;
    }
    if (widget.product.salePrice != 0) {
      percentOff = (((widget.product.regularPrice - widget.product.salePrice) / widget.product.regularPrice) * 100).round();
    }*/

    categories = appStateModel.blocks.categories..shuffle();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if(_toCount < categories.length) {
          _toCount = _toCount + 5;
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Product>(
        stream: widget.productDetailBloc.product,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Search()));
                  }, icon: Icon(CupertinoIcons.search)),
                  IconButton(
                      icon: Icon(
                        CupertinoIcons.share,
                        semanticLabel: 'Share',
                      ),
                      onPressed: () async {
                        if(appStateModel.blocks.settings.dynamicLink.isNotEmpty) {
                          String wwref =  '?wwref=' + appStateModel.user.id.toString();
                          final url = Uri.parse(snapshot.data!.permalink + '?product_id=' + snapshot.data!.id.toString() + '&title=' + snapshot.data!.name + wwref);
                          final DynamicLinkParameters parameters = DynamicLinkParameters(
                            uriPrefix: appStateModel.blocks.settings.dynamicLink,
                            link: url,
                            socialMetaTagParameters:  SocialMetaTagParameters(
                              title: snapshot.data!.name,
                              //description: product.name,
                            ),
                            androidParameters: AndroidParameters(
                              packageName: Config().androidPackageName,
                              minimumVersion: 0,
                            ),
                            iosParameters: IOSParameters(
                              bundleId: Config().iosPackageName,
                            ),
                          );

                          final dynamicLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
                          Share.share(dynamicLink.shortUrl.toString());

                        } else Share.share(snapshot.data!.permalink);
                      }),
                ],
              ),
              body: SafeArea(
                child: PageWithCart(
                  child: CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: Stack(
                          children: [
                            CachedNetworkImage(imageUrl: snapshot.data!.images[0].src,
                                fit: BoxFit.cover),
                            percentOff != 0 ? Positioned(
                              right: 0,
                              child: ClipPath(
                                clipper: MultiplePointedEdgeClipper(),
                                child: Container(
                                  height: 60.0,
                                  width: 50.0,
                                  color: Theme.of(context).colorScheme.secondary,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Center(child: Text(percentOff.toString() + '%  OFF', textAlign:TextAlign.center, style: Theme.of(context).textTheme.labelLarge!.copyWith(color: Theme.of(context).colorScheme.onSecondary),)),
                                  ),
                                ),
                              ),
                            ) : Positioned(
                                right: 0, child: Container()),
                          ],
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.name,
                                style: Theme.of(context).textTheme.subtitle2,
                                maxLines: 2,
                              ),
                              SizedBox(height: 4),
                              Text(
                                parseHtmlString(snapshot.data!.shortDescription),
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  PriceWidget(product: snapshot.data!),
                                  AddToCartButton(product: snapshot.data!, variation: _selectedVariation),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      StreamBuilder<RelatedProductsModel>(
                          stream: widget.productDetailBloc.relatedProducts,
                          builder: (context, AsyncSnapshot<RelatedProductsModel> snapshot) {
                            if (snapshot.hasData && snapshot.data != null && snapshot.data!.relatedProducts.length > 0) {
                              return GroceryProductScroll(products: snapshot.data!.relatedProducts, title: 'Related Products',);
                            } else {
                              return SliverToBoxAdapter();
                            }
                          }),
                      StreamBuilder<RelatedProductsModel>(
                          stream: widget.productDetailBloc.relatedProducts,
                          builder: (context, AsyncSnapshot<RelatedProductsModel> snapshot) {
                            if (snapshot.hasData && snapshot.data != null && snapshot.data!.crossProducts.length > 0) {
                              return GroceryProductScroll(products: snapshot.data!.crossProducts, title: 'Related Products',);
                            } else {
                              return SliverToBoxAdapter();
                            }
                          }),
                      StreamBuilder<RelatedProductsModel>(
                          stream: widget.productDetailBloc.relatedProducts,
                          builder: (context, AsyncSnapshot<RelatedProductsModel> snapshot) {
                            if (snapshot.hasData && snapshot.data != null && snapshot.data!.upsellProducts.length > 0) {
                              return GroceryProductScroll(products: snapshot.data!.upsellProducts, title: 'Related Products',);
                            } else {
                              return SliverToBoxAdapter();
                            }
                          }),
                    if(appStateModel.blocks.productPageLayout.length > 0)
                      for (var i = 0; i < appStateModel.blocks.productPageLayout.length; i++)
                        SliverBlock(block: appStateModel.blocks.productPageLayout[i]),
                      for(var category in categories.sublist(1, _toCount))
                        CategoryProductScroll(category: category),
                      SliverToBoxAdapter(
                        child: SizedBox(height: 80),
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(appBar: AppBar(), body: Center(child: CircularProgressIndicator()));
          }
        }
    );
  }

  _process(Product event) {
    if(event.availableVariations.length > 0) {
      _selectedVariation = event.availableVariations.first;
    }
    if (event.salePrice != 0) {
      percentOff = (((event.regularPrice - event.salePrice) / event.regularPrice) * 100).round();
    }
    setState(() {});
  }
}
