import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_ics/auth/login.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:flutter_ics/utils/custom_methods.dart';
import 'package:flutter_ics/utils/shared_pref.dart';
import 'package:http/http.dart';

class UpdatePassword extends StatelessWidget {
  BuildContext mainContext;
  ArsProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    TextEditingController oldPassController = new TextEditingController();
    TextEditingController newPassController = new TextEditingController();
    TextEditingController confirmPassController = new TextEditingController();
    progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    return Scaffold(
      appBar: AppBar(
        title: Text("Update Password"),
        centerTitle: true,
      ),
      body: Builder(builder: (context) {
        mainContext = context;
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListView(
            children: [
              Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: oldPassController,
                      decoration: new InputDecoration(
                        labelText: "Provide your old password",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return "Password cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.visiblePassword,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: newPassController,
                      decoration: new InputDecoration(
                        labelText: "Provide your new password",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return "Password cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.visiblePassword,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    TextFormField(
                      controller: confirmPassController,
                      decoration: new InputDecoration(
                        labelText: "Confirm new password",
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(15.0),
                          borderSide: new BorderSide(),
                        ),
                        //fillColor: Colors.green
                      ),
                      validator: (val) {
                        if (val.length == 0) {
                          return "Password cannot be empty";
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.visiblePassword,
                      style: new TextStyle(
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color:primaryColorDark)),
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          String newPass = newPassController.text;
                          String confirmPass = confirmPassController.text;
                          String oldPass = oldPassController.text;
                          if (newPass != confirmPass) {
                            Scaffold.of(mainContext).showSnackBar(SnackBar(
                                content:
                                    Text("Your new password failed to match")));
                          } else {
                            progressDialog.show();
                            String url =  Constants.baseUrl + 'login/updatepassword';
                            var id = await getUserId();
                            Map<String, String> someMap = {
                              "id": id,
                              "old_password": oldPass,
                              "new_password": newPass,
                            };

                            Request req = Request(
                                'POST', Uri.parse(url))
                              ..body = json.encode(someMap)
                              ..headers.addAll({
                                "Content-type": "application/json",
                              });

                            var response = await req.send();
                            progressDialog.dismiss();
                            if (response.statusCode == 200) {
                              response.stream
                                  .transform(utf8.decoder)
                                  .listen((value) {
                                Map<String, dynamic> responseMessage = jsonDecode(value);
                                print(value);
                                  var status = responseMessage['status'];
                                  if (!status) {
                                    DangerAlertBox(
                                        context: context,
                                        messageText: responseMessage['message'],
                                        title: "Failed");
                                    return;
                                  } else {
                                    navigateToPageRemoveHistory(context, LoginPage());
                                    SuccessAlertBox(
                                        context: context,
                                        messageText:
                                            "Your password has been changed successfully.",
                                        title: "Success");
                                  }

                              });
                            }else{
                              DangerAlertBox(
                                  context: context,
                                  messageText:
                                  "Unknown error occurred. Please check your internet connection and try again.",
                                  title: "Error");
                            }

                          }
                        }
                      },
                      color: primaryColor,
                      textColor: Colors.white,
                      child: Text("Update".toUpperCase(),
                          style: TextStyle(fontSize: 14)),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
