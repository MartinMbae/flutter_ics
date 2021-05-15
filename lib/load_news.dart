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
  List<dynamic> initialNews;
  var scrollController = ScrollController();
  bool updating = false;
  
  @override
  void initState() {
    super.initState();
    getNews();
  }


  getNews() async {
    initialNews = await NewsApiHelper().fetchNews();
    setState(() {});
  }

  checkUpdate() async {
    setState(() {
      updating = true;
    });
    var scrollpositin = scrollController.position;
    if (scrollpositin.pixels == scrollpositin.maxScrollExtent) {
      var newapi = NewsApiHelper().getApi(initialNews.length);
      List<dynamic> newIcsNews = await  NewsApiHelper().fetchNews(newapi);
      initialNews.addAll(newIcsNews);
    }
    setState(() {
      updating = false;
    });
  }


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
          getNewsBody()
        ],
      ),
    );
  }

  getNewsBody() {
    if (initialNews == null) return Center(child: CircularProgressIndicator());
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
                shrinkWrap: true,
                controller: scrollController,
                // physics: BouncingScrollPhysics(),
                itemBuilder: (c, i) {
                  return  SingleNew(
                    callback: (){},
                    icsNewsItem:  IcsNewsItem.fromJson(initialNews[i]),
                  );
                },
                itemCount: initialNews.length,
              ),
            ),
            if (updating) CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}

class NewsApiHelper {
    Future<List<dynamic>> fetchNews([String url]) async {
      var initialUrl = Constants.baseUrl + "news/10/0";
    var response = await http.get(Uri.parse(url ?? initialUrl));
    if (response == null) {
      throw new Exception('Error fetching news');
    }
    if (response.statusCode != 200) {
      throw new Exception('Error fetching news');
    }
    List<dynamic> events = jsonDecode(response.body);
    return events;
  }

  getApi(int start) {
    final mainUrl = Constants.baseUrl + "news/10/";
    return mainUrl + start.toString() ;
  }
}



