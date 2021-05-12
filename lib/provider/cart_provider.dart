import 'package:flutter/material.dart';
import 'package:woocommerce_app/models/cart_request_model.dart';
import 'package:woocommerce_app/models/cart_response_model.dart';
import 'package:woocommerce_app/models/customer_details_model.dart';
import 'package:woocommerce_app/models/order.dart';
import 'package:woocommerce_app/shared_service.dart';

import '../api_service.dart';

class CartProvider with ChangeNotifier {
  APIService _apiService;
  List<CartItem> _cartItems;
  CustomerDetailsModel _customerDetailsModel;
  OrderModel _orderModel;
  bool _isOrderCreated = false;
  List<CartItem> get cartItems => _cartItems;
  double get totalRecords => _cartItems.length.toDouble();
  double get totalAmount => _cartItems != null
      ? _cartItems.map<double>((m) => m.lineSubtotal).reduce((a, b) => a + b)
      : 0;
  CustomerDetailsModel get costumerDetailModel => _customerDetailsModel;
  OrderModel get orderModel => _orderModel;
  bool get isOrderCreated => _isOrderCreated;
  CartProvider() {
    _apiService = APIService();
    _cartItems = List<CartItem>();
  }

  void resetStreams() {
    _apiService = APIService();
    _cartItems = List<CartItem>();
  }

  fetchCartItems() async {
    bool isLoggedIn = await SharedService.isLoggedIn();

    if (_cartItems == null) resetStreams();
    if (isLoggedIn) {
      await _apiService.getCartItems().then((cartResponseModel) {
        if (cartResponseModel.data != null) {
          _cartItems.clear();
          _cartItems.addAll(cartResponseModel.data);
        }
        notifyListeners();
      });
    }
  }

  void addToCart(
    CartProducts product,
    Function onCallback,
  ) async {
    CartRequestModel requestModel = new CartRequestModel();
    requestModel.products = new List<CartProducts>();

    if (_cartItems.length == 0) {
      await fetchCartItems();
    }

    _cartItems.forEach((v) {
      requestModel.products.add(
        new CartProducts(
            productId: v.productId,
            quantity: v.qty,
            variationId: v.variationId),
      );
    });

    var isProductExist = requestModel.products.firstWhere(
        (prd) =>
            prd.productId == product.productId &&
            prd.variationId == product.variationId,
        orElse: () => null);

    if (isProductExist != null) {
      requestModel.products.remove(isProductExist);
    }

    requestModel.products.add(product);

    await _apiService.addtoCart(requestModel).then((cartResponseModel) {
      if (cartResponseModel.data != null) {
        _cartItems = [];
        _cartItems.addAll(cartResponseModel.data);
      }
      onCallback(cartResponseModel);
      notifyListeners();
    });
  }

  void clear() async {
    _cartItems.clear();
    print('done');
  }

  void updateQty(int productId, int qty, {int variationId = 0}) {
    var isProductExist = _cartItems.firstWhere(
        (prd) => prd.productId == productId && prd.variationId == variationId,
        orElse: () => null);

    if (isProductExist != null) {
      isProductExist.qty = qty;
    }

    notifyListeners();
  }

  updateCart(
    Function onCallback,
  ) async {
    CartRequestModel requestModel = new CartRequestModel();
    requestModel.products = new List<CartProducts>();

    if (_cartItems.isNotEmpty) {
      _cartItems.forEach((v) {
        requestModel.products.add(
          new CartProducts(
            productId: v.productId,
            quantity: v.qty,
            variationId: v.variationId,
          ),
        );
      });
    }
    await _apiService.addtoCart(requestModel).then((cartResponseModel) {
      if (cartResponseModel.data != null) {
        _cartItems = [];
        _cartItems.addAll(cartResponseModel.data);
      }
      onCallback(cartResponseModel);
      notifyListeners();
    });
  }

  removeItem(
    int productId,
  ) {
    var isProductExist = _cartItems
        .firstWhere((prd) => prd.productId == productId, orElse: () => null);

    if (isProductExist != null) {
      _cartItems.remove(isProductExist);
    }
    if (_cartItems.length == 1 && _cartItems[0].productId == productId) {
      _cartItems.removeLast();
    }

    notifyListeners();
  }

  fetchShippingDetails() async {
    if (_customerDetailsModel == null) {
      _customerDetailsModel = new CustomerDetailsModel();
    }
    _customerDetailsModel = await _apiService.customerDetails();
    notifyListeners();
  }

  processOrder(OrderModel orderModel) {
    print("test create");
    this._orderModel = orderModel;
    createOrder();
    notifyListeners();
  }

  void createOrder() async {
    print("test create");
    if (_orderModel.shipping == null) {
      _orderModel.shipping = new Shipping();
    }
    if (this.costumerDetailModel.shipping != null) {
      _orderModel.shipping = this.costumerDetailModel.shipping;
    }
    if (orderModel.lineItems == null) {
      _orderModel.lineItems = new List<LineItems>();
    }
    _cartItems.forEach((element) {
      _orderModel.lineItems.add(
        new LineItems(
          productId: element.productId,
          quantity: element.qty,
          variationId: element.variationId,
        ),
      );
    });
    await _apiService.createOrder(orderModel).then((value) {
      if (value) {
        _isOrderCreated = true;
        notifyListeners();
      }
    });
  }
}
