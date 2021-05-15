import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:http/http.dart';
import 'package:flutter_ics/auth/components/header.dart';
import 'package:flutter_ics/auth/forgot_password.dart';
import 'package:flutter_ics/auth/signup.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:flutter_ics/utils/custom_methods.dart';
import 'package:flutter_ics/utils/shared_pref.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;

import '../navigation_home_screen.dart';

class LoginPage extends StatefulWidget {
  // static final String path = "lib/src/pages/login/login7.dart";
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  ArsProgressDialog _progressDialog ;

  TextEditingController usernameController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  GlobalKey<FormState> formKey = new GlobalKey();

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));
    return Scaffold(
      backgroundColor: whiteFaded,
      body: Form(
        key: formKey,
        child: ListView(
          padding: EdgeInsets.only(bottom: 50),
          children: <Widget>[
            AuthHeader(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  controller: usernameController,
                  onChanged: (String value) {},
                  cursorColor: primaryColorLight,
                  decoration: InputDecoration(
                      hintText: "Username",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.person,
                          color: primaryColor,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                  validator: (value) {
                    value = value.trim();
                    if (value.isEmpty) {
                      return "Please fill this field";
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  obscureText: true,
                  controller: passwordController,
                  onChanged: (String value) {},
                  cursorColor: primaryColorLight,
                  decoration: InputDecoration(
                      hintText: "Password",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.lock,
                          color: primaryColor,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                  validator: (value) {
                    value = value.trim();
                    if (value.isEmpty) {
                      return "Please provide the password";
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: primaryColor),
                  child: FlatButton(
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        String username = usernameController.text;
                        String password = passwordController.text;
                        loginUser(username, password);
                      }
                    },
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            GestureDetector(
              onTap: () async {
                await navigateToPage(context, ForgotPasswordPage());
              },
              child: Center(
                child: Text(
                  "FORGOT PASSWORD ?",
                  style: TextStyle(
                      color: primaryColorLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Don't have an Account ? ",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                ),
                GestureDetector(
                  onTap: () async {
                    await navigateToPage(context, SignUpPage());
                  },
                  child: Text("Sign Up ",
                      style: TextStyle(
                          color: primaryColorLight,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          decoration: TextDecoration.underline)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> loginUser(
    String username,
    String password,
  ) async {

    _progressDialog.show();
    String url = Constants.baseUrl + 'login/login';
    Response response;
    try {
      response = await http.post(Uri.parse(url), body: {
        'username': username,
        'password': password,
      }).timeout(Duration(seconds: 20), onTimeout: () {
        return null;
      });
    }catch(ex){
      print(".....................................");
      print(ex.toString());
      print(".....................................");
      response = null;
    }
    _progressDialog.dismiss();
    if (response == null) {
      return showCustomDialog(
          context: context,
          message:
              "Page took so long to load. Check your internet access and try again.",
          alertType: CoolAlertType.error,
          confirmBtnText: "Retry",
          confirmAction: () {});
    } else if (response.statusCode != 200) {
      return showCustomDialog(
          context: context,
          message:
              "An unknown error occurred. Please check your internet and try again.",
          alertType: CoolAlertType.error,
          confirmBtnText: "Retry",
          confirmAction: () {});
    }

    print(response.body);

    Map<String, dynamic> responseAsJson = jsonDecode(response.body);
    if (responseAsJson['status'] == true) {

      //{"status":true,"message":"Login successful","user_id":"1",
      //
      // "phone":"0722204092",
      // "name":"Erastus Kiringa Gitau",
      // "email":"kegitau@gmail.com; erastuskgitau@yahoo.com",
      // "practice_number":"16","category":"7","gender":null,"dob":"0000-00-00 00:00:00",
      // "postalcode":"","town":null,"address":"P.O. Box 74635 00200",
      // "biography":"",
      // "practice_sector":null,"branch":"","photo":"https:\/\/ics.ke\/newsite\/vsoft_api\/uploads\/0506_880206_0506.jpg",
      // "resume":"https:\/\/ics.ke\/newsite\/vsoft_api\/uploads\/"}

     try{await setName(responseAsJson['name']); }catch (e){}
      // await setUsername(responseAsJson['username']);
     try{await setEmail(responseAsJson['email']); }catch (e){}
      // await setMembershipNumber(responseAsJson['membership_no']);
     try{ await setCategory(responseAsJson['category']); }catch (e){}
     try{ await setGender(responseAsJson['gender']); }catch (e){}
     try{ await setDOB(responseAsJson['dob']); }catch (e){}
     try{ await setPostalCode(responseAsJson['postal_code']); }catch (e){}
     try{  await setTown(responseAsJson['town']); }catch (e){}
     try{ await setAddress(responseAsJson['address']); }catch (e){}
     try{  await setBiography(responseAsJson['biography']); }catch (e){}
     try{  await setPracticeSector(responseAsJson['practice_sector']); }catch (e){}
     try{  await setBranch(responseAsJson['branch']); }catch (e){}
     try{ await setPhoto(responseAsJson['photo']); }catch (e){}
     try{   await setResume(responseAsJson['resume']); }catch (e){}
     try{ await setUserId(responseAsJson['user_id']); }catch (e){}
     try{ await setPhoneNumber(responseAsJson['phone']); }catch (e){}

      navigateToPageRemoveHistory(
          context,
          NavigationHomeScreen(
            loggedIn: true,
          ));
    } else {
      DangerAlertBox(
        context: context,
        messageText: responseAsJson['message'],
        title: 'Error!!'
      );

    }
  }
}
