import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:app/src/ui/blocks/banners/custom_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/src/provider.dart';
import '../../src/ui/widgets/buttons/button_text.dart';
import '../../src/blocs/checkout_form_bloc.dart';
import '../../src/ui/accounts/login/login.dart';
import '../../src/ui/checkout/webview_checkout/webview_checkout.dart';
import '../../src/functions.dart';
import '../../src/models/app_state_model.dart';
import '../../src/models/cart/cart_model.dart';
import '../../src/ui/checkout/checkout_form.dart';
import '../../src/ui/checkout/cart/coupons.dart';

class CartPage extends StatefulWidget {
  final checkoutBloc = CheckoutFormBloc();
  final appStateModel = AppStateModel();
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  bool isLoading = false;
  TextEditingController _couponCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    context.read<ShoppingCart>().getCart();
    widget.checkoutBloc.getCheckoutForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appStateModel.blocks.localeText.cart),
      ),
      body: context.watch<ShoppingCart>().cart.cartContents.length > 0 ? Builder(
        builder: (context) {
          return ListView(
            children: buildCart(context),
          );
        }
      ) : Center(
          child: Icon(
            CupertinoIcons.bag,
            size: 150,
            color: Theme.of(context).focusColor,
          )),
      bottomNavigationBar: context.watch<ShoppingCart>().cart.cartContents.length > 0 ? SafeArea(
        child: Container(
          padding: EdgeInsets.all(5.0),
          height: 64,
          child: InkWell(
            onTap: () async {
              if (widget.appStateModel.blocks.settings.webViewCheckout) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => WebViewCheckout()));
              } else {
                if(widget.appStateModel.blocks.settings.webViewCheckout && widget.appStateModel.user.id == 0) {
                  await Navigator.push(context, MaterialPageRoute(builder: (context) =>
                      Login()
                  ));
                  if(widget.appStateModel.user.id > 0 ) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CheckoutForm(checkoutFormBloc: widget.checkoutBloc)));
                  }
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CheckoutForm(checkoutFormBloc: widget.checkoutBloc)));
                }
              }
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
                          Text('Continue', style: Theme.of(context).textTheme.bodyText2!.copyWith(
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
      ) : Container(
        child: Card(
          margin: EdgeInsets.zero,
        ),
      ),
    );
  }

  buildCart(BuildContext context) {
    List<Widget> list = [];

    if(context.read<ShoppingCart>().cart.points != null) {
      if(context.read<ShoppingCart>().cart.points!.points > 0 && !context.read<ShoppingCart>().cart.coupons.any((element) => element.code.contains('points_redemption')))
      list.add(
          CustomCard(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 24, 24, 12),
              child: Column(
                children: [
                  Text(parseHtmlString(context.read<ShoppingCart>().cart.points!.message)),
                  new ButtonBar(
                    alignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(),
                      TextButton(onPressed: () {
                        context.read<ShoppingCart>().redeemRwardPoints(context);
                      }, child: Text(widget.appStateModel.blocks.localeText.apply)),
                    ],
                  ),
                ],
              ),
            ),
          )
      );
      if(context.read<ShoppingCart>().cart.points!.pointEarned > 0)
      list.add(
          CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Text(parseHtmlString(context.read<ShoppingCart>().cart.points!.earnPointsMessage)),
            ),
          )
      );
    }


    context.read<ShoppingCart>().cart.cartContents.forEach((element) {
      list.add(ShoppingCartRow(product: element));
    });

    list.add(
      Card(
        elevation: 0,
        margin: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0.0),
        ),
        child: Container(
          padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
          child: Container(
            //height: 40,
            //alignment: Alignment.center,
            //width: MediaQuery.of(context).size.width * .68,
            child: Form(
              key: _formKey,
              child: TextFormField(
                controller: _couponCodeController,
                decoration: new InputDecoration(
                  filled: true,
                  border: InputBorder.none,
                  hintText: widget.appStateModel.blocks.localeText.couponCode,
                  suffixIcon: _couponCodeController.text.isNotEmpty ? TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        context.read<ShoppingCart>().applyCoupon(_couponCodeController.text, context);
                      }
                    },
                    child: Text(
                      widget.appStateModel.blocks.localeText.apply.toUpperCase(),
                      style: TextStyle(
                          fontSize: 16,
                          //color: Theme.of(context).buttonColor,
                          fontWeight: FontWeight.w700),
                    ),
                  ) : TextButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return CouponsPage();
                      }));
                    },
                    child: Text(
                      widget.appStateModel.blocks.localeText.viewAll.toUpperCase(),
                      style: TextStyle(
                          fontSize: 16,
                          //color: Theme.of(context).buttonColor,
                          fontWeight: FontWeight.w700),
                    ),
                  )
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return widget.appStateModel.blocks.localeText
                        .pleaseEnterCouponCode;
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {});
                },
                onSaved: (value) {
                  if(value != null)
                  widget.checkoutBloc.formData['coupon_code'] = value;
                },
              ),
            ),
          ),
        ),
      ),
    );

    list.add(
        ShoppingCartSummary()
    );

    return list;
  }


}

class ShoppingCartSummary extends StatelessWidget {

  final AppStateModel model = AppStateModel();

  @override
  Widget build(BuildContext context) {

    final smallAmountStyle = Theme.of(context).textTheme.subtitle1;
    final largeAmountStyle = Theme.of(context).textTheme.headline6;

    CartModel cart = context.read<ShoppingCart>().cart;

    List<Widget> feeWidgets = [];

    for (var fee in cart.cartFees) {
      feeWidgets.add(Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Text(fee.name, style: smallAmountStyle,),
              ),
              Text(
                parseHtmlString(fee.total.toString()),
                style: smallAmountStyle,
              ),
            ],
          ),
          const SizedBox(height: 6.0),
        ],
      ));
    }

    List<Widget> couponsWidgets = [];
    for (var item in cart.coupons) {
      couponsWidgets.add(Column(
        children: [
          Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: [
                    Text(item.label, style: smallAmountStyle,),
                    SizedBox(
                      width: 6,
                    ),
                    GestureDetector(
                        onTap: () => context.read<ShoppingCart>().removeCoupon(item.code),
                        child: Text(
                          model.blocks.localeText.remove,
                          style: TextStyle(color: Colors.red),
                        )),
                  ],
                ),
              ),
              Text(
                parseHtmlString(item.amount.toString()),
                style: smallAmountStyle,
              ),
            ],
          ),
          const SizedBox(height: 6.0),
        ],
      ));
    }

    return Card(
      elevation: 0,
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    model.blocks.localeText.subtotal,
                    style: smallAmountStyle,
                  ),
                ),
                Text(
                  parseHtmlString(
                    cart.cartTotals.subtotal,
                  ),
                  style: smallAmountStyle,
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    model.blocks.localeText.shipping,
                    style: smallAmountStyle,
                  ),
                ),
                Text(
                  parseHtmlString(cart.cartTotals.shippingTotal),
                  style: smallAmountStyle,
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    model.blocks.localeText.tax,
                    style: smallAmountStyle,
                  ),
                ),
                Text(
                  parseHtmlString(cart.cartTotals.totalTax),
                  style: smallAmountStyle,
                ),
              ],
            ),
            const SizedBox(height: 6.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    model.blocks.localeText.discount,
                    style: smallAmountStyle,
                  ),
                ),
                Text(
                  parseHtmlString(cart.cartTotals.discountTotal),
                  style: smallAmountStyle,
                ),
              ],
            ),
            feeWidgets.length > 0
                ? Column(
              children: [
                const SizedBox(height: 6.0),
                Column(
                  children: feeWidgets,
                ),
              ],
            ) : Container(),
            couponsWidgets.length > 0
                ? Column(
              children: [
                const SizedBox(height: 6.0),
                Column(
                  children: couponsWidgets,
                ),
              ],
            ) : Container(),
            const SizedBox(height: 6.0),
            Divider(
              thickness: 0.6,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Text(
                    model.blocks.localeText.total,
                    style: largeAmountStyle,
                  ),
                ),
                Text(
                  parseHtmlString(cart.cartTotals.total),
                  style: largeAmountStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShoppingCartRow extends StatefulWidget {
  ShoppingCartRow({required this.product});

  final CartContent product;
  final appStateModel = AppStateModel();

  @override
  _ShoppingCartRowState createState() => _ShoppingCartRowState();
}

class _ShoppingCartRowState extends State<ShoppingCartRow> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    Widget? addonsWidget;
    if(widget.product.addons.length > 0) {
      List<Widget> list = [];
      widget.product.addons.forEach((element) {
        list.add(Text(element.name + ': ' + element.value.toString())
        );
      });
      list.add(SizedBox(height: 4));
      addonsWidget = Column(crossAxisAlignment: CrossAxisAlignment.start, children: list);
    }

    Widget? bookingWidget;
    if(widget.product.booking.date.isNotEmpty)  {
      List<Widget> list = [];
      list.add(Text(widget.product.booking.date + ' ' + widget.product.booking.time));
      list.add(SizedBox(height: 4));
      bookingWidget = Column(crossAxisAlignment: CrossAxisAlignment.start, children: list);
    }

    return Column(
      children: [
        ListTile(
          tileColor: Theme.of(context).cardColor,
          contentPadding:
          EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          onTap: () {
            //TODO Store Details Page
          },
          dense: false,
          leading: Container(
              width: 60,
              child: Card(
                clipBehavior: Clip.antiAlias,
                margin: EdgeInsets.all(0),
                elevation: 0,
                child: CachedNetworkImage(
                  imageUrl: widget.product.thumb,
                  placeholder: (context, url) => Container(color: Colors.grey.withOpacity(0.2),),
                  errorWidget: (context, url, error) => Container(color: Colors.grey.withOpacity(0.2),),
                  fit: BoxFit.cover,
                ),
              )
          ),
          title: Text(widget.product.name, maxLines: 2, style: Theme.of(context).textTheme.titleSmall,),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if(widget.product.cartItemData != null)
                Column(
                  children: [
                    Text(parseHtmlString(widget.product.cartItemData!), style: Theme.of(context).textTheme.bodySmall,),
                  ],
                ),
              SizedBox(height: 4),
              if(addonsWidget != null)
                addonsWidget,
              if(bookingWidget != null)
                bookingWidget,
              Text(parseHtmlString(widget.product.formattedPrice), maxLines: 2, style: Theme.of(context).textTheme.subtitle2!.copyWith(
                  fontWeight: FontWeight.bold
              )),
              SizedBox(height: 8),
              buildCartCountButton(context)
            ],
          ),
        ),
        Divider(height: 0)
      ],
    );
  }

  Widget buildCartCountButton(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () => context.read<ShoppingCart>().removeCartItem(widget.product),
          child: Icon(CupertinoIcons.delete, color: Theme.of(context).hintColor),
        ),
        Container(
            color: Colors.yellow,
            height: 30,
            padding: EdgeInsets.all(0),
            width: 99.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                    child: InkWell(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await context.read<ShoppingCart>().updateCartQty(context, widget.product.quantity - 1, cartContent: widget.product);
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: new Icon(Icons.remove, size: 18, color: Colors.black),
                        ))),
                Expanded(
                    child: InkWell(
                        onTap: () {},
                        child: Container(
                          alignment: Alignment.center,
                          child: isLoading ? SizedBox(
                            child: CircularProgressIndicator(strokeWidth: 2),
                            height: 16.0,
                            width: 16.0,
                          ) : Text(widget.product.quantity.toString(),
                              style: TextStyle(
                                  color: Colors.black, fontSize: 17)),
                        ))),
                Expanded(
                    child: InkWell(
                        onTap: () async {
                          setState(() {
                            isLoading = true;
                          });
                          await context.read<ShoppingCart>().updateCartQty(context, widget.product.quantity + 1, cartContent: widget.product);
                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: new Icon(Icons.add, size: 18, color: Colors.black),
                        ))),

              ],
            )),
      ],
    );
  }
}
