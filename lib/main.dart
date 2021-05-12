import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/pages/base_page.dart';
import 'package:woocommerce_app/pages/home_page.dart';
import 'package:woocommerce_app/pages/orders_page.dart';
import 'package:woocommerce_app/pages/products_page.dart';
import 'package:woocommerce_app/pages/verify_address.dart';
import 'package:woocommerce_app/provider/cart_provider.dart';
import 'package:woocommerce_app/provider/loader_provider.dart';
import 'package:woocommerce_app/provider/order_provider.dart';
import 'package:woocommerce_app/pages/order_success.dart';
import 'pages/product_details.dart';
import 'provider/masters_provider.dart';
import 'provider/products_provider.dart';

void main() {
  // it should be the first line in main method
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductsProvider(),
          child: ProductPage(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
          child: ProductDetails(),
        ),
        ChangeNotifierProvider(
          create: (context) => LoaderProvider(),
          child: BasePage(),
        ),
        ChangeNotifierProvider(
          create: (context) => MastersProvider(),
          child: VerifyAddress(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrderProvider(),
          child: OrdersPage(),
        ),
      ],
      child: MaterialApp(
        title: 'WooCommerce App',
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        routes: <String, WidgetBuilder>{
          // Set routes for using the Navigator.
          '/OrderSuccess': (BuildContext context) => new OrderSuccessWidget(),
        },
        theme: ThemeData(
          fontFamily: 'ProductSans',
          primaryColor: Colors.white,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
              elevation: 0, foregroundColor: Colors.white),
          brightness: Brightness.light,
          accentColor: Colors.blueAccent,
          dividerColor: Colors.blueAccent,
          focusColor: Colors.blueAccent,
          hintColor: Colors.blueAccent,
          textTheme: TextTheme(
            headline4: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w700,
                color: Colors.blueAccent,
                height: 1.3),
            headline2: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.w700,
                color: Colors.blueAccent,
                height: 1.4),
            headline3: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                height: 1.3),
            subtitle1: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w500,
                color: Colors.black,
                height: 1.3),
            caption: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w300,
                color: Colors.grey,
                height: 1.2),
          ),
        ),
      ),
    );
  }
}
