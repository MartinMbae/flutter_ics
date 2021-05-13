import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ics/homepage/cs_list_view.dart';
import 'package:flutter_ics/models/cs_directory.dart';
import 'package:flutter_ics/models/news.dart';
import 'package:flutter_ics/news_single.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:http/http.dart' as http;

class LoadCsDirectories extends StatefulWidget {
  @override
  _LoadCsDirectoriesState createState() => _LoadCsDirectoriesState();
}

class _LoadCsDirectoriesState extends State<LoadCsDirectories> {
  List<dynamic> initialCsList;
  var scrollController = ScrollController();
  bool updating = false;
  
  @override
  void initState() {
    super.initState();
    getNews();
  }


  getNews() async {
    initialCsList = await CsDirectoryApiHelper().fetchCsList();
    setState(() {});
  }

  checkUpdate() async {
    setState(() {
      updating = true;
    });
    var scrollpositin = scrollController.position;
    if (scrollpositin.pixels == scrollpositin.maxScrollExtent) {
      var newapi = CsDirectoryApiHelper().getApi(initialCsList.length);
      List<dynamic> newCsList = await  CsDirectoryApiHelper().fetchCsList(newapi);
      initialCsList.addAll(newCsList);
    }
    setState(() {
      updating = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: getCsDirectoryBody(),
      ),
    );
  }

  getCsDirectoryBody() {
    if (initialCsList == null) return Center(child: CircularProgressIndicator());
    return NotificationListener<ScrollNotification>(
      onNotification: (noti) {
        if (noti is ScrollEndNotification) {
          checkUpdate();
        }
        return true;
      },
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                physics: BouncingScrollPhysics(),
                itemBuilder: (c, i) {
                  return  CsListView(
                    csData: CsDirectory.fromJson(initialCsList[i]),
                  );
                },
                itemCount: initialCsList.length,
              ),
            ),
            if (updating) CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}

class CsDirectoryApiHelper {
    Future<List<dynamic>> fetchCsList([String url]) async {
      print('Parsed Url is $url');
      var initialUrl = Constants.baseUrl + "users/?start=0&limit=5";
      print('initial URL is $initialUrl');
    var response = await http.get(Uri.parse(url ?? initialUrl));
    if (response == null) {
      throw new Exception('Error fetching CS Directories');
    }
    if (response.statusCode != 200) {
      throw new Exception('Error fetching CS Directories');
    }
    List<dynamic> events = jsonDecode(response.body);
    return events;
  }

  getApi(int start) {
    final mainUrl = Constants.baseUrl + "users/?start=";
    return mainUrl + start.toString() + "&limit=5";
  }
}



