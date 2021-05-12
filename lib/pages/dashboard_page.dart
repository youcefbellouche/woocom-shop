import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/config.dart';
import 'package:woocommerce_app/pages/cart_page.dart';
import 'package:woocommerce_app/provider/cart_provider.dart';
import 'package:woocommerce_app/widgets/widget_home_categories.dart';
import 'package:woocommerce_app/widgets/widget_home_products_tags.dart';
import 'package:search_app_bar/search_app_bar.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        brightness: Brightness.dark,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: Text(
          'Raysel Shop',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Container(
        color: const Color(0xffF4F7FA),
        child: ListView(
          children: <Widget>[
            //imageCarousel(context),
            WidgetCategories(),
            WidgetHomeProducts(
              labelName: "Les offres du Jour !",
              tagId: Config.todayOffersTagId,
            ),
            SizedBox(
              height: 10,
            ),
            WidgetHomeProducts(
              labelName: "Produits les plus vendus ! ",
              tagId: Config.topSellingProductsTagId,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
