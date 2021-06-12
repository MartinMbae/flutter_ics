import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_ics/homepage/cs_list_view.dart';
import 'package:flutter_ics/models/cs_directory.dart';
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
      body: getCsDirectoryBody(),
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
        color: Colors.grey[300],
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.only(bottom: 20),
                controller: scrollController,
                shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                itemBuilder: (c, i) {
                  return  CsListView(
                    csData: CsDirectory.fromJson(initialCsList[i]),
                  );
                },
                itemCount: initialCsList.length, separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(height: 10,);
              },
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
      var initialUrl = Constants.baseUrl + "users/4/0";
    var response = await http.get(Uri.parse(url ?? initialUrl));
    if (response == null) {
      throw new Exception('Error fetching CS Directories');
    }
    if (response.statusCode != 200) {
      throw new Exception('Error fetching CS Directories');
    }
    print(response.body);
    List<dynamic> events = jsonDecode(response.body);
    return events;
  }

  getApi(int start) {
    final mainUrl = Constants.baseUrl + "users/4/";
    return mainUrl + start.toString();
  }
}



