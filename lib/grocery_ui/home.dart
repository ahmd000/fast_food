import 'package:app/grocery_ui/blocks/blocks.dart';
import 'package:app/grocery_ui/products/product.dart';
import 'package:app/grocery_ui/search.dart';
import 'package:app/grocery_ui/widgets/multipath_clipper.dart';
import 'package:app/grocery_ui/widgets/page_with_cart.dart';
import 'package:app/src/blocs/products_bloc.dart';
import 'package:app/src/config.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/product_model.dart';
import 'package:app/src/ui/blocks/header_logo.dart';
import 'package:app/src/ui/blocks/place_selector.dart';
import 'package:app/src/ui/home/place_picker.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';

class GroceryHome extends StatefulWidget {
  final ProductsBloc productsBloc = ProductsBloc();
  GroceryHome({Key? key}) : super(key: key);

  @override
  _GroceryHomeState createState() => _GroceryHomeState();
}

class _GroceryHomeState extends State<GroceryHome> with SingleTickerProviderStateMixin {

  ScrollController _scrollController = new ScrollController();
  AppStateModel appStateModel = AppStateModel();
  
  @override
  void initState() {
    super.initState();
    widget.productsBloc.productsFilter['id'] = '0';
    widget.productsBloc.fetchAllProducts('0');
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        widget.productsBloc.loadMore('0');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).colorScheme.secondary.isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: ScopedModelDescendant<AppStateModel>(
          builder: (context, child, model) {
          return Scaffold(
              body: PageWithCart(
                child: CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    sliverAppBarLogo(context),
                    if(model.blocks.settings.geoLocation)
                      sliverAppBarLocation(context),
                      sliverAppBarSearch(context),
                    for (var i = 0; i < model.blocks.blocks.length; i++)
                      SliverBlock(block: model.blocks.blocks[i]),
                    StreamBuilder(
                        stream: widget.productsBloc.allProducts,
                        builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            if (snapshot.data!.length != 0) {
                              return SliverGrid(
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
                                            child: SingleProduct(product: snapshot.data![index])
                                        ),
                                      );
                                    },
                                    childCount: snapshot.data!.length,
                                  ));
                            }
                          } else if (snapshot.hasError) {
                            return SliverFillRemaining(child: Text(snapshot.error.toString()));
                          } return SliverToBoxAdapter(child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(child: Container()),
                          ));
                        }),
                    SliverToBoxAdapter(child: SizedBox(height: 38),)
                  ],
                ),
              ));
        }
      ),
    );
  }

  onTapAddress() async {
    if(appStateModel.blocks.settings.customLocation) {
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PlaceSelector();
      }));
    } else {
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return PlacePickerHome();
      }));
      setState(() {});
      /*widget.model.getAllStores();*/
      await appStateModel.updateAllBlocks();
      setState(() {});
    }
  }

  SliverAppBar sliverAppBarLogo(BuildContext context) {
    return SliverAppBar(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).colorScheme.secondary.isDark ? Brightness.dark : Brightness.light,
      ),
      primary: true,
      title: appStateModel.blocks.settings.appBarStyle.logo ? HeaderLogo() : Center(
        child: Text(Config().appName,
            style: TextStyle(
                color: Theme.of(context).colorScheme.secondary.isDark ? Colors.white : Colors.black,
                fontSize: 22.0,
                fontWeight: FontWeight.bold)),
      ),
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: ClipPath(
          clipper: MultiplePointedEdgeClipper(),
          child: Container(
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ),
    );
  }

  SliverAppBar sliverAppBarLocation(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 40.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      automaticallyImplyLeading: true,
      titleSpacing: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: ListTile(
              title: Text(appStateModel.blocks.localeText.deliveryIn10Minutes, style: Theme.of(context).textTheme.headline6),
              subtitle: Row(
                children: [
                  //Text('Prestige Tranquility, Bangalore 560048'),
                  InkWell(
                    onTap: () async {
                      onTapAddress();
                    },
                    child: ScopedModelDescendant<AppStateModel>(
                        builder: (context, child, model) {
                          return model.blocks.settings.geoLocation ? Row(
                            children: [
                              Container(
                                //width: MediaQuery.of(context).size.width - 110,
                                  child: model.customerLocation['address'] != null ? Text(model.customerLocation['address'], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(
                                      fontSize: 14
                                  )) : Text(model.blocks.localeText.selectLocation, style: TextStyle(
                                      fontSize: 14
                                  ))
                              ),
                            ],
                          ) : Container();
                        }
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(CupertinoIcons.arrow_right, size: 14, color: Theme.of(context).disabledColor)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverAppBar sliverAppBarSearch(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 70.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      forceElevated: true,
      snap: false,
      pinned: true,
      floating: false,
      elevation: 0.0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        centerTitle: true,
        title: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Search()));
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withOpacity(0.05),
                  spreadRadius: 7,
                  blurRadius: 7,
                  offset: Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: CupertinoTextField(
              enabled: false,
              keyboardType: TextInputType.text,
              placeholder: appStateModel.blocks.localeText.searchFor,
              prefix: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 5.0, 0.0, 5.0),
                child: Icon(
                  CupertinoIcons.search,
                  color: Theme.of(context).disabledColor,
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                //color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

}

