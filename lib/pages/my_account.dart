import 'package:flutter/material.dart';
import 'package:woocommerce_app/models/login_model.dart';
import 'package:woocommerce_app/pages/AboutUs.dart';
import 'package:woocommerce_app/pages/Profile.dart';
import 'package:woocommerce_app/pages/home_page.dart';

import 'package:woocommerce_app/pages/orders_page.dart';
import 'package:woocommerce_app/shared_service.dart';

import 'login_page.dart';

class MyAccount extends StatefulWidget {
  @override
  _MyAccountState createState() => _MyAccountState();
}

class OptionList {
  String optionTitle;
  String optionSubTitle;
  IconData optionIcon;
  Function onTap;

  OptionList(
    this.optionTitle,
    this.optionSubTitle,
    this.optionIcon,
    this.onTap,
  );
}

class _MyAccountState extends State<MyAccount> {
  List<OptionList> options = new List<OptionList>();
  @override
  void initState() {
    super.initState();
    options.add(new OptionList(
        "Mes Commandes", "Consulter mes commandes", Icons.shopping_bag_outlined,
        () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrdersPage()),
      );
    }));

    options.add(new OptionList(
        "Mes Informations", "Consulter mes informations", Icons.edit_outlined,
        () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfilePage()),
      );
    }));
    options.add(new OptionList(
        "Déconnexion", "Check my orders", Icons.power_settings_new, () {
      SharedService.logout().then((value) => {setState(() {})});
    }));
    options.add(
        new OptionList("À propos de nous", "About us", Icons.info_outline, () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AboutUs()),
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: SharedService.isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> loginModel) {
          if (loginModel.hasData) {
            if (loginModel.data) {
              return _listView(context);
            } else {
              return LoginV2();
            }
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _buildRow(OptionList optionList, int index) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(10),
          child: Icon(
            optionList.optionIcon,
            size: 30,
          ),
        ),
        onTap: () {
          return options[index].onTap();
        },
        title: Text(optionList.optionTitle,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  Widget _listView(BuildContext context) {
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
      body: new FutureBuilder(
        future: SharedService.loginDetails(),
        builder: (BuildContext context,
            AsyncSnapshot<LoginResponseModel> loginModel) {
          if (loginModel.hasData) {
            return ListView(
              children: [
                ListView.builder(
                  itemCount: options.length,
                  physics: ScrollPhysics(),
                  padding: EdgeInsets.all(8.0),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Card(
                        color: Colors.grey[200],
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0)),
                        child: _buildRow(options[index], index));
                  },
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
