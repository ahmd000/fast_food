import 'package:app/grocery_ui/cart/cart.dart';
import 'package:app/src/functions.dart';
import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class PageWithCart extends StatelessWidget {
  final Widget child;
  const PageWithCart({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Stack(
      fit: StackFit.expand,
      children: [
        child,
        context.watch<ShoppingCart>().cart.cartContents.length > 0 ? Positioned(
          left: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.all(5.0),
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black.withOpacity(0.5) : Colors.white.withOpacity(0.5),
            height: 64,
            width: size.width,
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            CartPage()));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0),
                ),
                color: Colors.green.shade800,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.basketShopping, color: Colors.white, size: 22),
                            SizedBox(width: 8),
                            Text(' '+context.watch<ShoppingCart>().cart.cartContents.length.toString()+' items. ', style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                color: Colors.white
                            )),
                            Text(parseHtmlString(context.watch<ShoppingCart>().cart.cartTotals.total), style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                color: Colors.white
                            )),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('view cart', style: Theme.of(context).textTheme.bodyText2!.copyWith(
                                color: Colors.white
                            )),
                            Icon(CupertinoIcons.right_chevron, color: Colors.white, size: 16)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ) : Positioned(
            left: 0,
            bottom: 0,
            child: Container())
      ],
    );
  }
}