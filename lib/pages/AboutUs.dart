import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:woocommerce_app/models/login_model.dart';
import 'package:woocommerce_app/pages/AboutUs.dart';
import 'package:woocommerce_app/pages/Profile.dart';
import 'package:woocommerce_app/pages/home_page.dart';
import 'package:woocommerce_app/pages/orders_page.dart';
import 'package:woocommerce_app/shared_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class OptionList {
  String optionTitle;
  String optionSubTitle;
  IconData optionIcon;
  Function onTap;
  Color color;

  OptionList(
    this.optionTitle,
    this.optionSubTitle,
    this.optionIcon,
    this.onTap,
    this.color,
  );
}

class _AboutUsState extends State<AboutUs> {
  List<OptionList> options = new List<OptionList>();
  @override
  void initState() {
    super.initState();
    options.add(new OptionList(
        "Appelez Nous", "0557008848", FontAwesomeIcons.phone, () {
      _makePhoneCall("tel:0557008848");
    }, Colors.black));
    options.add(new OptionList("Site Web", null, FontAwesomeIcons.chrome, () {
      _launchUniversalLinkIos("https://raysel-revolution.com/");
    }, Colors.black));
    options.add(
        new OptionList("Raysel Developers ", "", FontAwesomeIcons.facebook, () {
      _launchUniversalLinkIos("https://web.facebook.com/rayseldev/");
    }, Color(0xff0e71b8)));
    options.add(
        new OptionList("Raysel Marketing ", "", FontAwesomeIcons.facebook, () {
      _launchUniversalLinkIos("https://www.facebook.com/rv.raysel/");
    }, Colors.black));
    options.add(
        new OptionList("Raysel Designers", "", FontAwesomeIcons.facebook, () {
      _launchUniversalLinkIos("https://www.facebook.com/rayseldes/");
    }, Color(0xffd60c53)));
  }

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
        body: _listView(context));
  }

  Widget _buildRow(OptionList optionList, int index) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(10),
          child: FaIcon(
            optionList.optionIcon,
            size: 30,
            color: optionList.color,
          ),
        ),
        onTap: () {
          return options[index].onTap();
        },
        title: Text(optionList.optionTitle,
            style: TextStyle(fontSize: 15, color: optionList.color)),
        trailing: Icon(Icons.keyboard_arrow_right),
      ),
    );
  }

  Widget _listView(BuildContext context) {
    return new FutureBuilder(
      future: SharedService.loginDetails(),
      builder:
          (BuildContext context, AsyncSnapshot<LoginResponseModel> loginModel) {
        if (loginModel.hasData) {
          return ListView(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(15, 15, 0, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Raysel Revolution",
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold))
                  ],
                ),
              ),
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
    );
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchUniversalLinkIos(String url) async {
    if (await canLaunch(url)) {
      final bool nativeAppLaunchSucceeded = await launch(
        url,
        forceSafariVC: false,
        universalLinksOnly: true,
      );
      if (!nativeAppLaunchSucceeded) {
        await launch(
          url,
          forceSafariVC: true,
        );
      }
    }
  }
}
