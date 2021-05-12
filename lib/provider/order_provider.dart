import 'dart:core';

import 'package:flutter/material.dart';
import 'package:woocommerce_app/models/order.dart';

import '../api_service.dart';

class OrderProvider with ChangeNotifier {
  APIService _apiService;
  List<OrderModel> _orderList;
  List<OrderModel> get allOredrs => _orderList;
  double get totalRecords => _orderList.length.toDouble();
  OrderProvider() {
    restStreams();
  }

  void restStreams() {
    _apiService = APIService();
  }

  fetchOrders() async {
    List<OrderModel> orderList = await _apiService.getOrders();
    if (orderList == null) {
      _orderList = new List<OrderModel>();
    }
    if (orderList.length > 0) {
      _orderList = [];
      _orderList.addAll(orderList);
    }
    notifyListeners();
  }
}
