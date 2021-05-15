import 'dart:convert';
import 'dart:ui';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_ics/fragments/logged_in_home_screen.dart';
import 'package:flutter_ics/navigation_home_screen.dart';
import 'package:flutter_ics/utils/custom_methods.dart';
import 'package:http/http.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ics/utils/shared_pref.dart';

class BookEvent extends StatefulWidget {


  final eventId,eventTitle,eventPrice;

  const BookEvent({Key key, @required this.eventId, @required  this.eventTitle, @required  this.eventPrice}) : super(key: key);

  @override
  _BookEventState createState() => _BookEventState();
}

class _BookEventState extends State<BookEvent> {


  ArsProgressDialog _progressDialog;
  TextEditingController organizationController = new TextEditingController();

  GlobalKey<FormState> formKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {

    _progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));


    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Form(
            key: formKey,
            child: Column(
              children: [

                SizedBox(
                  height: 30,
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundImage:  AssetImage("assets/images/app_logo.png"),
                ),
                SizedBox(
                  height: 5,
                ),
                Text("Book Event", style: TextStyle(decoration: TextDecoration.underline, color: primaryColor, fontSize: 15),),

                SizedBox(
                  height: 30,
                ),

                Text(widget.eventTitle, style: TextStyle(decoration: TextDecoration.underline, color: primaryColor, fontSize: 16), textAlign: TextAlign.center,),

                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    child: TextFormField(
                      controller: organizationController,
                      cursorColor: primaryColorLight,
                      decoration: InputDecoration(
                          labelText: "Your Organization",
                          prefixIcon: Material(
                            elevation: 0,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            child: Icon(
                              Icons.business_outlined,
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
                  height: 30,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: primaryColor),
                      child: FlatButton(
                        child: Text(
                          "Book This Event",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12),
                        ),
                        onPressed: () async {
                          if (formKey.currentState.validate()) {
                            String userId = await getUserId();
                            String groupId = "0";
                            String fullName = await getName();
                            String organization  = organizationController.text;
                            String city = "0";
                            String state = "0";
                            String country = "0";
                            String zip = "0";
                            String phone = await getPhoneNumber();
                            String email = await getEmail();

                            bookEvent(widget.eventId,userId, groupId,fullName, organization, city, state,country, zip, phone,email,context);

                          }
                        },
                      ),

                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Future<void> bookEvent(
      String event_id,
      String user_id,
      String group_id,
      String fullName,
      String organization,
      String city,
      String state,
      String country,
      String zip,
      String phone,
      String email,
      BuildContext context) async {
    _progressDialog.show();

    String url = Constants.baseUrl + 'events/booking';

    print(url);


    var map = <String, String>{
      'event_id' : event_id,
      'user_id': user_id,
      'group_id': group_id,
      'first_name': fullName.split(' ')[0],
      'last_name': fullName.split(' ')[1],
      'organization': organization,
      'city': city,
      'state': state,
      'country': country,
      'zip': zip,
      'phone': "$phone",
      'email': email,
    };
    print(map);

    Response response;
    try {
      response = await http.post(Uri.parse(url), body:
       map

      ).timeout(Duration(seconds: 20), onTimeout: () {
        return null;
      });
    }catch(e) {
      print("Erorrr is ${e.toString()}");
      response = null;
    }

    _progressDialog.dismiss(); //close dialog


    print(response.toString());
    print("...................");
    print(response.statusCode);
    if (response == null) {
      DangerAlertBox(
          context: context,
          messageText:
          "Page took so long to load. Check your internet access and try again.",
          title: "Error");
    } else if (response.statusCode == 200) {
        Map<String, dynamic> responseMessage = jsonDecode(response.body);
        print(response.body);
        if (responseMessage.containsKey("status")) {
          bool success = responseMessage['status'];
          String message = responseMessage['message'];
          if (success) {
            navigateToPageRemoveHistory(context,  NavigationHomeScreen(
              loggedIn: true,
            ));
            SuccessAlertBox(
                context: context, messageText: message, title: "Success");
          } else {
            String message = responseMessage['message'];
            DangerAlertBox(
                context: context, messageText: message, title: "Error");
          }
        }
    } else {
      DangerAlertBox(
          context: context,
          messageText: "Something went wrong. Please try again.",
          title: "Error");
    }
  }
}
