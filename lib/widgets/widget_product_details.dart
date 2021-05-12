import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/models/cart_request_model.dart';
import 'package:woocommerce_app/models/product.dart';
import 'package:woocommerce_app/models/variable_product.dart';
import 'package:woocommerce_app/pages/login_page.dart';
import 'package:woocommerce_app/provider/cart_provider.dart';
import 'package:woocommerce_app/provider/loader_provider.dart';
import 'package:woocommerce_app/shared_service.dart';
import 'package:woocommerce_app/utils/custom_stepper.dart';
import 'package:woocommerce_app/utils/expand_text.dart';
import 'widget_releated_products.dart';

class ProductDetailsWidget extends StatelessWidget {
  ProductDetailsWidget({Key key, this.data, this.variableProducts})
      : super(key: key);

  Product data;
  List<VariableProduct> variableProducts;

  CartProducts cartProducts = new CartProducts();

  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    cartProducts.quantity = 1;

    return SingleChildScrollView(
      child: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                productCarousel(this.data.images, context),
                SizedBox(height: 10),
                Visibility(
                  visible: data.calculateDiscount() > 0,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.redAccent,
                      ),
                      child: Text(
                        'Moin ${data.calculateDiscount()}% ',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  data.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: data.type != "variable",
                      child: Text(
                        data.attributes != null && data.attributes.length > 0
                            ? (data.attributes[0].options.join("-").toString() +
                                "" +
                                data.attributes[0].name)
                            : "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Visibility(
                      visible: data.type == "variable",
                      child: selectDropdown(
                        context,
                        "",
                        this.variableProducts,
                        (VariableProduct value) {
                          print(value.price);
                          this.data.price = value.price;
                          this.data.variableProduct = value;
                        },
                      ),
                    ),
                    Text(
                      ' ₹${data.price}',
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomStepper(
                      lowerLimit: 1,
                      upperLimit: data.stockQuantity,
                      stepValue: 1,
                      iconSize: 22.0,
                      value: cartProducts.quantity,
                      onChanged: (value) {
                        cartProducts.quantity = value;
                      },
                    ),
                    FutureBuilder(
                      future: SharedService.isLoggedIn(),
                      builder: (BuildContext context,
                          AsyncSnapshot<bool> loginModel) {
                        return FlatButton(
                          child: Text(
                            "Ajouter au Panier",
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () {
                            if (loginModel.hasData) {
                              if (loginModel.data) {
                                var loaderProvider =
                                    Provider.of<LoaderProvider>(context,
                                        listen: false);
                                loaderProvider.setLoadingStatus(true);

                                var cartProvider = Provider.of<CartProvider>(
                                    context,
                                    listen: false);
                                cartProducts.productId = data.id;

                                cartProducts.variationId =
                                    data.variableProduct != null
                                        ? data.variableProduct.id
                                        : 0;

                                cartProvider.addToCart(
                                  cartProducts,
                                  (val) {
                                    loaderProvider.setLoadingStatus(false);
                                    print(val);
                                  },
                                );
                              } else {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginV2()));
                              }
                            }
                          },
                          padding: EdgeInsets.all(15),
                          color: Colors.green,
                          shape: StadiumBorder(),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: 5),
                ExpandText(
                  labelHeader: "détails du produit",
                  desc: data.description,
                  shortDesc: data.shortDescription,
                ),
                Divider(),
                SizedBox(height: 10),
                WidgetReleatedProducts(
                  labelName: "Produit Similaires : ",
                  products: this.data.relatedIds,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget productCarousel(List<Images> images, BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 250,
      child: Stack(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            child: CarouselSlider.builder(
              itemCount: images.length,
              options: CarouselOptions(
                autoPlay: false,
                enlargeCenterPage: true,
                viewportFraction: 1,
                aspectRatio: 1.0,
              ),
              itemBuilder: (context, index, child) {
                return Container(
                  child: Center(
                    child: Image.network(
                      images[index] != null ? images[index].src : null,
                      fit: BoxFit.fill,
                    ),
                  ),
                );
              },
              carouselController: _controller,
            ),
          ),
          Positioned(
            top: 100,
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                _controller.previousPage();
              },
            ),
          ),
          Positioned(
            top: 100,
            left: MediaQuery.of(context).size.width - 80,
            child: IconButton(
              icon: Icon(Icons.arrow_forward_ios),
              onPressed: () {
                _controller.nextPage();
              },
            ),
          ),
        ],
      ),
    );
  }

  static Widget selectDropdown(
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
        width: 100,
        padding: EdgeInsets.only(top: 5),
        child: new DropdownButtonFormField<VariableProduct>(
          hint: new Text("Select"),
          value: null,
          //value: initialValue != null ? initialValue : null,
          isDense: true,
          decoration: fieldDecoration(context, "", ""),
          onChanged: (VariableProduct newValue) {
            FocusScope.of(context).requestFocus(new FocusNode());
            onChanged(newValue);
          },
          // validator: (value) {
          //   return onValidate(value);
          // },
          items: data != null
              ? data.map<DropdownMenuItem<VariableProduct>>(
                  (VariableProduct data) {
                    return DropdownMenuItem<VariableProduct>(
                      value: data,
                      child: new Text(
                        data.attributes.first.option +
                            " " +
                            data.attributes.first.name,
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
}
