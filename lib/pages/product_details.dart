import 'package:flutter/material.dart';
import 'package:woocommerce_app/api_service.dart';
import 'package:woocommerce_app/models/product.dart';
import 'package:woocommerce_app/models/variable_product.dart';
import 'package:woocommerce_app/widgets/widget_product_details.dart';

import 'base_page.dart';

class ProductDetails extends BasePage {
  ProductDetails({Key key, this.product}) : super(key: key);

  Product product;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends BasePageState<ProductDetails> {
  APIService apiService;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget pageUI() {
    return this.widget.product.type == "variable"
        ? _variableProductsList()
        : ProductDetailsWidget(data: this.widget.product);
  }

  Widget _variableProductsList() {
    apiService = new APIService();
    return new FutureBuilder(
      future: apiService.getVariableProducts(this.widget.product.id),
      builder:
          (BuildContext context, AsyncSnapshot<List<VariableProduct>> model) {
        if (model.hasData) {
          return ProductDetailsWidget(
            data: this.widget.product,
            variableProducts: model.data,
            //Here we will pass 1 more variable of SelectedVariableProduct
          );
        }

        // return Center(
        //   child: CircularProgressIndicator(),
        // );
      },
    );
  }
}
