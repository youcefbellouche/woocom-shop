import 'package:woocommerce_app/models/customer_details_model.dart';

class OrderModel {
  int customerId;
  String paymentMethod;
  String paymentMethodTitle;
  bool setPaid;
  String transactionId;
  List<LineItems> lineItems;

  int orderId;
  String orderNumber;
  String status;
  String orderDate;
  Shipping shipping;

  OrderModel({
    this.customerId,
    this.paymentMethod,
    this.paymentMethodTitle,
    this.setPaid,
    this.transactionId,
    this.lineItems,
    this.orderId,
    this.orderNumber,
    this.status,
    this.orderDate,
    this.shipping,
  });
  OrderModel.fromJson(Map<String, dynamic> json) {
    customerId = json['customer_id'];
    orderId = json['id'];
    status = json['status'];
    orderDate = json['date_created'];
    orderNumber = json['order_key'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['customer_id'] = customerId;
    data['payment_method'] = paymentMethod;
    data['payment_method_title'] = paymentMethodTitle;
    data['set_paid'] = setPaid;
    data['date_created'] = orderDate;
    data['transaction_id'] = transactionId;
    data['shipping'] = shipping.toJson();
    if (lineItems != null) {
      data['line_items'] = lineItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Order {
  PaymentDetails paymentDetails;
  //BillingAddress billingAddress;
  //ShippingAddress shippingAddress;
  int customerId;
  List<LineItems> lineItems;
  List<ShippingLines> shippingLines;
  String orderNumber;

  Order({
    this.paymentDetails,
    //this.billingAddress,
    //this.shippingAddress,
    this.customerId,
    this.lineItems,
    this.shippingLines,
    this.orderNumber,
  });

  Order.fromJson(Map<String, dynamic> json) {
    paymentDetails = json['payment_details'] != null
        ? new PaymentDetails.fromJson(json['payment_details'])
        : null;
    // billingAddress = json['billing_address'] != null
    //     ? new BillingAddress.fromJson(json['billing_address'])
    //     : null;
    // shippingAddress = json['shipping_address'] != null
    //     ? new ShippingAddress.fromJson(json['shipping_address'])
    //     : null;
    customerId = json['customer_id'];
    orderNumber = json['order_number'];
    if (json['line_items'] != null) {
      lineItems = new List<LineItems>();
      json['line_items'].forEach((v) {
        lineItems.add(new LineItems.fromJson(v));
      });
    }
    if (json['shipping_lines'] != null) {
      shippingLines = new List<ShippingLines>();
      json['shipping_lines'].forEach((v) {
        shippingLines.add(new ShippingLines.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.paymentDetails != null) {
      data['payment_details'] = this.paymentDetails.toJson();
    }
    // if (this.billingAddress != null) {
    //   data['billing_address'] = this.billingAddress.toJson();
    // }
    // if (this.shippingAddress != null) {
    //   data['shipping_address'] = this.shippingAddress.toJson();
    // }
    data['customer_id'] = this.customerId;
    if (this.lineItems != null) {
      data['line_items'] = this.lineItems.map((v) => v.toJson()).toList();
    }
    if (this.shippingLines != null) {
      data['shipping_lines'] =
          this.shippingLines.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PaymentDetails {
  String methodId;
  String methodTitle;
  bool paid;

  PaymentDetails({this.methodId, this.methodTitle, this.paid});

  PaymentDetails.fromJson(Map<String, dynamic> json) {
    methodId = json['method_id'];
    methodTitle = json['method_title'];
    paid = json['paid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['method_id'] = this.methodId;
    data['method_title'] = this.methodTitle;
    data['paid'] = this.paid;
    return data;
  }
}

class LineItems {
  int productId;
  String productName;
  double totalAmount;
  int quantity;
  int variationId;
  Variations variations;

  LineItems({this.productId, this.quantity, this.variationId, this.variations});

  LineItems.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    quantity = json['quantity'];
    totalAmount = json['product_name'];
    variationId = json['variation_id'];
    variations = json['variationId'] != null
        ? new Variations.fromJson(json['variations'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['product_name'] = this.productName;
    data['total_amount'] = this.totalAmount;
    if (this.variationId != null) {
      data['variation_id'] = this.variationId;
    }
    return data;
  }
}

class Variations {
  String paColor;

  Variations({this.paColor});

  Variations.fromJson(Map<String, dynamic> json) {
    paColor = json['pa_color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pa_color'] = this.paColor;
    return data;
  }
}

class ShippingLines {
  String methodId;
  String methodTitle;
  String total;

  ShippingLines({this.methodId, this.methodTitle, this.total});

  ShippingLines.fromJson(Map<String, dynamic> json) {
    methodId = json['method_id'];
    methodTitle = json['method_title'];
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['method_id'] = this.methodId;
    data['method_title'] = this.methodTitle;
    data['total'] = this.total;
    return data;
  }
}
