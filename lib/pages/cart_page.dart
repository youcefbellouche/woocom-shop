import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/pages/login_page.dart';
import 'package:woocommerce_app/pages/verify_address.dart';
import 'package:woocommerce_app/provider/cart_provider.dart';
import 'package:woocommerce_app/provider/loader_provider.dart';
import 'package:woocommerce_app/shared_service.dart';
import 'package:woocommerce_app/utils/ProgressHUD.dart';
import 'package:woocommerce_app/widgets/widget_cart_product.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    var productsList = Provider.of<CartProvider>(context, listen: false);
    productsList.resetStreams();
    productsList.fetchCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: SharedService.isLoggedIn(),
      builder: (BuildContext context, AsyncSnapshot<bool> loginModel) {
        if (loginModel.hasData) {
          if (loginModel.data) {
            return Consumer<LoaderProvider>(
              builder: (context, loaderModel, child) {
                return Scaffold(
                  appBar: AppBar(
                    iconTheme: IconThemeData(color: Colors.white),
                    centerTitle: true,
                    brightness: Brightness.dark,
                    elevation: 0,
                    flexibleSpace: Container(
                      decoration: new BoxDecoration(
                        gradient: new LinearGradient(
                          colors: [Color(0xff2ba9e1), Color(0xff0e71b8)],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 0.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp,
                        ),
                      ),
                    ),
                    automaticallyImplyLeading: true,
                    title: Text(
                      'Raysel Shop',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  key: scaffoldKey,
                  body: ProgressHUD(
                    child: _productsList(),
                    inAsyncCall: loaderModel.isApiCallProcess,
                    opacity: 0.3,
                  ),
                );
              },
            );
          } else {
            return LoginV2();
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _productsList() {
    return new Consumer<CartProvider>(
      builder: (context, cartModel, child) {
        if (cartModel.cartItems != null && cartModel.cartItems.length > 0) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: cartModel.cartItems.length,
                      itemBuilder: (context, index) {
                        var data = cartModel.cartItems[index];
                        return CartProduct(data: data);
                      },
                    ),
                  ],
                ),
                Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width,
                  height: 80,
                  child: Padding(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            new Text(
                              "Total",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            new Text(
                              "₹${cartModel.totalAmount}",
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        FlatButton(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Valider la Commande',
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerifyAddress(),
                              ),
                            );
                          },
                          padding: EdgeInsets.all(15),
                          color: Colors.green,
                          shape: StadiumBorder(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (cartModel.cartItems.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Color(0xff2ba9e1).withOpacity(0.5),
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 200,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.insert_emoticon, color: Colors.black),
                      SizedBox(
                        height: 5,
                      ),
                      Text("Le panier est vide !"),
                    ]),
              ),
            ),
          );
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
