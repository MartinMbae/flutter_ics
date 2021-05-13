import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ics/models/news.dart';
import 'package:flutter_ics/news_single.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:http/http.dart' as http;

class LoadIcsNews extends StatefulWidget {
  @override
  _LoadIcsNewsState createState() => _LoadIcsNewsState();
}

class _LoadIcsNewsState extends State<LoadIcsNews> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
            child: Text(
              'News',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                letterSpacing: 0.27,
                color: darkerText,
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          FutureBuilder(builder: (context, snapshot){
            if(snapshot.hasData){
              List<dynamic> newsList = snapshot.data as List;
              if (newsList.length == 0) {
                return Text("No news found at the moment. Try again later",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                );
              } else {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                    itemCount: newsList.length,
                    padding: const EdgeInsets.only(top: 8, bottom: 30),
                    scrollDirection: Axis.vertical,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return SingleNew(
                        callback: (){},
                        icsNewsItem:  IcsNewsItem.fromJson(newsList[index]),
                      );
                    },
                  ),
                  ],
                );
              }
            }else if(snapshot.hasError){
              return Container(
                child: Text("An error occurred while processing your data. Please check your internet and try again.", textAlign: TextAlign.center,),
              );
            }else{
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
            }
          }, future: fetchNews(),)
        ],
      ),
    );
  }
  Future<List<dynamic>> fetchNews() async {
    String  url = Constants.baseUrl + "news";
    var response =
    await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));

    if (response == null) {
      throw new Exception('Error fetching news');
    }
    if (response.statusCode != 200) {
      throw new Exception('Error fetching news');
    }

    List<dynamic> events = jsonDecode(response.body);
    return events;
  }


}
