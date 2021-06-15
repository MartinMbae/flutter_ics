import 'dart:convert';
import 'dart:ui';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_ics/fragments/logged_in_home_screen.dart';
import 'package:flutter_ics/models/booked_event.dart';
import 'package:flutter_ics/navigation_home_screen.dart';
import 'package:flutter_ics/utils/custom_methods.dart';
import 'package:http/http.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ics/utils/shared_pref.dart';

class UnBookEvent extends StatefulWidget {


  final BookedEvent bookedEvent;

  const UnBookEvent({Key key, @required this.bookedEvent}) : super(key: key);

  @override
  _UnBookEventState createState() => _UnBookEventState();
}

class _UnBookEventState extends State<UnBookEvent> {


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
                Text("UnBook Event", style: TextStyle(decoration: TextDecoration.underline, color: primaryColor, fontSize: 15),),

                SizedBox(
                  height: 30,
                ),

                Text(widget.bookedEvent.title, style: TextStyle(decoration: TextDecoration.underline, color: primaryColor, fontSize: 16), textAlign: TextAlign.center,),

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
                          "UnBook This Event",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12),
                        ),
                        onPressed: () async {
                          if (formKey.currentState.validate()) {
                            String booked_event_id = widget.bookedEvent.id;
                            unBookEventAction(booked_event_id,context);

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


  Future<void> unBookEventAction(
      String bookedEventId,
      BuildContext context) async {
    _progressDialog.show();

    String url = Constants.baseUrl + 'events/unbookevent/$bookedEventId';

    print(url);

    Response response;
    try {
      response = await http.delete(Uri.parse(url),
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
      print(response.body);
        List<dynamic> responseMessage = jsonDecode(response.body);
        print(responseMessage[0]);
      navigateToPageRemoveHistory(context,  NavigationHomeScreen(
        loggedIn: true,
      ));
      SuccessAlertBox(
          context: context, messageText: responseMessage[0], title: "Success");

    } else {
      DangerAlertBox(
          context: context,
          messageText: "Something went wrong. Please try again.",
          title: "Error");
    }
  }
}
