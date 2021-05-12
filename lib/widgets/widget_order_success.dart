import 'package:woocommerce_app/pages/checkout_base.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/provider/cart_provider.dart';
import 'package:woocommerce_app/models/order.dart';
import 'package:woocommerce_app/pages/home_page.dart';

class OrderSuccessWidget extends CheckoutBasePage {
  @override
  _OrderSuccessWidgetState createState() => _OrderSuccessWidgetState();
}

class _OrderSuccessWidgetState
    extends CheckoutBasePageState<OrderSuccessWidget> {
  @override
  void initState() {
    this.currentPage = 2;
    this.showBackbutton = false;
    super.initState();
  }

  Widget pageUi() {
    return null;
  }
}
