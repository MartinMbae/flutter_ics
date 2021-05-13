import 'package:flutter/material.dart';
import 'package:flutter_ics/auth/signup.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/custom_methods.dart';

class CareersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Careers"),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 30,),
              Text("Get to know when we have a new job for you.", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20, decoration: TextDecoration.underline),textAlign: TextAlign.center,),
              SizedBox(height: 20,),
              Text("We assist candidates like yourself to get employed by some of the best employers in Kenya and foreign companies looking to do business in Kenya.",  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
              SizedBox(height: 20,),
              Text("Register your CV Details with Us to get notified of such opportunities.",  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
              SizedBox(height: 20,),
              RaisedButton(
                color: primaryColor,
                onPressed: () async{
                  await navigateToPage(context, SignUpPage());
                },
                child: Text("Register Now", style: TextStyle(color: Colors.white),),
              )
            ],
          ),
        ),
      ),
    );
  }
}
