import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ics/cs_list_view.dart';
import 'package:flutter_ics/models/cs_directory.dart';
import 'package:flutter_ics/models/news.dart';
import 'package:flutter_ics/news_single.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:http/http.dart' as http;

class LoadNewPreview extends StatefulWidget {
  final count;

  const LoadNewPreview({Key key, @required this.count})
      : super(key: key);

  @override
  _LoadNewPreviewState createState() =>
      _LoadNewPreviewState();
}

class _LoadNewPreviewState extends State<LoadNewPreview> {
  List<dynamic> newsList;

  fetchPreviewNews(var searchTerm) async {
    var initialUrl = Constants.baseUrl + "news/${widget.count}/0";
    var response = await http.get(Uri.parse(initialUrl));
    if (response == null) {
      throw new Exception('Error fetching News');
    }
    if (response.statusCode != 200) {
      throw new Exception('Error fetching News');
    }
    List<dynamic> events = jsonDecode(response.body);
    setState(() {
      newsList = events;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPreviewNews(widget.count);
  }

  @override
  Widget build(BuildContext context) {
    return  Container(child: getPreviewNewsBody());
  }

  getPreviewNewsBody() {
    if (newsList == null)
      return Center(child: CircularProgressIndicator());
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (c, i) {
          return  SingleNew(
            callback: (){},
            icsNewsItem:  IcsNewsItem.fromJson(newsList[i]),
          );
        },
        itemCount: newsList.length,
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 10,
          );
        },
      ),
    );
  }
}
