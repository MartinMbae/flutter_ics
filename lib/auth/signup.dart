import 'dart:convert';
import 'dart:io';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:async/async.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ics/auth/components/header.dart';
import 'package:flutter_ics/auth/login.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:flutter_ics/utils/custom_methods.dart';
import 'package:image_picker_widget/enum/image_picker_widget_shape.dart';
import 'package:image_picker_widget/image_picker_widget.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> formKey = GlobalKey();

  ArsProgressDialog _progressDialog;

  int _radioValue_cs_fcs = -1;
  int gender_value = -1;
  String genderString = "";
  String csFCString = "";

  String practiceCenter, branch;

  TextEditingController fnameController = new TextEditingController();
  TextEditingController lnameController = new TextEditingController();
  TextEditingController usernameController = new TextEditingController();
  TextEditingController membershipNumberController =
      new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController postalCodeController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController townController = new TextEditingController();
  TextEditingController biographyController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  DateTime _selectedDate;
  TextEditingController dateController = TextEditingController();

  File resume;
  File profile_photo;

  // String path;

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
    // updatePath();
  }

  // Future<void> updatePath() async{
  //   path = await FlutterAbsolutePath.getAbsolutePath("assets/images/logo.png");
  // }

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
                  controller: membershipNumberController,
                  cursorColor: primaryColorLight,
                  decoration: InputDecoration(
                      labelText: "Membership Number",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.confirmation_number_rounded,
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CS(K) / FCS(K)",
                    style: TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        activeColor: primaryColor,
                        value: 0,
                        groupValue: _radioValue_cs_fcs,
                        onChanged: (value) {
                          setState(() {
                            _radioValue_cs_fcs = value;
                            csFCString = "CS";
                          });
                        },
                      ),
                      Text(
                        'CS',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Radio(
                        activeColor: primaryColor,
                        value: 1,
                        groupValue: _radioValue_cs_fcs,
                        onChanged: (value) {
                          setState(() {
                            _radioValue_cs_fcs = value;
                            csFCString = "FCS";
                          });
                        },
                      ),
                      Text(
                        'FCS',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  controller: fnameController,
                  cursorColor: primaryColorLight,
                  decoration: InputDecoration(
                      labelText: "First Name",
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
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  controller: lnameController,
                  cursorColor: primaryColorLight,
                  decoration: InputDecoration(
                      labelText: "Last Name",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.person_pin,
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
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  controller: usernameController,
                  cursorColor: primaryColorLight,
                  decoration: InputDecoration(
                      labelText: "Username",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.person_pin_rounded,
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
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select Gender",
                    style: TextStyle(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.start,
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Radio(
                        activeColor: primaryColor,
                        value: 0,
                        groupValue: gender_value,
                        onChanged: (value) {
                          setState(() {
                            gender_value = value;
                            genderString = "Male";
                          });
                        },
                      ),
                      Text(
                        'Male',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      Radio(
                        activeColor: primaryColor,
                        value: 1,
                        groupValue: gender_value,
                        onChanged: (value) {
                          setState(() {
                            gender_value = value;
                            genderString = "Female";
                          });
                        },
                      ),
                      Text(
                        'Female',
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  controller: emailController,
                  cursorColor: primaryColorLight,
                  decoration: InputDecoration(
                      labelText: "Email",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.alternate_email,
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
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  controller: phoneController,
                  cursorColor: primaryColorLight,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                      labelText: "Mobile Phone",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.phone,
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
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  cursorColor: primaryColorLight,
                  decoration: InputDecoration(
                      labelText: "Select Date of Birth",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.calendar_today_outlined,
                          color: primaryColor,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                  focusNode: AlwaysDisabledFocusNode(),
                  controller: dateController,
                  onTap: () {
                    print("Tapped");
                    _selectDate(context);
                  },
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
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  controller: postalCodeController,
                  cursorColor: primaryColorLight,
                  decoration: InputDecoration(
                      labelText: "Postal Code",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.location_on_outlined,
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
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  controller: townController,
                  cursorColor: primaryColorLight,
                  decoration: InputDecoration(
                      labelText: "City/Town",
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
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  controller: addressController,
                  cursorColor: primaryColorLight,
                  minLines: 2,
                  maxLines: 3,
                  decoration: InputDecoration(
                      labelText: "Address",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.location_on,
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
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  controller: biographyController,
                  cursorColor: primaryColorLight,
                  minLines: 3,
                  maxLines: 5,
                  decoration: InputDecoration(
                      labelText: "Biography",
                      hintText:
                          "Please tell us a bit more about yourself. This should be a Career Objective Statement.",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.library_books_outlined,
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
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DropDownFormField(
                titleText: 'Practice Sector',
                hintText: 'Select your Practice center',
                value: practiceCenter,
                onSaved: (value) {
                  setState(() {
                    practiceCenter = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    practiceCenter = value;
                  });
                },
                dataSource: [
                  {
                    "value": "CS Firm",
                  },
                  {
                    "value": "Law Firm",
                  },
                  {
                    "value": "Public Sector",
                  },
                  {
                    "value": "Private Sector",
                  },
                  {
                    "value": "Public Benefit Organisation",
                  },
                  {
                    "value": "Religious Organisation",
                  },
                ],
                textField: 'value',
                valueField: 'value',
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Updated Resume",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  resume == null
                      ? RaisedButton(
                          onPressed: () async {
                            FilePickerResult result =
                                await FilePicker.platform.pickFiles(
                              type: FileType.custom,
                              allowedExtensions: ['pdf'],
                            );
                            if (result != null) {
                              File file = File(result.files.single.path);
                              setState(() {
                                resume = file;
                              });
                            }
                          },
                          child: Text("Upload your resume (PDF Format)"))
                      : Text(resume.path),
                ],
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Column(
                  children: [
                    Text(
                      "Profile Picture",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ImagePickerWidget(
                      diameter: 180,
                      initialImage: File('assets/images/profile-placeholder.png'),
                      shape: ImagePickerWidgetShape.circle,
                      isEditable: true,
                      onChange: (File file) {
                        setState(() {
                          profile_photo = file;
                        });
                      },
                    ),
                  ],
                )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: DropDownFormField(
                titleText: 'Branch',
                hintText: 'Select your branch',
                value: branch,
                onSaved: (value) {
                  setState(() {
                    branch = value;
                  });
                },
                onChanged: (value) {
                  setState(() {
                    branch = value;
                  });
                },
                dataSource: [
                  {
                    "value": "Nairobi",
                  },
                  {
                    "value": "Coast",
                  },
                  {
                    "value": "Eastern",
                  },
                  {
                    "value": "North Rift",
                  },
                  {
                    "value": "South Rift",
                  },
                  {
                    "value": "Western",
                  },
                  {
                    "value": "Central",
                  },
                  {
                    "value": "Diaspora",
                  },
                ],
                textField: 'value',
                valueField: 'value',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  controller: passwordController,
                  cursorColor: primaryColorLight,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.lock_outline,
                          color: primaryColor,
                        ),
                      ),
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 13)),

                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: TextFormField(
                  controller: confirmPasswordController,
                  cursorColor: primaryColorLight,
                  obscureText: true,
                  decoration: InputDecoration(
                      labelText: "Confirm Password",
                      prefixIcon: Material(
                        elevation: 0,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        child: Icon(
                          Icons.lock_outline,
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
                    } else if (value != passwordController.text) {
                      return "Passwords failed to match";
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
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                      color: primaryColor),
                  child: FlatButton(
                    child: Text(
                      "Sign Up",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                    onPressed: () async {
                      if (formKey.currentState.validate()) {
                        print('signing Up');
                        registerUser(
                            fnameController.text,
                            lnameController.text,
                            usernameController.text,
                            emailController.text,
                            passwordController.text,
                            membershipNumberController.text,
                            "_",
                            genderString,
                            dateController.text,
                            postalCodeController.text,
                            townController.text,
                            addressController.text,
                            biographyController.text,
                            practiceCenter,
                            branch,
                            resume,
                            profile_photo,
                            context);
                      }
                    },
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Already have an Account? ",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 12,
                      fontWeight: FontWeight.normal),
                ),
                GestureDetector(
                  onTap: () async {
                    await navigateToPage(context, LoginPage());
                  },
                  child: Text("Login",
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

  _selectDate(BuildContext context) async {
    DateTime newSelectedDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate != null ? _selectedDate : DateTime.parse("1980-01-01"),
        firstDate: DateTime(1960),
        lastDate: DateTime(2003),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.dark().copyWith(
              colorScheme: ColorScheme.dark(
                primary: primaryColorDark,
                onPrimary: Colors.white,
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              dialogBackgroundColor: primaryColorLight,
            ),
            child: child,
          );
        });

    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      final f = new DateFormat('yyyy/MM/dd');
      dateController
        ..text = f.format(_selectedDate)
        ..selection = TextSelection.fromPosition(TextPosition(
            offset: dateController.text.length,
            affinity: TextAffinity.upstream));
    }
  }

  Future<void> registerUser(
      String fname,
      String lname,
      String username,
      String email,
      String password,
      String membership_no,
      String category,
      String gender,
      String dob,
      String postal_code,
      String town,
      String address,
      String biography,
      String practice_sector,
      String branch,
      File resume,
      File photo,
      BuildContext context) async {
    DateTime now = DateTime.now();
    String todayDate = DateFormat('yyyy/MM/dd').format(now);

    String url = Constants.baseUrl + 'users/register';

    if (branch == null) {

      Fluttertoast.showToast(
          msg: "Please select a your branch",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    }

    if (photo == null) {

      Fluttertoast.showToast(
          msg: "Please select a profile photo",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    }

    if (resume == null) {
      Fluttertoast.showToast(
          msg: "Please upload your resume",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          textColor: Colors.white,
          fontSize: 16.0
      );
      return;
    }


    _progressDialog.show();

    var photoStream =
        new http.ByteStream(DelegatingStream.typed(photo.openRead()));
    var photoLength = await photo.length();

    var resumeStream =
        new http.ByteStream(DelegatingStream.typed(resume.openRead()));
    var resumeLength = await resume.length();

    var uri = Uri.parse(url);
    var request = new http.MultipartRequest("POST", uri);
    request.fields['fname'] = fname;
    request.fields['lname'] = lname;
    request.fields['username'] = username;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['membership_no'] = membership_no;
    request.fields['category'] = category;
    request.fields['gender'] = gender;
    request.fields['dob'] = dob;
    request.fields['postal_code'] = postal_code;
    request.fields['town'] = town;
    request.fields['address'] = address;
    request.fields['biography'] = biography;
    request.fields['practice_sector'] = practice_sector;
    request.fields['branch'] = branch;
    request.fields['registerDate'] = todayDate;
    request.fields['lastvisitDate'] = todayDate;


    var photoFile = new http.MultipartFile(
      'photo',
      photoStream,
      photoLength,
      filename: basename(photo.path),
    );

    var resumeFile = new http.MultipartFile(
      'resume',
      resumeStream,
      resumeLength,
      filename: basename(resume.path),
    );

    request.files.add(photoFile);
    request.files.add(resumeFile);

    var response = await request.send();
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
      response.stream.transform(utf8.decoder).listen((value) {
        Map<String, dynamic> responseMessage = jsonDecode(value);
        print(value);
        if (responseMessage.containsKey("status")) {
          bool success = responseMessage['status'];
          String message = responseMessage['message'];
          if (success) {
            navigateToPageRemoveHistory(context, LoginPage());
            SuccessAlertBox(
                context: context, messageText: message+" Login in with your account details", title: "Success");
          } else {
            String message = responseMessage['message'];
            DangerAlertBox(
                context: context, messageText: message, title: "Error");
          }
        }
      });
    } else {
      response.stream.transform(utf8.decoder).listen((value) {
        print("*********************");
        print(value);
        print("*********************");
      });
      DangerAlertBox(
          context: context,
          messageText: "Something went wrong. Please try again.",
          title: "Error");
    }
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
