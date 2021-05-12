import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:woocommerce_app/pages/Profile.dart';
import 'package:woocommerce_app/pages/dashboard_page.dart';
import 'package:woocommerce_app/pages/my_account.dart';
import 'package:woocommerce_app/pages/orders_page.dart';
import 'package:woocommerce_app/pages/products_page.dart';
import 'package:woocommerce_app/pages/verify_address.dart';
import 'package:woocommerce_app/provider/cart_provider.dart';
import 'package:woocommerce_app/utils/cart_icons_icons.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:woocommerce_app/widgets/widget_order_item.dart';

import 'cart_page.dart';

class HomePage extends StatefulWidget {
  int selectedPage;
  HomePage({Key key, this.selectedPage}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Widget> _widgetList = [
    DashboardPage(),
    ProductPage(),
    CartPage(),
    MyAccount(),
  ];

  int page = 0;

  @override
  void initState() {
    super.initState();
    if (this.widget.selectedPage != null) {
      page = this.widget.selectedPage;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        buttonBackgroundColor: Color(0xff2ba9e1),
        color: Color(0xff2ba9e1),
        height: MediaQuery.of(context).size.height * 0.08,
        items: [
          FaIcon(
            FontAwesomeIcons.home,
            size: 27,
            color: Colors.grey[300],
          ),
          FaIcon(
            FontAwesomeIcons.storeAlt,
            size: 27,
            color: Colors.grey[300],
          ),
          FaIcon(
            Icons.shopping_cart_outlined,
            size: 30,
            color: Colors.grey[300],
          ),
          FaIcon(
            Icons.person_outline,
            size: 30,
            color: Colors.grey[300],
          ),
        ],
        onTap: (_index) {
          setState(() {
            page = _index;
          });
        },
      ),
      body: _widgetList[page],
    );
  }
}
