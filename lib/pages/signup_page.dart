import 'package:flutter/material.dart';
import 'package:woocommerce_app/Animation/FadeAnimation.dart';
import 'package:woocommerce_app/api_service.dart';
import 'package:woocommerce_app/models/customer.dart';
import 'package:woocommerce_app/pages/home_page.dart';
import 'package:woocommerce_app/shared_service.dart';
import 'package:woocommerce_app/utils/form_helper.dart';
import 'package:woocommerce_app/utils/validator_service.dart';

class SignupV2 extends StatefulWidget {
  @override
  _SignupV2State createState() => _SignupV2State();
}

class _SignupV2State extends State<SignupV2> {
  bool hidePassword = true;
  bool isApiCallProcess = false;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();
  String email;
  String password;
  APIService apiService;
  CustomerModel model;

  @override
  void initState() {
    apiService = new APIService();
    model = new CustomerModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                colors: [Color(0xff2ba9e1), Color(0xff0e71b8)])),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(60),
                        bottomRight: Radius.circular(60))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                        ),
                        FadeAnimation(
                            1,
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
                                        onSaved: (value) => {
                                          this.model.firstName = value,
                                        },
                                        validator: (value) {
                                          if (value.toString().isEmpty) {
                                            return 'Veuillez entrer votre prénom.';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            hintText: "Prénom",
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
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        onSaved: (value) => {
                                          this.model.lastName = value,
                                        },
                                        validator: (value) {
                                          if (value.toString().isEmpty) {
                                            return 'Veuillez entrer votre Nom de famille.';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                            hintText: "Nom de famille",
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
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        onSaved: (value) => {
                                          this.model.email = value,
                                        },
                                        validator: (value) {
                                          if (value.toString().isEmpty) {
                                            return 'Veuillez saisir un e-mail.';
                                          }

                                          if (value.isNotEmpty &&
                                              !value
                                                  .toString()
                                                  .isValidEmail()) {
                                            return 'Veuillez saisir une adresse e-mail valide.';
                                          }

                                          return null;
                                        },
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
                                        onSaved: (value) => {
                                          this.model.password = value,
                                        },
                                        validator: (value) {
                                          if (value.toString().isEmpty) {
                                            return 'Veuillez entrer le mot de passe.';
                                          }

                                          return null;
                                        },
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
                            1.3,
                            ButtonTheme(
                              minWidth: 250,
                              height: 50,
                              child: RaisedButton(
                                onPressed: () {
                                  if (validateAndSave()) {
                                    print(model.toJson());
                                    setState(() {
                                      isApiCallProcess = true;
                                    });

                                    apiService.createCustomer(model).then(
                                      (ret) {
                                        setState(() {
                                          isApiCallProcess = false;
                                        });

                                        if (ret) {
                                          FormHelper.showMessage(
                                            context,
                                            "Raysel Shop",
                                            "Inscription réussie",
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
                                          FormHelper.showMessage(
                                            context,
                                            "Raysel Shop",
                                            "Email  déjà enregistré.",
                                            "Ok",
                                            () {
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        }
                                      },
                                    );
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                color: Color(0xff2ba9e1),
                                child: Text(
                                  "S'inscrire",
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
                            1.4,
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "Annuler",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FadeAnimation(
                        1.5,
                        Text(
                          "S'inscrire",
                          style: TextStyle(color: Colors.white, fontSize: 40),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    FadeAnimation(
                        1.6,
                        Text(
                          "Bienvenu chez Raysel Shop",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        )),
                  ],
                ),
              ),
            ],
          ),
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
