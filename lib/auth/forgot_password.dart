import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_ics/auth/components/header.dart';
import 'package:flutter_ics/auth/login.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/custom_methods.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {



  GlobalKey<FormState>  formKey = new GlobalKey();

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
              child: Center(child: Text("We shall send a password reset link to the email provided.", textAlign: TextAlign.center,)),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  onChanged: (String value){},
                  cursorColor: primaryColorLight,
                  decoration: InputDecoration(
                      hintText: "Email",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.email_outlined,
                          color: primaryColor,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                  validator: (value){
                    value = value.trim();
                    if(value.isEmpty){
                      return "Please fill this field";
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
                      "Request new password",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    onPressed: () async{
                      if(formKey.currentState.validate()){
                        print("Okay");
                      }
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
