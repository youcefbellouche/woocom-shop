import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/models/order.dart';
import 'package:woocommerce_app/provider/cart_provider.dart';
import 'package:woocommerce_app/widgets/widget_order_success.dart';
import '../models/payment_method.dart';

// ignore: must_be_immutable
class PaymentMethodListItemWidget extends StatefulWidget {
  PaymentMethod paymentMethod;

  PaymentMethodListItemWidget({Key key, this.paymentMethod}) : super(key: key);

  @override
  _PaymentMethodListItemWidgetState createState() =>
      _PaymentMethodListItemWidgetState();
}

class _PaymentMethodListItemWidgetState
    extends State<PaymentMethodListItemWidget> {
  String heroTag;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Theme.of(context).accentColor,
      focusColor: Theme.of(context).accentColor,
      highlightColor: Theme.of(context).primaryColor,
      onTap: () {
        print("inkwell");
        var order = Provider.of<CartProvider>(context, listen: false);
        OrderModel orderModel = new OrderModel();
        orderModel.paymentMethod = "COD";
        orderModel.paymentMethodTitle = "COD";
        orderModel.setPaid = true;

        order.processOrder(orderModel);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => OrderSuccessWidget(),
          ),
          ModalRoute.withName("/OrderSuccess"),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withOpacity(0.9),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).focusColor.withOpacity(0.1),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                image: DecorationImage(
                  image: AssetImage(widget.paymentMethod.logo),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            SizedBox(width: 15),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.paymentMethod.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        Text(
                          widget.paymentMethod.description,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.keyboard_arrow_right,
                    color: Theme.of(context).focusColor,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
