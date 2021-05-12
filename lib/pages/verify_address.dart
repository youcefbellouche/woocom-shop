import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:woocommerce_app/models/country.dart';
import 'package:woocommerce_app/models/customer_details_model.dart';
import 'package:woocommerce_app/pages/checkout_base.dart';
import 'package:woocommerce_app/pages/payment_methods.dart';
import 'package:woocommerce_app/provider/cart_provider.dart';
import 'package:woocommerce_app/provider/masters_provider.dart';
import 'package:woocommerce_app/utils/ProgressHUD.dart';
import 'package:woocommerce_app/utils/form_helper.dart';
import 'package:woocommerce_app/models/order.dart';

import '../api_service.dart';

class VerifyAddress extends CheckoutBasePage {
  @override
  _VerifyAddressState createState() => _VerifyAddressState();
}

class _VerifyAddressState extends CheckoutBasePageState<VerifyAddress> {
  CustomerDetailsModel model;
  APIService apiService;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
    currentPage = 0;
    var cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.fetchShippingDetails();
  }

  @override
  Widget pageUI() {
    return Container(
        child: Consumer<CartProvider>(builder: (context, customerModel, child) {
      if (customerModel.costumerDetailModel.id != null) {
        return _formUI(customerModel.costumerDetailModel);
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    }));
  }

  Widget _formUI(CustomerDetailsModel model) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Container(
          child: Align(
            alignment: Alignment.topLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("First Name"),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("Last Name"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: FormHelper.fieldLabelValue(
                            context, model.shipping.firstName),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: FormHelper.fieldLabelValue(
                            context, model.shipping.lastName),
                      ),
                    ),
                  ],
                ),
                FormHelper.fieldLabel("Adresse"),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: FormHelper.fieldLabelValue(
                      context, model.shipping.address1),
                ),
                FormHelper.fieldLabel("Appartement"),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: FormHelper.fieldLabelValue(
                      context, model.shipping.address2),
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("Wilaya"),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("Pays"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: FormHelper.fieldLabelValue(
                            context, model.shipping.state),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: FormHelper.fieldLabelValue(
                            context, model.shipping.country),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("Cité"),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("Code postal"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: FormHelper.fieldLabelValue(
                            context, model.shipping.city),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: FormHelper.fieldLabelValue(
                            context, model.shipping.postcode),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                new Center(
                  child: FormHelper.saveButton("suivant", () async {
                    print("Button");
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaymentMethodsWidget()));
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
