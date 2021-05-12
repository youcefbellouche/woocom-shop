import 'package:flutter/material.dart';
import 'package:woocommerce_app/models/payment_method.dart';
import 'package:woocommerce_app/pages/checkout_base.dart';
import 'package:woocommerce_app/widgets/widget_payment_method_list_item.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/models/order.dart';
import 'package:woocommerce_app/provider/cart_provider.dart';

class PaymentMethodsWidget extends CheckoutBasePage {
  @override
  _PaymentMethodsWidgetState createState() => _PaymentMethodsWidgetState();
}

class _PaymentMethodsWidgetState
    extends CheckoutBasePageState<PaymentMethodsWidget> {
  PaymentMethodList list;

  @override
  void initState() {
    super.initState();
    this.currentPage = 1;
  }

  @override
  Widget pageUI() {
    list = new PaymentMethodList(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              leading: Icon(
                Icons.monetization_on,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                "Cash on delivery",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headline4,
              ),
              subtitle: Text("Select your preferred payment mode"),
            ),
          ),
          PaymentMethodListItemWidget(
            paymentMethod: list.cashList,
          ),
        ],
      ),
    );
  }
}
