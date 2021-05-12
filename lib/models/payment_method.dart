import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/models/order.dart';

import 'package:woocommerce_app/provider/cart_provider.dart';

class PaymentMethod {
  String id;
  String name;
  String description;
  String logo;
  String route;
  bool isDefault;
  bool selected;
  bool isRouteRedirect;
  OrderModel orderModel;

  PaymentMethod(
    this.id,
    this.name,
    this.description,
    this.route,
    this.logo,
    this.isRouteRedirect, {
    this.isDefault = false,
    this.selected = false,
  });
}

class PaymentMethodList {
  PaymentMethod _cashList;

  PaymentMethodList(BuildContext _buildcontext) {
    this._cashList = new PaymentMethod(
      "cod",
      "Cash on delivery",
      "Click to pay cash on delivery",
      "/OrderSuccess",
      "assets/img/cash.png",
      true,
    );
  }

  PaymentMethod get cashList => _cashList;
}
