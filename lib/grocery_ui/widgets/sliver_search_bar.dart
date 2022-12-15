import 'package:app/src/models/app_state_model.dart';
import 'package:app/src/ui/products/barcode_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class SliverSearchBar extends StatelessWidget {
  final bool? hideBackButton;
  final TextEditingController searchTextController;
  final Function(String)? onChanged;
  const SliverSearchBar({Key? key, this.hideBackButton, this.onChanged, required this.searchTextController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      toolbarHeight: 80.0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      forceElevated: true,
      snap: false,
      pinned: true,
      floating: false,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.dark : Brightness.light,
      ),
      elevation: 0.0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        centerTitle: true,
        title: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.05),
                spreadRadius: 7,
                blurRadius: 7,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            children: [
              CupertinoTextField(
                keyboardType: TextInputType.text,
                autofocus: true,
                controller: searchTextController,
                onChanged: onChanged,
                style: Theme.of(context).brightness == Brightness.dark ? TextStyle(color: Colors.white) : null,
                placeholder: AppStateModel().blocks.localeText.searchFor,
                suffix: IgnorePointer(
                  ignoring: false,
                  child: IconButton(
                      onPressed: () {
                        _scanBarCode(context);
                      },icon: Icon(CupertinoIcons.barcode_viewfinder, color: Theme.of(context).disabledColor,)
                  ),
                ),
                prefix: hideBackButton == true ? Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 10.0, 0.0, 10.0),
                  child:Icon(CupertinoIcons.search, color: Theme.of(context).disabledColor,),
                ) : GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 10.0, 0.0, 10.0),
                    child:Icon(CupertinoIcons.arrow_left, color: Theme.of(context).iconTheme.color),
                  ),
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6.0),
                  color: Theme.of(context).brightness == Brightness.light ? null : Colors.black,
                ),
              ),
              /*Positioned.directional(
                textDirection: Directionality.of(context),
                end: 0,
                top: -4,
                child:  IgnorePointer(
                  ignoring: false,
                  child: IconButton(
                      onPressed: () {
                        _scanBarCode();
                      },icon: Icon(CupertinoIcons.barcode_viewfinder, color: Theme.of(context).disabledColor,)
                  ),
                ),
              )*/
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _scanBarCode(BuildContext context) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE);
    if(barcodeScanRes != '-1'){
      showDialog(builder: (context) => FindBarCodeProduct(result: barcodeScanRes, context: context), context: context);
    }
  }
}
