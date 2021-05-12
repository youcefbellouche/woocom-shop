import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:woocommerce_app/models/cart_request_model.dart';
import 'package:woocommerce_app/models/country.dart';
import 'package:woocommerce_app/models/customer.dart';
import 'package:woocommerce_app/models/login_model.dart';
import 'package:woocommerce_app/models/order.dart';
import 'package:woocommerce_app/models/order_detail.dart';
import 'package:woocommerce_app/shared_service.dart';

import 'config.dart';
import 'models/cart_response_model.dart';
import 'models/category.dart';
import 'models/customer_details_model.dart';
import 'models/product.dart';
import 'models/variable_product.dart';

class APIService {
  Future<bool> createCustomer(CustomerModel model) async {
    var authToken = base64.encode(
      utf8.encode(Config.key + ":" + Config.sceret),
    );

    bool ret = false;

    try {
      var response = await Dio().post(
        Config.url + Config.customersURL,
        data: model.toJson(),
        options: new Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      print(response.statusCode);

      if (response.statusCode == 201) {
        ret = true;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
        ret = false;
      } else {
        print(e.message);
        print(e.request);
        ret = false;
      }
    }

    return ret;
  }

  Future<bool> clearCart() async {
    LoginResponseModel loginResponseModel = await SharedService.loginDetails();

    try {
      var response = await Dio().post(
        Config.cocart,
        options: new Options(headers: {
          HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
          HttpHeaders.authorizationHeader:
              "Bearer ${loginResponseModel.data.token}",
        }),
      );

      if (response.statusCode == 200) {
        print(response.statusMessage);
        return true;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
        return false;
      } else {
        print(e.message);
        print(e.request);
        return false;
      }
    }
  }

  Future<LoginResponseModel> loginCustomer(
      String email, String password) async {
    LoginResponseModel model;

    try {
      var response = await Dio().post(
        Config.tokenURL,
        data: {
          "username": email,
          "password": password,
        },
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded",
          },
        ),
      );

      if (response.statusCode == 200) {
        model = LoginResponseModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.request);
      }
    }

    return model;
  }

  Future<List<Category>> getCategories() async {
    List<Category> data = new List<Category>();

    try {
      String url = Config.url +
          Config.categoriesURL +
          "?consumer_key=${Config.key}&consumer_secret=${Config.sceret}";
      var response = await Dio().get(
        url,
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        data = (response.data as List)
            .map(
              (i) => Category.fromJson(i),
            )
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    } catch (e) {
      print(e.toString());
    }

    return data;
  }

  Future<List<Product>> getProducts({
    int pageNumber,
    int pageSize,
    String strSearch,
    String tagName,
    String categoryId,
    List<int> productIds,
    String sortBy,
    String sortOrder = "asc",
  }) async {
    List<Product> data = new List<Product>();

    try {
      String parameter = "";

      if (strSearch != null) {
        parameter += "&search=$strSearch";
      }

      if (pageSize != null) {
        parameter += "&per_page=$pageSize";
      }

      if (pageNumber != null) {
        parameter += "&page=$pageNumber";
      }

      if (tagName != null) {
        parameter += "&tag=$tagName";
      }

      if (categoryId != null) {
        parameter += "&category=$categoryId";
      }

      if (productIds != null) {
        parameter += "&include=${productIds.join(",").toString()}";
      }

      if (sortBy != null) {
        parameter += "&orderby=$sortBy";
      }

      if (sortBy != null) {
        parameter += "&order=$sortOrder";
      }

      String url = Config.url +
          Config.productsURL +
          "?consumer_key=${Config.key}&consumer_secret=${Config.sceret}${parameter.toString()}";

      print(url);

      var response = await Dio().get(
        url,
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        data = (response.data as List)
            .map(
              (i) => Product.fromJson(i),
            )
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return data;
  }

  Future<CartResponseModel> addtoCart(CartRequestModel model) async {
    LoginResponseModel loginResponseModel = await SharedService.loginDetails();

    if (loginResponseModel.data != null) {
      model.userId = loginResponseModel.data.id;
    }

    CartResponseModel responseModel;

    try {
      var response = await Dio().post(
        Config.url + Config.addtoCartURL,
        data: model.toJson(),
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        responseModel = CartResponseModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.request);
      }
    }

    return responseModel;
  }

  Future<CartResponseModel> getCartItems() async {
    CartResponseModel responseModel;

    try {
      LoginResponseModel loginResponseModel =
          await SharedService.loginDetails();

      if (loginResponseModel.data != null) {
        int userId = loginResponseModel.data.id;

        String url = Config.url +
            Config.cartURL +
            "?user_id=$userId&consumer_key=${Config.key}&consumer_secret=${Config.sceret}";

        print(url);

        var response = await Dio().get(
          url,
          options: new Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
          ),
        );

        if (response.statusCode == 200) {
          responseModel = CartResponseModel.fromJson(response.data);
        }
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return responseModel;
  }

  Future<List<VariableProduct>> getVariableProducts(
    int productId,
  ) async {
    List<VariableProduct> responseModel;

    try {
      String url = Config.url +
          Config.productsURL +
          "/${productId.toString()}/${Config.variableProductsURL}?consumer_key=${Config.key}&consumer_secret=${Config.sceret}";

      print(url);

      var response = await Dio().get(
        url,
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        responseModel = (response.data as List)
            .map(
              (i) => VariableProduct.fromJson(i),
            )
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return responseModel;
  }

  Future<CustomerDetailsModel> customerDetails() async {
    CustomerDetailsModel responseModel;

    try {
      LoginResponseModel loginResponseModel =
          await SharedService.loginDetails();

      if (loginResponseModel.data != null) {
        int userId = loginResponseModel.data.id;

        String url = Config.url +
            Config.customersURL +
            "/$userId?consumer_key=${Config.key}&consumer_secret=${Config.sceret}";

        var response = await Dio().get(
          url,
          options: new Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
            },
          ),
        );

        if (response.statusCode == 200) {
          responseModel = CustomerDetailsModel.fromJson(response.data);
        }
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.request);
      }
    }

    return responseModel;
  }

  Future<CustomerDetailsModel> updateCustomerAddress(
    CustomerDetailsModel requestModel,
  ) async {
    CustomerDetailsModel responseModel;

    LoginResponseModel loginResponseModel = await SharedService.loginDetails();

    try {
      var authToken = base64.encode(
        utf8.encode(Config.key + ":" + Config.sceret),
      );

      String url =
          Config.url + Config.customersURL + "/${loginResponseModel.data.id}";

      print(jsonEncode(requestModel.toJson()));
      var response = await Dio().post(
        url,
        data: requestModel.toJson(),
        options: new Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        responseModel = CustomerDetailsModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.request);
      }
    }

    return responseModel;
  }

  Future<List<Country>> getCountries() async {
    List<Country> data = new List<Country>();

    try {
      String url = Config.url +
          Config.countriesURL +
          "?consumer_key=${Config.key}&consumer_secret=${Config.sceret}";

      print(url);

      var response = await Dio().get(
        url,
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        data = (response.data as List)
            .map(
              (i) => Country.fromJson(i),
            )
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }

    return data;
  }

  Future<bool> createOrder(OrderModel model) async {
    LoginResponseModel loginResponseModel = await SharedService.loginDetails();
    model.customerId = loginResponseModel.data.id;
    bool isOrederCreated = false;
    var authToken = base64.encode(
      utf8.encode(Config.key + ":" + Config.sceret),
    );

    try {
      var response = await Dio().post(Config.url + Config.orderURL,
          data: model.toJson(),
          options: new Options(headers: {
            HttpHeaders.authorizationHeader: 'Basic $authToken',
            HttpHeaders.connectionHeader: "application/json",
          }));
      if (response.statusCode == 201) {
        isOrederCreated = true;
      }
    } on DioError catch (e) {
      if (e.response.statusCode == 404) {
        print(e.response.statusCode);
      } else {
        print(e.message);
        print(e.request);
      }
    }
    return isOrederCreated;
  }

  Future<List<OrderModel>> getOrders() async {
    List<OrderModel> data = new List<OrderModel>();
    LoginResponseModel loginResponseModel = await SharedService.loginDetails();

    try {
      String url = Config.url +
          Config.orderURL +
          "?user_id=${loginResponseModel.data.id}&consumer_key=${Config.key}&consumer_secret=${Config.sceret}";
      print(url);
      var response = await Dio().get(url,
          options: new Options(headers: {
            HttpHeaders.connectionHeader: "application/json",
          }));
      if (response.statusCode == 200) {
        data = (response.data as List)
            .map(
              (e) => OrderModel.fromJson(e),
            )
            .toList();
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return data;
  }

  Future<OrderDetailModel> getOrderDetails(int orderId) async {
    OrderDetailModel responseModel = new OrderDetailModel();
    try {
      print("api$orderId");
      String url = Config.url +
          Config.orderURL +
          "/$orderId?consumer_key=${Config.key}&consumer_secret=${Config.sceret}";
      print(url);
      var response = await Dio().get(
        url,
        options: new Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
          },
        ),
      );
      if (response.statusCode == 200) {
        responseModel = OrderDetailModel.fromJson(response.data);
      }
    } on DioError catch (e) {
      print(e.response);
    }
    return responseModel;
  }
}
