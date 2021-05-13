import 'package:flutter/material.dart';
import 'package:flutter_ics/app_theme.dart';
import 'package:flutter_ics/custom_drawer/drawer_user_controller.dart';
import 'package:flutter_ics/custom_drawer/home_drawer.dart';
import 'package:flutter_ics/fragments/careers.dart';
import 'package:flutter_ics/fragments/contact_us_page.dart';
import 'package:flutter_ics/fragments/cs_directory_page.dart';
import 'package:flutter_ics/fragments/download_categories.dart';
import 'package:flutter_ics/fragments/guest_home_screen.dart';
import 'package:flutter_ics/fragments/logged_in_home_screen.dart';
import 'package:flutter_ics/fragments/profile.dart';
import 'package:flutter_ics/fragments/update_password.dart';

import 'fragments/resource_center_page.dart';

class NavigationHomeScreen extends StatefulWidget {
  final bool loggedIn;

  const NavigationHomeScreen({Key key, @required this.loggedIn})
      : super(key: key);

  @override
  _NavigationHomeScreenState createState() => _NavigationHomeScreenState();
}

class _NavigationHomeScreenState extends State<NavigationHomeScreen> {
  Widget screenView;
  DrawerIndex drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = GuestHome();
    super.initState();
    getLogged();
  }

  Future<void> getLogged() {
    setState(() {
      if (widget.loggedIn) {
        screenView = LoggedInHomePage();
      } else {
        screenView = GuestHome();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.nearlyWhite,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          backgroundColor: AppTheme.nearlyWhite,
          body: DrawerUserController(
            isLoggedIn: widget.loggedIn,
            screenIndex: drawerIndex,
            drawerWidth: MediaQuery.of(context).size.width * 0.75,
            onDrawerCall: (DrawerIndex drawerIndexdata) {
              changeIndex(drawerIndexdata);
            },
            screenView: screenView,
            //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;

      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            if (widget.loggedIn) {
              screenView = LoggedInHomePage();
            } else {
              screenView = GuestHome();
            }
          });
          break;
        case DrawerIndex.CAREERS:
          setState(() {
            screenView = CareersPage();
          });
          break;
        case DrawerIndex.CS_DIRECTORY:
          setState(() {
            screenView = CsDirectoryPage();
          });
          break;
        case DrawerIndex.RESOURCE_CENTER:
          setState(() {
            screenView = DownloadsCategoryPage();
          });
          break;
        case DrawerIndex.CONTACT_US:
          setState(() {
            screenView = ContactUsPage();
          });
          break;
        case DrawerIndex.PROFILE:
          setState(() {
            screenView = ProfilePage();
          });
          break;
        case DrawerIndex.CHANGE_PASSWORD:
          setState(() {
            screenView = UpdatePassword();
          });
          break;
      }
    }
  }
}
