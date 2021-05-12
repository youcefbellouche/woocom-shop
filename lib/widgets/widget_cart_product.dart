import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/models/cart_response_model.dart';
import 'package:woocommerce_app/models/product.dart';
import 'package:woocommerce_app/provider/cart_provider.dart';
import 'package:woocommerce_app/provider/loader_provider.dart';
import 'package:woocommerce_app/utils/custom_stepper.dart';
import 'package:woocommerce_app/utils/utils.dart';

class CartProduct extends StatelessWidget {
  CartProduct({Key key, this.data}) : super(key: key);
  final scaffoldKey = GlobalKey<ScaffoldState>();

  CartItem data;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: makeListTile(context),
      ),
    );
  }

  ListTile makeListTile(BuildContext context) => ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
        leading: Container(
          width: 50,
          height: 150,
          alignment: Alignment.center,
          child: Image.network(
            data.thumbnail,
            height: 150,
          ),
        ),
        title: Padding(
          padding: EdgeInsets.all(5),
          child: Text(
            (data.variationId == 0)
                ? data.productName
                : "${data.productName} (${data.attributeValue}${data.attribute})",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.all(5),
          child: Wrap(
            direction: Axis.vertical,
            children: <Widget>[
              Text(
                "₹${data.productSalePrice.toString()}",
                style: TextStyle(color: Colors.black),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 20,
                      ),
                      Text(
                        'Supprimer',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Utils.showMessage(
                      context,
                      "Raysel Shop",
                      "Voulez-vous supprimer ce Produit ?",
                      "Oui",
                      () {
                        var cartProvider =
                            Provider.of<CartProvider>(context, listen: false);
                        var loaderProvider =
                            Provider.of<LoaderProvider>(context, listen: false);
                        if (cartProvider.cartItems.length == 1) {
                          loaderProvider.setLoadingStatus(true);
                          cartProvider.removeItem(data.productId);
                          cartProvider.clear();
                          print("done");

                          loaderProvider.setLoadingStatus(false);

                          Navigator.of(context).pop();
                        } else {
                          loaderProvider.setLoadingStatus(true);
                          cartProvider.removeItem(data.productId);

                          loaderProvider.setLoadingStatus(false);

                          cartProvider.updateCart(
                            (val) {
                              loaderProvider.setLoadingStatus(false);
                            },
                          );

                          Navigator.of(context).pop();
                        }
                      },
                      buttonText2: "Non",
                      isConfirmationDialog: true,
                      onPressed2: () {
                        Navigator.of(context).pop();
                      },
                    );
                  },
                  padding: EdgeInsets.all(8),
                  color: Colors.redAccent,
                  shape: StadiumBorder(),
                ),
              ),
            ],
          ),
        ),
        trailing: Container(
          width: 120,
          child: CustomStepper(
            lowerLimit: 0,
            upperLimit: 20,
            stepValue: 1,
            iconSize: 22.0,
            value: data.qty,
            onChanged: (value) {
              Provider.of<CartProvider>(context, listen: false).updateQty(
                data.productId,
                value,
                variationId: data.variationId,
              );
            },
          ),
        ),
      );
}
