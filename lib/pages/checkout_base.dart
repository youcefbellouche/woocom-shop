import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/models/order.dart';
import 'package:woocommerce_app/pages/home_page.dart';
import 'package:woocommerce_app/provider/cart_provider.dart';
import 'package:woocommerce_app/provider/loader_provider.dart';
import 'package:woocommerce_app/utils/ProgressHUD.dart';
import 'package:woocommerce_app/utils/widget_checkpoints.dart';

class CheckoutBasePage extends StatefulWidget {
  @override
  CheckoutBasePageState createState() => CheckoutBasePageState();
}

class CheckoutBasePageState<T extends CheckoutBasePage> extends State<T> {
  int currentPage = 0;
  bool showBackbutton = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LoaderProvider>(
      builder: (context, loaderModerl, child) {
        return Scaffold(
          appBar: _buildAppBar(),
          backgroundColor: Colors.white,
          body: ProgressHUD(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CheckPoints(
                    checkedTill: currentPage,
                    checkPoints: ["Livraison", "Paiement", "Finalisation"],
                    checkPointFilledColor: Colors.green,
                  ),
                  Divider(
                    color: Colors.grey,
                  ),
                  pageUI(),
                ],
              ),
            ),
            inAsyncCall: loaderModerl.isApiCallProcess,
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
      automaticallyImplyLeading: showBackbutton,
      title: Text(
        "Valider",
        style: TextStyle(color: Colors.white),
      ),
      actions: <Widget>[],
    );
  }

  Widget pageUI() {
    return Container(
      margin: EdgeInsets.only(top: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colors.green.withOpacity(1),
                      Colors.green.withOpacity(0.2),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 90,
                ),
              )
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Opacity(
            opacity: 0.6,
            child: Text(
              "your order has been successfully submitted!",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline3,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          FlatButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(),
                ),
              );
            },
            child: Text('Done'),
            padding: EdgeInsets.all(15),
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
