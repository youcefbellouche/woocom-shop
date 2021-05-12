import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/pages/home_page.dart';
import 'package:woocommerce_app/provider/cart_provider.dart';
import 'package:woocommerce_app/provider/order_provider.dart';

class OrderSuccessWidget extends StatefulWidget {
  OrderSuccessWidget({
    Key key,
  }) : super(key: key);

  @override
  _OrderSuccessWidgetState createState() => _OrderSuccessWidgetState();
}

class _OrderSuccessWidgetState extends State<OrderSuccessWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (context, orderModel, child) {
        if (orderModel.orderModel != null) {
          return Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                begin: Alignment.bottomLeft,
                                end: Alignment.topRight,
                                colors: [
                                  Colors.green.withOpacity(1),
                                  Colors.green.withOpacity(0.2),
                                ],
                              ),
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 90,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Opacity(
                        opacity: 0.6,
                        child: Text(
                          "Your order has been  submitted!",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headline3,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Order Id: ${orderModel.orderModel.orderNumber}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      SizedBox(height: 20),
                      FlatButton(
                        child: Text(
                          'Done',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage(),
                            ),
                            ModalRoute.withName("/Home"),
                          );
                        },
                        padding: EdgeInsets.all(15),
                        color: Colors.green,
                        //shape: StadiumBorder(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
