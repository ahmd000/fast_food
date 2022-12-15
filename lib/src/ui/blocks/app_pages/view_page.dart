import 'package:app/src/blocs/pages_bloc.dart';
import 'package:app/src/resources/get_icon.dart';
import 'package:app/src/ui/blocks/app_pages/custom_appbar.dart';
import 'package:app/src/ui/blocks/app_pages/video_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app/src/models/pages_model/page_model.dart';
import 'package:app/src/ui/blocks/blocks.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ViewPage extends StatefulWidget {
  final String id;
  final PageBloc pageBloc = PageBloc();
  ViewPage({Key? key, required this.id}) : super(key: key);

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {

  @override
  void initState() {
    print(widget.id);
    widget.pageBloc.getPage(widget.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PageModel>(
        stream: widget.pageBloc.allPage,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final page = snapshot.data!;
            return Builder(builder: (context) {
              PageThemeData pageThemeData =
                  Theme.of(context).brightness == Brightness.light
                      ? page.lightThemeData
                      : page.darkThemeData;
              bool brightness = Theme.of(context).brightness == Brightness.dark;

              return PageBackground(
                backgroundColor: pageThemeData.backgroundColor,
                backgroundImage: page.backgroundImage,
                backgroundVideo: page.backgroundVideo,
                child: Scaffold(
                  backgroundColor: page.backgroundImage != null ||
                          page.backgroundVideo != null
                      ? Colors.transparent
                      : pageThemeData.backgroundColor,
                  body: page.blocks.length > 0
                      ? CustomScrollView(slivers: [
                          CustomAppBar(page: page),
                          for (var i = 0; i < page.blocks.length; i++)
                            SliverBlock(block: page.blocks[i]),
                        ] //buildLisOfBlocks(model.blocks),/**///buildLisOfBlocks(model.blocks),
                          )
                      : Container(),
                  floatingActionButton: page.floatingAction != null
                      ? FloatingActionButton(
                          backgroundColor:
                              pageThemeData.floatingActionBackgroundColor,
                          onPressed: () async {},
                          child: getIcon(page.floatingAction!.leading,
                              color: pageThemeData.floatingActionIconColor))
                      : null,
                ),
              );
            });
          } else {
            return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                ));
          }
        });
  }
}

class PageBackground extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  final String? backgroundImage;
  final String? backgroundVideo;
  const PageBackground(
      {Key? key,
      required this.child,
      this.backgroundColor,
      this.backgroundImage,
      this.backgroundVideo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (backgroundImage != null) {
      return Stack(
        children: [
          Scaffold(
              backgroundColor: backgroundColor,
              body: CachedNetworkImage(
                imageUrl: backgroundImage!,
                placeholder: (context, url) =>
                    Container(color: Colors.transparent),
                errorWidget: (context, url, error) =>
                    Container(color: Colors.transparent),
                fit: BoxFit.fitWidth,
              )),
          child,
        ],
      );
    } else if (backgroundVideo != null) {
      return Stack(
        children: [
          Scaffold(
              backgroundColor: backgroundColor,
              body: Container(
                  //height: 400,
                  child: VideoPLayerWidget(link: backgroundVideo!))),
          child,
        ],
      );
    } else {
      return child;
    }
  }
}
