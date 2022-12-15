import 'package:app/src/models/pages_model/page_model.dart';
import 'package:app/src/resources/get_icon.dart';
import 'package:app/src/ui/blocks/app_pages/video_player.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class CustomAppBar extends StatefulWidget {
  final PageModel page;
  const CustomAppBar({Key? key, required this.page}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {

    PageThemeData pageThemeData = Theme.of(context).brightness == Brightness.light ?  widget.page.lightThemeData : widget.page.darkThemeData;
    bool brightness = Theme.of(context).brightness == Brightness.dark;

    return SliverAppBar(

      stretch: widget.page.customAppBarModel.stretch,
      snap: widget.page.customAppBarModel.snap,
      pinned: widget.page.customAppBarModel.pin,
      floating: widget.page.customAppBarModel.snap == true ? true : widget.page.customAppBarModel.floating,
      expandedHeight: widget.page.customAppBarModel.height,
      flexibleSpace: FlexibleSpaceBar(
        title: widget.page.customAppBarModel.title != null ? Text(widget.page.customAppBarModel.title!) : null,
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            if(widget.page.customAppBarModel.backgroundImage != null)
            Image.network(
              widget.page.customAppBarModel.backgroundImage!,
              fit: BoxFit.cover,
            ),
            if(widget.page.customAppBarModel.backgroundVideo != null)
            VideoPLayerWidget(link: widget.page.customAppBarModel.backgroundVideo!)
          ],
        ),
      ),

      leading: Navigator.of(context).canPop() ? IconButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        icon: Icon(Icons.arrow_back_ios, color: pageThemeData.appBarIconColor),
      ) : null,
      backgroundColor: widget.page.backgroundImage != null || widget.page.backgroundVideo != null ? Colors.transparent : pageThemeData.appBarBackgroundColor,
      systemOverlayStyle: pageThemeData.appBarBackgroundColor != null ? SystemUiOverlayStyle(
          statusBarBrightness: pageThemeData.appBarBackgroundColor!.isDark ? Brightness.dark : Brightness.light
      ) : null,
      actions: [
        for (var i = 0; i < widget.page.actions.length; i++)
          IconButton(onPressed: () {

          }, icon: getIcon(widget.page.actions[i].leading, color: pageThemeData.appBarIconColor))
      ],
    );
  }
}
