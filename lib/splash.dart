import 'package:flutter/material.dart';
import 'package:flutter_ics/load_cs_directories.dart';
import 'package:flutter_ics/load_news.dart';
import 'package:flutter_ics/navigation_home_screen.dart';
import 'package:flutter_ics/pagination/paginate_test.dart';
import 'package:flutter_ics/utils/custom_methods.dart';
import 'package:flutter_ics/utils/shared_pref.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {

  Future<void> checkLoggedIn() async{
    var userId = await getUserId();
    if(userId == null){
      // navigateToPageRemoveHistory(context, LoadCsDirectories());
      navigateToPageRemoveHistory(context,  NavigationHomeScreen(
        loggedIn: false,
      ),);
      return;
    }else{
      navigateToPageRemoveHistory(context,  NavigationHomeScreen(
        loggedIn: true,
      ));
      return;
    }
  }


  @override
  void initState() {
    super.initState();
    checkLoggedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
