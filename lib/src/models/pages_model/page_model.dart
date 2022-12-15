// To parse this JSON data, do
//
//     final pageModel = pageModelFromJson(jsonString);
import 'package:app/src/models/blocks_model.dart';
import 'package:app/src/models/theme/hex_color.dart';
import 'package:app/src/themes/theme.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

List<PageModel> pageModelFromJson(String str) => List<PageModel>.from(json.decode(str).map((x) => PageModel.fromJson(x)));

class PageModel {

  PageModel({
    required this.id,
    required this.title,
    required this.description,
    required this.blocks,
    required this.lightThemeData,
    required this.darkThemeData,
    required this.floatingAction,
    required this.actions,
    this.blockTheme,
    this.backgroundImage,
    this.backgroundVideo,
    required this.customAppBarModel

  });

  int id;
  String title;
  String description;
  List<Block> blocks;
  PageThemeData lightThemeData;
  PageThemeData darkThemeData;
  Child? floatingAction;
  List<Child> actions;
  BlockThemes? blockTheme = BlockThemes.fromJson({});
  String? backgroundImage;
  String? backgroundVideo;
  CustomAppBarModel customAppBarModel;

  factory PageModel.fromJson(Map<String, dynamic> json) => PageModel(
    id: json["id"] == null ? 0 : json["id"],
    title: json["title"] == null ? 'New page' : json["title"],
    description: json["description"] == null ? 'This is a new page, click here to edit' : json["description"],
    blocks: _nullOrEmptyOrFalse(json["blocks"]) ? [] : List<Block>.from(json["blocks"].map((x) => Block.fromJson(x))),
    lightThemeData: json["lightThemeData"] == null ? PageThemeData.fromJson({}) : PageThemeData.fromJson(json["lightThemeData"]),
    darkThemeData: json["darkThemeData"] == null ? PageThemeData.fromJson({}) : PageThemeData.fromJson(json["darkThemeData"]),
    floatingAction: json["floatingAction"] == null ? null : Child.fromJson(json["floatingAction"]),
    actions: json["actions"] == null ? [] : List<Child>.from(json["actions"].map((x) => Child.fromJson(x))),
    blockTheme: _nullOrEmptyOrFalse(json["blockTheme"]) ? BlockThemes.fromJson({}) : BlockThemes.fromJson(json["blockTheme"]),
    backgroundImage: json["backgroundImage"] == null || json["backgroundImage"] == '' ? null : json["backgroundImage"],
    backgroundVideo: json["backgroundVideo"] == null || json["backgroundVideo"] == '' ? null : json["backgroundVideo"],
    customAppBarModel: json["customAppBarModel"] == null ? CustomAppBarModel.fromJson({}) : CustomAppBarModel.fromJson(json["customAppBarModel"]),
  );
}

class PageThemeData {
  PageThemeData({
    this.backgroundColor,
    required this.appBarBackgroundColor,
    required this.floatingActionBackgroundColor,
    required this.floatingActionIconColor,
    required this.appBarIconColor,
    required this.appBarBrightness,
  });

  Color? backgroundColor;
  Color? appBarBackgroundColor;
  Color? floatingActionBackgroundColor;
  Color? floatingActionIconColor;
  Color? appBarIconColor;
  Brightness appBarBrightness;

  factory PageThemeData.fromJson(Map<String, dynamic> json) => PageThemeData(
    backgroundColor: json["backgroundColor"] == null ? null : HexColor(json["backgroundColor"]),
    appBarBackgroundColor: json["appBarBackgroundColor"] == null ? null : HexColor(json["appBarBackgroundColor"]),
    floatingActionBackgroundColor: json["floatingActionBackgroundColor"] == null ? null : HexColor(json["floatingActionBackgroundColor"]),
    floatingActionIconColor: json["floatingActionIconColor"] == null ? null : HexColor(json["floatingActionIconColor"]),
    appBarIconColor: json["appBarIconColor"] == null ? null : HexColor(json["appBarIconColor"]),
    appBarBrightness: json["appBarBrightness"] == null ? Brightness.light : json["appBarBrightness"] == 'Brightness.dark' ? Brightness.dark: Brightness.light,
  );
}

class CustomAppBarModel {
  CustomAppBarModel({
    required this.pin,
    required this.snap,
    required this.floating,
    required this.stretch,
    this.height,
    this.title,
    this.backgroundImage,
    this.backgroundVideo
  });

  bool pin;
  bool snap;
  bool floating;
  bool stretch;
  double? height;
  String? title;
  String? backgroundImage;
  String? backgroundVideo;

  factory CustomAppBarModel.fromJson(Map<String, dynamic> json) => CustomAppBarModel(
    pin: json["pin"] == true ? true : false,
    snap: json["snap"] == true ? true : false,
    floating: json["floating"] == true ? true : false,
    stretch: json["stretch"] == true ? true : false,
    height: json["height"] == null ? null : double.parse(json["height"].toString()),
    title: json["title"] == null ? null : json["title"],
    backgroundImage: json["backgroundImage"] == null || json["backgroundImage"] == '' ? null : json["backgroundImage"],
    backgroundVideo: json["backgroundVideo"] == null || json["backgroundVideo"] == '' ? null : json["backgroundVideo"],
  );
}

_nullOrEmptyOrFalse(json) {
  if(json == null || json == '' || json == false) {
    return true;
  } else return false;
}