import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:woocommerce_app/models/order.dart';
import 'package:woocommerce_app/pages/order_detail.dart';

class WidgetOrderItem extends StatelessWidget {
  OrderModel orderModel;
  WidgetOrderItem({this.orderModel});
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            _orderStatus(this.orderModel.status),
            Divider(
              color: Colors.grey,
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                iconText(
                    Icon(
                      Icons.edit,
                      color: Colors.blue,
                    ),
                    Text(
                      "Order ID:",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Text(
                  this.orderModel.orderNumber,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                iconText(
                    Icon(
                      Icons.today,
                      color: Colors.blue,
                    ),
                    Text(
                      "Order Date",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    )),
                Text(
                  this.orderModel.orderDate.toString(),
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                flatButton(
                    Row(children: [
                      Text(
                        "Order Details",
                      ),
                      Icon(Icons.chevron_right)
                    ]),
                    Colors.green, () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OrderDetailsPage(
                              orderID: this.orderModel.orderId)));
                })
              ],
            )
          ],
        ));
  }

  Widget iconText(Icon iconWigdet, Text textWigdet) {
    return Row(
      children: [
        iconWigdet,
        SizedBox(
          width: 5,
        ),
        textWigdet
      ],
    );
  }

  Widget flatButton(
    Widget iconText,
    Color color,
    Function onPressed,
  ) {
    return FlatButton(
      child: iconText,
      onPressed: onPressed,
      padding: EdgeInsets.all(5),
      color: color,
      shape: StadiumBorder(),
    );
  }

  Widget _orderStatus(String status) {
    Icon icon;
    Color color;

    if (status == "pending" || status == "processing" || status == "on-hold") {
      icon = Icon(
        Icons.timer,
        color: Colors.orange,
      );
      color = Colors.orange;
    } else if (status == 'completed') {
      icon = Icon(
        Icons.check,
        color: Colors.green,
      );
      color = Colors.green;
    } else if (status == "cancelled" ||
        status == "refunded" ||
        status == "failed") {
      icon = Icon(
        Icons.clear,
        color: Colors.redAccent,
      );
      color = Colors.redAccent;
    } else {
      icon = Icon(
        Icons.clear,
        color: Colors.redAccent,
      );
      color = Colors.redAccent;
    }
    return iconText(
        icon,
        Text(
          "Order $status",
          style: TextStyle(
            fontSize: 15,
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ));
  }
}
