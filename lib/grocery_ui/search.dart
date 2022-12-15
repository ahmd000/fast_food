import 'dart:async';

import 'package:app/grocery_ui/products/product.dart';
import 'package:app/grocery_ui/widgets/sliver_search_bar.dart';
import 'package:app/src/blocs/search_bloc.dart';
import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Search extends StatefulWidget {
  final bool? hideBackButton;
  final Map<String, dynamic>? filter;
  final SearchBloc searchBloc = SearchBloc();
  Search({Key? key, this.hideBackButton, this.filter}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  AppStateModel appStateModel = AppStateModel();

  ScrollController _scrollController = new ScrollController();
  TextEditingController inputController = new TextEditingController();
  Timer? _debounce;
  bool listView = false;

  @override
  void initState() {
    if(_debounce != null) _debounce!.cancel();
    if(widget.filter != null) {
      widget.searchBloc.filter = widget.filter!;
    }
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent && widget.searchBloc.moreItems) {
        widget.searchBloc.loadMoreSearchResults(inputController.text);
      }
    });
    super.initState();
  }


  @override
  void dispose() {
    if(_debounce != null) _debounce!.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    print(inputController.text);
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if(inputController.text.isNotEmpty) {
        widget.searchBloc.fetchSearchResults(inputController.text);
      }
      setState(() {});
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).brightness == Brightness.light ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverSearchBar(
                searchTextController: inputController,
                hideBackButton: widget.hideBackButton,
                onChanged: (value) {_onSearchChanged();},
            ),
            StreamBuilder<bool>(
              stream: widget.searchBloc.searchLoading,
              builder: (context, snapshotLoading) {
                return StreamBuilder<List<Product>>(
                  stream: widget.searchBloc.searchResults,
                  builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                    if(snapshotLoading.hasData && snapshotLoading.data!) {
                      return SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
                    }
                    else if(snapshot.hasData && snapshot.data !=null) {
                      if(snapshot.data!.length != 0) {
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
                                        child: SingleProduct(product: snapshot.data![index])
                                    ),
                                  );
                                },
                                childCount: snapshot.data!.length,
                              )),
                        );
                      } else if(inputController.text.isNotEmpty) return SliverFillRemaining(child: Center(child: Text(appStateModel.blocks.localeText.noResults)));
                      else return appStateModel.blocks.settings.popularSearches.length > 0 ? SliverToBoxAdapter(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 4),
                                child: Text(appStateModel.blocks.localeText.popular, style: Theme.of(context).textTheme.caption),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                                child: Wrap(
                                    children: appStateModel.blocks.settings.popularSearches.map((searches) =>
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                          child: InkWell(
                                            onTap: () {
                                              setState(() {
                                                inputController.text = searches;
                                              });
                                              _onSearchChanged();
                                            },
                                            child: Chip(
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(0.0),
                                              ),
                                              padding: EdgeInsets.all(0),
                                              label: Text(searches),
                                            ),
                                          ),
                                        )
                                    ).toList()
                                ),
                              )
                            ]
                        )) : SliverToBoxAdapter(child: Container());
                    } else {
                      return appStateModel.blocks.settings.popularSearches.length > 0 ? SliverToBoxAdapter(child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16.0, 16, 16, 4),
                              child: Text(appStateModel.blocks.localeText.popularSearches, style: Theme.of(context).textTheme.caption),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                              child: Wrap(
                                  children: appStateModel.blocks.settings.popularSearches.map((searches) =>
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                                        child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              inputController.text = searches;
                                            });
                                            _onSearchChanged();
                                          },
                                          child: Chip(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(0.0),
                                            ),
                                            padding: EdgeInsets.all(0),
                                            label: Text(searches),
                                          ),
                                        ),
                                      )
                                  ).toList()
                              ),
                            )
                          ]
                      )) : SliverToBoxAdapter(child: Container());
                    }
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
