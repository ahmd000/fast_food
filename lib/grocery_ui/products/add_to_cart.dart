import 'package:app/src/ui/checkout/cart/shopping_cart.dart';
import 'package:app/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../src/ui/products/product_grid/products_widgets/grouped_poducts.dart';
import '../../src/ui/products/product_grid/products_widgets/variations_products.dart';


class AddToCartButton extends StatefulWidget {
  final Product product;
  final AvailableVariation? variation;
  const AddToCartButton({Key? key, required this.product, this.variation}) : super(key: key);

  @override
  _AddToCartButtonState createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if(getQty() != 0 || isLoading) Container(
          alignment: Alignment.topCenter,
          child: Container(
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
                            if(widget.product.type == 'variable') {
                              await _bottomSheet(context);
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              bool status = await context.read<ShoppingCart>().decreaseQty(context, widget.product.id, variationId: widget.variation?.variationId);
                              setState(() {
                                isLoading = false;
                              });
                            }
                            //_toggleShare();
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
                            ) : Text(getQty().toString(),
                                style: TextStyle(
                                    color: Colors.black, fontSize: 17)),
                          ))),
                  Expanded(
                      flex: 1,
                      //fit: FlexFit.tight,
                      child: InkWell(
                          onTap: () async {
                            if(widget.product.type == 'variable') {
                              await _bottomSheet(context);
                              setState(() {
                                isLoading = false;
                              });
                            } else {
                              setState(() {
                                isLoading = true;
                              });
                              bool status = await context.read<ShoppingCart>().increaseQty(context, widget.product.id, variationId: widget.variation?.variationId);
                              setState(() {
                                isLoading = false;
                              });
                            }
                            //_toggleShare();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            child: new Icon(Icons.add, size: 18, color: Colors.black),
                          ))),
                ],
              )),
        )
        else
          Container(
            //color: Colors.yellow,
            height: 30,
            padding: EdgeInsets.all(0),
            width: 99.0,
            child: Row(
              children: [
                Expanded(child: Container()),
                InkWell(
                  onTap: widget.product.stockStatus == 'outofstock' ? null : () async {
                    if(widget.product.type == 'variable') {
                      await _bottomSheet(context);
                      setState(() {
                        isLoading = false;
                      });
                    } else {
                      addToCart(context);
                    }
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 90),
                    curve: Curves.fastOutSlowIn,
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: widget.product.stockStatus == 'outofstock' ? Theme.of(context).disabledColor : Colors.yellow,
                      borderRadius: BorderRadius.circular(0.4),
                      shape: BoxShape.rectangle,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: new Icon(Icons.add, size: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          )
      ],
    );
  }

  addToCart(BuildContext context) async {
    var data = new Map<String, dynamic>();
    if(widget.variation != null)
      data['variation_id'] = widget.variation!.variationId.toString();
    data['product_id'] = widget.product.id.toString();
    data['quantity'] = '1';
    setState(() {
      isLoading = true;
    });
    bool status = await context.read<ShoppingCart>().addToCartWithData(data, context);
    setState(() {
      isLoading = false;
    });
  }

  getQty() {
    var count = 0;
    if(context.read<ShoppingCart>().cart.cartContents.any((element) => element.productId == widget.product.id)) {
      if(widget.variation != null) {
        context.read<ShoppingCart>().cart.cartContents.where((cartContents) => cartContents.productId == widget.product.id && cartContents.variationId == widget.variation!.variationId).toList().forEach((e) => {
          count = count + e.quantity
        });
        return count;
      } else return context.read<ShoppingCart>().cart.cartContents.firstWhere((element) => element.productId == widget.product.id).quantity;
    } else return count;
  }

  Future<void> _bottomSheet(BuildContext context) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          height: 400,
          //color: Colors.amber,
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 80,
                        child: Text(widget.product.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                if (widget.product.type == 'variable') Expanded(
                  child: ListView.builder
                    (
                      itemCount: widget.product.availableVariations.length,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        return VariationProduct(id: widget.product.id, variation: widget.product.availableVariations[Index]);
                      }
                  ),
                ) else widget.product.children.length > 0 ? Expanded(
                  child: ListView.builder
                    (
                      itemCount: widget.product.children.length,
                      itemBuilder: (BuildContext ctxt, int Index) {
                        return GroupedProduct(context: ctxt, id: widget.product.id, product: widget.product.children[Index]);
                      }
                  ),
                ) : Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}