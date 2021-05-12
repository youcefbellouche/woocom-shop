import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/pages/cart_page.dart';
import 'package:woocommerce_app/provider/cart_provider.dart';
import 'package:woocommerce_app/provider/loader_provider.dart';
import 'package:woocommerce_app/provider/masters_provider.dart';
import 'package:woocommerce_app/utils/ProgressHUD.dart';

class BasePage extends StatefulWidget {
  BasePage({Key key}) : super(key: key);

  @override
  BasePageState createState() => BasePageState();
}

class BasePageState<T extends BasePage> extends State<T> {
  bool isApiCallProcess = false;

  @override
  void initState() {
    super.initState();

    var mastersBloc = Provider.of<MastersProvider>(context, listen: false);
    mastersBloc.resetStreams();
    mastersBloc.fetchAllMasters();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(
      builder: (context, loaderModel, child) {
        return Scaffold(
          appBar: _buildAppBar(),
          body: ProgressHUD(
            child: pageUI(),
            inAsyncCall: loaderModel.isApiCallProcess,
            opacity: 0.3,
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return AppBar(
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
      actions: <Widget>[
        SizedBox(
          width: 10,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: new Container(
            height: 150.0,
            width: 30.0,
            child: new GestureDetector(
              onTap: () {},
              child: new Stack(
                children: <Widget>[
                  new IconButton(
                    icon: new Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartPage(),
                        ),
                      );
                    },
                  ),
                  Provider.of<CartProvider>(context, listen: false)
                              .cartItems
                              .length ==
                          0
                      ? new Container()
                      : new Positioned(
                          child: new Stack(
                            children: <Widget>[
                              new Icon(
                                Icons.brightness_1,
                                size: 22.0,
                                color: Colors.green[800],
                              ),
                              new Positioned(
                                top: 3.0,
                                right: 5.0,
                                child: new Center(
                                  child: new Text(
                                    Provider.of<CartProvider>(context,
                                            listen: false)
                                        .cartItems
                                        .length
                                        .toString(),
                                    style: new TextStyle(
                                      color: Colors.white,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget pageUI() {
    return null;
  }

  @override
  void dispose() {
    super.dispose();
  }
}
