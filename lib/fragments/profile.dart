import 'dart:convert';

import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:http/http.dart';
import 'package:flutter_ics/fragments/update_password.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:flutter_ics/utils/custom_methods.dart';
import 'package:flutter_ics/utils/shared_pref.dart';

import '../navigation_home_screen.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String currentImageUrl,
      currentName,
      currentPostalCode,
      currentAddress,
      currentMembership,
      currentGender,
      currentEmail,
      currentUsername,
      currentPhone,
      currentBiography,
      currentTown,
      currentBranch;

  TextEditingController nameTextController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController membershipNumberController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController townCodeController = TextEditingController();
  TextEditingController addressCodeController = TextEditingController();
  TextEditingController biographyCodeController = TextEditingController();
  TextEditingController branchCodeController = TextEditingController();

  String genderValue, categoryValue;

  ArsProgressDialog progressDialog;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getLoggedInUserdetails();
    });
  }

  Future<String> getLoggedInUserdetails() async {
    String username = await getUsername();
    String name = await getName();
    String email = await getEmail();
    String membershipNumber = await getMembershipNumber();
    String gender = await getGender();
    String postalCode = await getPostalCode();
    String town = await getTown();
    String address = await getAddress();
    String biography = await getBiography();
    String practiceSector = await getPracticeSector();
    String branch = await getBranch();
    String imageUrl = await getPhoto();
    String phone = await getPhoneNumber();
    String category = await getCategory();
    setState(() {
      currentUsername = username;
      currentImageUrl = imageUrl;
      currentName = name;
      currentEmail = email;
      currentMembership = membershipNumber;
      currentGender = gender;
      currentPostalCode = postalCode;
      currentTown = town;
      currentAddress = address;
      currentBiography = biography;
      // currentPracticeSector = practiceSector;
      currentBranch = branch;
      currentPhone = phone;

      nameTextController.text = name;
      emailController.text = email;
      usernameController.text = username;
      membershipNumberController.text = membershipNumber;
      genderValue = gender;
      categoryValue = category;
      postalCodeController.text = postalCode;
      townCodeController.text = town;
      addressCodeController.text = address;
      biographyCodeController.text = biography;
      // practiceSectorValue = practiceSector;
      branchCodeController.text = branch;
      phoneController.text = phone;
    });
  }

  GlobalKey<FormState> formKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: ListView(
            children: <Widget>[
              Column(
                children: <Widget>[
                  new Container(
                    height: 250.0,
                    color: Colors.white,
                    child: new Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 20.0),
                            child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 25.0),
                                  child: new Text('PROFILE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20.0,
                                          fontFamily: 'sans-serif-light',
                                          color: Colors.black)),
                                )
                              ],
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child:
                              new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                if (currentImageUrl != null)
                                  Container(
                                    child: CachedNetworkImage(
                                      width: 140.0,
                                      height: 140.0,
                                      imageUrl: currentImageUrl,
                                      errorWidget: (context, url, error) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(
                                                'assets/images/profile-placeholder.png'),
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                        ),
                                      ),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0)),
                                        ),
                                      ),
                                      progressIndicatorBuilder: (context, url,
                                              downloadProgress) =>
                                          CircularProgressIndicator(
                                              value: downloadProgress.progress),
                                    ),
                                  ),
                              ],
                            ),
                          ]),
                        )
                      ],
                    ),
                  ),
                  new Container(
                    color: Color(0xffFFFFFF),
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 25.0),
                      child: Form(
                        key: formKey,
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Personal Information',
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Name',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextFormField(
                                        controller: nameTextController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Fill this field";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Email Address',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextFormField(
                                        controller: emailController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Fill this field";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Phone Number',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextFormField(
                                        maxLength: 10,
                                        controller: phoneController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Fill this field";
                                          } else if (value.trim().length !=
                                              10) {
                                            return "Phone Number must Contain 10 digits";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                )),

                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Membership Number',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextFormField(
                                        controller: membershipNumberController,
                                        enabled: false,
                                      ),
                                    ),
                                  ],
                                )),

                            // Padding(
                            //     padding: EdgeInsets.only(
                            //         left: 25.0, right: 25.0, top: 25.0),
                            //     child: new Row(
                            //       mainAxisSize: MainAxisSize.max,
                            //       children: <Widget>[
                            //         new Column(
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           mainAxisSize: MainAxisSize.min,
                            //           children: <Widget>[
                            //             new Text(
                            //               'Gender',
                            //               style: TextStyle(
                            //                   fontSize: 16.0,
                            //                   fontWeight: FontWeight.bold),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     )),
                            // Padding(
                            //     padding: EdgeInsets.only(
                            //         left: 25.0, right: 25.0, top: 2.0),
                            //     child: new Row(
                            //       mainAxisSize: MainAxisSize.max,
                            //       children: <Widget>[
                            //         new Flexible(
                            //           child: new DropdownButton<String>(
                            //             items: <String>['Male', 'Female'].map((String value) {
                            //               return new DropdownMenuItem<String>(
                            //                 value: value,
                            //                 child: new Text(value),
                            //               );
                            //             }).toList(),
                            //             onChanged: (newValue) {
                            //               setState(() {
                            //                 genderValue = newValue;
                            //               });
                            //             },
                            //             value: genderValue,
                            //           ),
                            //         ),
                            //       ],
                            //     )),

                            // Padding(
                            //     padding: EdgeInsets.only(
                            //         left: 25.0, right: 25.0, top: 25.0),
                            //     child: new Row(
                            //       mainAxisSize: MainAxisSize.max,
                            //       children: <Widget>[
                            //         new Column(
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           mainAxisSize: MainAxisSize.min,
                            //           children: <Widget>[
                            //             new Text(
                            //               'Category',
                            //               style: TextStyle(
                            //                   fontSize: 16.0,
                            //                   fontWeight: FontWeight.bold),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     )),
                            // Padding(
                            //     padding: EdgeInsets.only(
                            //         left: 25.0, right: 25.0, top: 2.0),
                            //     child: new Row(
                            //       mainAxisSize: MainAxisSize.max,
                            //       children: <Widget>[
                            //         new Flexible(
                            //           child: new DropdownButton<String>(
                            //             items: <String>['ICS', 'FCS'].map((String value) {
                            //               return new DropdownMenuItem<String>(
                            //                 value: value,
                            //                 child: new Text(value),
                            //               );
                            //             }).toList(),
                            //             onChanged: (newValue) {
                            //               setState(() {
                            //                 categoryValue = newValue;
                            //               });
                            //             },
                            //             value: categoryValue,
                            //           ),
                            //         ),
                            //       ],
                            //     )),

                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'PostalCode',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextFormField(
                                        controller: postalCodeController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Fill this field";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                )),

                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Town',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextFormField(
                                        controller: townCodeController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Fill this field";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                )),

                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Address',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextFormField(
                                        controller: addressCodeController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Fill this field";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                )),

                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Biography',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: new TextFormField(
                                        controller: biographyCodeController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return "Fill this field";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ],
                                )),

                            // Padding(
                            //     padding: EdgeInsets.only(
                            //         left: 25.0, right: 25.0, top: 25.0),
                            //     child: new Row(
                            //       mainAxisSize: MainAxisSize.max,
                            //       children: <Widget>[
                            //         new Column(
                            //           mainAxisAlignment: MainAxisAlignment.start,
                            //           mainAxisSize: MainAxisSize.min,
                            //           children: <Widget>[
                            //             new Text(
                            //               'Practice Sector',
                            //               style: TextStyle(
                            //                   fontSize: 16.0,
                            //                   fontWeight: FontWeight.bold),
                            //             ),
                            //           ],
                            //         ),
                            //       ],
                            //     )),
                            // Padding(
                            //     padding: EdgeInsets.only(
                            //         left: 25.0, right: 25.0, top: 2.0),
                            //     child: new Row(
                            //       mainAxisSize: MainAxisSize.max,
                            //       children: <Widget>[
                            //         new Flexible(
                            //           child:new DropdownButton<String>(
                            //             items: <String>['CS Firm', 'Law Firm', 'Public Sector', 'Private Sector', 'Public Benefit Organisation', 'Religious Organisation'].map((String value) {
                            //               return new DropdownMenuItem<String>(
                            //                 value: value,
                            //                 child: new Text(value),
                            //               );
                            //             }).toList(),
                            //             onChanged: (newValue) {
                            //               setState(() {
                            //                 practiceSectorValue = newValue;
                            //               });
                            //             },
                            //           ),
                            //         ),
                            //       ],
                            //     )),

                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25.0, right: 25.0, top: 45.0),
                              child: new Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 10.0),
                                      child: Container(
                                          child: new RaisedButton(
                                        child: new Text("Update Profile"),
                                        textColor: Colors.white,
                                        color: primaryColor,
                                        onPressed: () async {
                                          if (formKey.currentState.validate()) {
                                            String user_id = await getUserId();
                                            String name =
                                                nameTextController.text;
                                            String email = emailController.text;
                                            String phone = phoneController.text;
                                            String membershipNumber =
                                                membershipNumberController.text;
                                            String gender = genderValue;
                                            String category = categoryValue;
                                            String dob = await getDOB();
                                            String postalCode =
                                                postalCodeController.text;
                                            String town =
                                                townCodeController.text;
                                            String address =
                                                addressCodeController.text;
                                            String biography =
                                                biographyCodeController.text;
                                            String practiceSector =
                                                await getPracticeSector();
                                            String branch =
                                                branchCodeController.text;

                                            updateProfile(
                                                user_id,
                                                name,
                                                email,
                                                phone,
                                                membershipNumber,
                                                category,
                                                gender,
                                                dob,
                                                postalCode,
                                                town,
                                                address,
                                                biography,
                                                practiceSector,
                                                branch);
                                          } else {
                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        "Fill all the required fields")));
                                          }
                                        },
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    20.0)),
                                      )),
                                    ),
                                    flex: 2,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateProfile(
      String user_id,
      String name,
      String email,
      String phone,
      String membershipNumber,
      String category,
      String gender,
      String dob,
      String postalCode,
      String town,
      String address,
      String biography,
      String practiceSector,
      String branch) async {
    progressDialog.show();

    String url = Constants.baseUrl + 'users/updateprofile';

    Map<String, String> someMap = {
      "user_id": user_id,
      "name": name,
      "email": email,
      "membership_no": membershipNumber,
      "category": category,
      "gender": gender,
      "dob": dob,
      "postal_code": postalCode,
      "town": town,
      "address": address,
      "biography": biography,
      "practice_sector": practiceSector,
      "branch": branch,
    };

    Request req = Request('PUT', Uri.parse(url))
      ..body = json.encode(someMap)
      ..headers.addAll({
        "Content-type": "application/json",
      });

    var response = null;
    try {
      response = await req.send();
    } catch (Exception) {
      progressDialog.dismiss();
      DangerAlertBox(
          context: context,
          messageText: Exception.toString(),
          title: "Error while processing request");
    }
    progressDialog.dismiss();
    if (response.statusCode == 200) {
      response.stream.transform(utf8.decoder).listen((value) async {
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
          await clearAllPreferences();
          navigateToPageRemoveHistory(
            context,
            NavigationHomeScreen(
              loggedIn: false,
            ),
          );
          SuccessAlertBox(
              context: context,
              messageText: responseMessage['message'] +
                  " Login again to your account with the new details",
              title: "Success");
        }
      });
    } else {
      DangerAlertBox(
          context: context,
          messageText:
              "Unknown error occurred. Please check your internet connection and try again.",
          title: "Error");
    }
  }
}
