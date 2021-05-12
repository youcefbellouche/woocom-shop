import 'package:flutter/material.dart';
import 'package:woocommerce_app/Animation/FadeAnimation.dart';
import 'package:woocommerce_app/api_service.dart';
import 'package:woocommerce_app/pages/AboutUs.dart';
import 'package:woocommerce_app/pages/home_page.dart';
import 'package:woocommerce_app/pages/signup_page.dart';
import 'package:woocommerce_app/shared_service.dart';
import 'package:woocommerce_app/utils/form_helper.dart';

class LoginV2 extends StatefulWidget {
  @override
  _LoginV2State createState() => _LoginV2State();
}

class _LoginV2State extends State<LoginV2> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String email;
  String password;
  APIService apiService;

  @override
  void initState() {
    apiService = new APIService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [Color(0xff2ba9e1), Color(0xff0e71b8)])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Text(
                        "S'identifier",
                        style: TextStyle(color: Colors.white, fontSize: 40),
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  FadeAnimation(
                      1.3,
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AboutUs()),
                          );
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Text(
                              "Bienvenu chez Raysel Shop",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.white,
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                        ),
                        FadeAnimation(
                            1.4,
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xff0e71b8),
                                        blurRadius: 20,
                                        offset: Offset(0, 10))
                                  ]),
                              child: Form(
                                key: globalKey,
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        onSaved: (input) => email = input,
                                        validator: (input) =>
                                            !input.contains('@')
                                                ? "L'Email doit être valide"
                                                : null,
                                        decoration: InputDecoration(
                                            hintText: "Email",
                                            hintStyle:
                                                TextStyle(color: Colors.grey),
                                            border: InputBorder.none),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.grey[200]))),
                                      child: TextFormField(
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).accentColor),
                                        keyboardType: TextInputType.text,
                                        onSaved: (input) => password = input,
                                        validator: (input) => input.length < 3
                                            ? "Le mot de passe doit contenir plus de 3 caractères"
                                            : null,
                                        obscureText: hidePassword,
                                        decoration: InputDecoration(
                                          hintText: "Mot de Passe",
                                          hintStyle:
                                              TextStyle(color: Colors.grey),
                                          border: InputBorder.none,
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                hidePassword = !hidePassword;
                                              });
                                            },
                                            color: Theme.of(context)
                                                .accentColor
                                                .withOpacity(0.8),
                                            icon: Icon(hidePassword
                                                ? Icons.visibility_off
                                                : Icons.visibility),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 40,
                        ),
                        FadeAnimation(
                            1.5,
                            ButtonTheme(
                              minWidth: 250,
                              height: 50,
                              child: RaisedButton(
                                onPressed: () {
                                  print("login");
                                  if (validateAndSave()) {
                                    setState(() {
                                      isApiCallProcess = true;
                                    });

                                    apiService
                                        .loginCustomer(email, password)
                                        .then((ret) {
                                      setState(() {
                                        isApiCallProcess = false;
                                      });
                                      print("login");
                                      if (ret.success) {
                                        print(ret.data.token);
                                        print(ret.data.toJson());
                                        print("login suc");
                                        SharedService.setLoginDetails(ret);

                                        FormHelper.showMessage(
                                          context,
                                          "Raysel Shop",
                                          "Connexion réussie",
                                          "Ok",
                                          () {
                                            Navigator.pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomePage(
                                                            selectedPage: 0)),
                                                ModalRoute.withName("/Home"));
                                          },
                                        );
                                      } else {
                                        print("login else");
                                        FormHelper.showMessage(
                                          context,
                                          "Raysel Shop",
                                          "Identifiant invalide!!",
                                          "Ok",
                                          () {
                                            Navigator.of(context).pop();
                                          },
                                        );
                                      }
                                    });
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                color: Color(0xff2ba9e1),
                                child: Text(
                                  "Se Connecter",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 20,
                        ),
                        FadeAnimation(
                            1.6,
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SignupV2()));
                              },
                              child: Text(
                                "S'inscrire",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool validateAndSave() {
    final form = globalKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
