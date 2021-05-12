import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/models/country.dart';
import 'package:woocommerce_app/models/customer_details_model.dart';
import 'package:woocommerce_app/pages/checkout_base.dart';
import 'package:woocommerce_app/provider/masters_provider.dart';
import 'package:woocommerce_app/utils/ProgressHUD.dart';
import 'package:woocommerce_app/utils/form_helper.dart';

import '../api_service.dart';

class ProfilePage extends CheckoutBasePage {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends CheckoutBasePageState<ProfilePage> {
  CustomerDetailsModel model;
  APIService apiService;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();
    apiService = new APIService();
    model = new CustomerDetailsModel();
    model.billing = new Billing();
    model.shipping = new Shipping();

    var mastersBloc = Provider.of<MastersProvider>(context, listen: false);
    mastersBloc.resetStreams();
    mastersBloc.fetchAllMasters();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ProgressHUD(
        child: new Form(
          key: globalFormKey,
          child: pageUI(),
        ),
        inAsyncCall: isApiCallProcess,
        opacity: 0.3,
      ),
    );
  }

  Widget pageUI() {
    return new FutureBuilder(
      future: apiService.customerDetails(),
      builder: (BuildContext context,
          AsyncSnapshot<CustomerDetailsModel> customerModel) {
        if (customerModel.hasData) {
          model = customerModel.data;
          return _formUI();
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _formUI() {
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
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: FormHelper.fieldLabel("Last Name"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.textInput(
                        context,
                        model.shipping.firstName,
                        (value) => {
                          this.model.shipping.firstName = value,
                        },
                        onValidate: (value) {
                          return null;
                        },
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: FormHelper.textInput(
                          context,
                          model.shipping.lastName,
                          (value) => {
                            this.model.shipping.lastName = value,
                          },
                          onValidate: (value) {
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                FormHelper.fieldLabel("Address"),
                FormHelper.textInput(
                  context,
                  model.shipping.address1,
                  (value) => {
                    this.model.shipping.address1 = value,
                  },
                  onValidate: (value) {
                    return null;
                  },
                ),
                FormHelper.fieldLabel("Apartment, suite, etc. (optional)"),
                FormHelper.textInput(
                  context,
                  model.shipping.address2,
                  (value) => {
                    this.model.shipping.address2 = value,
                  },
                  onValidate: (value) {
                    return null;
                  },
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("Country/Region"),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: FormHelper.fieldLabel("State"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: countryDropdown(),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: statesDropdown(),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.fieldLabel("City"),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: FormHelper.fieldLabel("PIN Code"),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 1,
                      child: FormHelper.textInput(
                        context,
                        model.shipping.city,
                        (value) => {
                          this.model.shipping.city = value,
                        },
                        onValidate: (value) {
                          return null;
                        },
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.loose,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: FormHelper.textInput(
                          context,
                          model.shipping.postcode,
                          (value) => {
                            this.model.shipping.postcode = value,
                          },
                          onValidate: (value) {
                            return null;
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                new Center(
                  child: FormHelper.saveButton(
                    "Update",
                    () {
                      if (validateAndSave()) {
                        print(jsonEncode(model.toJson()));
                        setState(() {
                          isApiCallProcess = true;
                        });

                        apiService.updateCustomerAddress(model).then((ret) {
                          if (ret != null) {
                            print(ret.toJson());
                            setState(() {
                              isApiCallProcess = false;
                            });

                            FormHelper.showMessage(
                              context,
                              "Raysel Shop",
                              "Détails enregistrés avec succès!!",
                              "Ok",
                              () {
                                Navigator.of(context).pop();
                              },
                            );
                          } else {
                            setState(() {
                              isApiCallProcess = false;
                            });
                            FormHelper.showMessage(
                              context,
                              "Raysel Shop",
                              "Error!!",
                              "Ok",
                              () {
                                Navigator.of(context).pop();
                              },
                            );
                          }
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Widget statesDropdown() {
    return Consumer<MastersProvider>(
      builder: (context, countryModel, child) {
        if (countryModel.allCountries != null) {
          var masters = Provider.of<MastersProvider>(context, listen: false);
          if (this.model.shipping.state != null &&
              countryModel.selectedCountry != null &&
              countryModel.selectedState == null) {
            var state = countryModel.selectedCountry.states
                .where((element) => element.code == this.model.shipping.state);

            if (state.length > 0) {
              masters.setSelectedState(state.first);
            }
          }
          return dropdown(
            context,
            countryModel.selectedState,
            countryModel.selectedCountry != null
                ? countryModel.selectedCountry.states.toList()
                : new List<States>(),
            (value) {
              print(value.code);
              this.model.shipping.state = value.code;
            },
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget countryDropdown() {
    return Consumer<MastersProvider>(
      builder: (context, countryModel, child) {
        if (countryModel.allCountries != null) {
          var masters = Provider.of<MastersProvider>(context, listen: false);
          if (this.model.shipping.country != null &&
              countryModel.selectedCountry == null) {
            var country = countryModel.allCountries.where(
                (element) => element.code == this.model.shipping.country);

            if (country.length > 0) {
              masters.setSelectedCountry(country.first);
            }
          }
          return dropdown(
            context,
            countryModel.selectedCountry,
            countryModel.allCountries.toList(),
            (value) {
              masters.setSelectedCountry(value);
              masters.setSelectedState(null);
              this.model.shipping.country = value.code;
            },
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  static InputDecoration fieldDecoration(
    BuildContext context,
    String hintText,
    String helperText, {
    Widget prefixIcon,
    Widget suffixIcon,
  }) {
    return InputDecoration(
      contentPadding: EdgeInsets.all(6),
      hintText: hintText,
      helperText: helperText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
    );
  }

  static Widget dropdown(
    BuildContext context,
    Object initialValue,
    dynamic data,
    Function onChanged, {
    Function onValidate,
  }) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        height: 75,
        padding: EdgeInsets.only(top: 2),
        child: new DropdownButtonFormField<dynamic>(
          hint: new Text("Sélectionner"),
          value: (initialValue != "" && initialValue != null)
              ? initialValue
              : null,
          isDense: true,
          isExpanded: true,
          decoration: fieldDecoration(context, "", ""),
          onChanged: (dynamic newValue) {
            FocusScope.of(context).requestFocus(new FocusNode());
            onChanged(newValue);
          },
          // validator: (value) {
          //   return onValidate(value);
          // },
          items: data != null
              ? data.map<DropdownMenuItem<dynamic>>(
                  (dynamic data) {
                    return DropdownMenuItem<dynamic>(
                      value: data,
                      child: new Text(
                        data.name,
                        style: new TextStyle(color: Colors.black),
                      ),
                    );
                  },
                ).toList()
              : null,
        ),
      ),
    );
  }
}
