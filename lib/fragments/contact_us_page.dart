import 'package:flutter/services.dart';
import 'package:flutter_ics/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ics/utils/app_colors.dart';

class ContactUsPage extends StatefulWidget {
  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {

  GlobalKey<FormState> formKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          appBar: AppBar(
            title: Text("Contact Us"),
            centerTitle: true,
          ),
          body: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical:16.0, horizontal: 20),
              child: Form(
                key: formKey,
                child: ListView(
                  padding: EdgeInsets.only(bottom: 30),
                  children: <Widget>[
                    Text(
                      'Talk to Us',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                   SizedBox(
                     height: 20,
                   ),
                   TextFormField(
                     decoration: InputDecoration(
                       border: OutlineInputBorder(),
                       labelText: "Your name",
                     ),
                     validator: (value){
                       value = value.trim();
                       if(value.isEmpty){
                         return "Please fill this value";
                       }
                       return null;
                     },
                   ),
                    SizedBox(
                      height: 20,
                    ),
                   TextFormField(
                     decoration: InputDecoration(
                       border: OutlineInputBorder(),
                       labelText: "Your Email Address",
                     ),
                     validator: (value){
                       value = value.trim();
                       if(value.isEmpty){
                         return "Please fill this value";
                       }
                       return null;
                     },
                   ),
                    SizedBox(
                      height: 20,
                    ),
                   TextFormField(
                     decoration: InputDecoration(
                       border: OutlineInputBorder(),
                       labelText: "Your Phone Number",
                     ),
                     inputFormatters: [
                       FilteringTextInputFormatter.digitsOnly
                     ],
                     maxLength: 10,
                     keyboardType: TextInputType.phone,
                     validator: (value){
                       value = value.trim();
                       if(value.isEmpty){
                         return "Please fill this value";
                       }
                       return null;
                     },
                   ),
                    SizedBox(
                      height: 20,
                    ),
                   TextFormField(
                     decoration: InputDecoration(
                       border: OutlineInputBorder(),
                       labelText: "Subject",
                     ),
                     validator: (value){
                       value = value.trim();
                       if(value.isEmpty){
                         return "Please fill this value";
                       }
                       return null;
                     },
                   ),
                    SizedBox(
                      height: 20,
                    ),
                   TextFormField(
                     decoration: InputDecoration(
                       border: OutlineInputBorder(),
                       labelText: "Message",
                     ),
                     maxLines: 6,
                     minLines: 4,
                     maxLength: 100,
                     validator: (value){
                       value = value.trim();
                       if(value.isEmpty){
                         return "Please fill this value";
                       }
                       return null;
                     },
                   ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton.icon(
                        onPressed: (){
                          if(formKey.currentState.validate()){

                          }
                        },
                        color: primaryColor, textColor: Colors.white ,icon: Icon(Icons.send), label: Text("Send".toUpperCase())),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 32, right: 32),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.grey.withOpacity(0.8),
                offset: const Offset(4, 4),
                blurRadius: 8),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.all(4.0),
            constraints: const BoxConstraints(minHeight: 80, maxHeight: 160),
            color: AppTheme.white,
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 0),
              child: TextField(
                maxLines: null,
                onChanged: (String txt) {},
                style: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontSize: 16,
                  color: AppTheme.dark_grey,
                ),
                cursorColor: Colors.blue,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your feedback...'),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
