import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ics/empty_screen.dart';
import 'package:flutter_ics/models/categories.dart';
import 'package:flutter_ics/models/category_downloads.dart';
import 'package:flutter_ics/resource_list_view.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class ResourceCenterPage extends StatefulWidget {

  final DownloadsCategory downloadCategory;

  const ResourceCenterPage({Key key, @required this.downloadCategory}) : super(key: key);

  @override
  _ResourceCenterPageState createState() => _ResourceCenterPageState();
}

class _ResourceCenterPageState extends State<ResourceCenterPage> with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }



  Future<List<dynamic>> fetchResources() async {
    String url = Constants.baseUrl + "downloads/${widget.downloadCategory.id}";

    var response =
    await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));

    if (response == null) {
      throw new Exception('Error fetching resources');
    }
    if (response.statusCode != 200) {
      throw new Exception('Error fetching resources');
    }

    List<dynamic> events = jsonDecode(response.body);
    return events;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resource Center"),
        centerTitle: true,
      ),
      body:  Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.only(bottom: 30),
        child: FutureBuilder(
          future: fetchResources(),
          builder:(context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> eventsList = snapshot.data;
              if(eventsList.length == 0){
                return EmptyPage(icon: FontAwesomeIcons.sadTear, message: "No resource item found at the moment. Try again later", height: 400.0,);
              }
             return ListView.separated(
               shrinkWrap: true,
               itemCount: eventsList.length,
               scrollDirection: Axis.vertical,
               itemBuilder: (BuildContext context, int index) {
                 final int count = eventsList.length;
                 final Animation<double> animation =
                 Tween<double>(begin: 0.0, end: 1.0).animate(
                     CurvedAnimation(
                         parent: animationController,
                         curve: Interval((1 / count) * index, 1.0,
                             curve: Curves.fastOutSlowIn)));
                 animationController.forward();
                 return ResourceListView(
                   animation: animation,
                   animationController: animationController,
                   resource: CategoryDownload.fromJson(eventsList[index]),
                 );
               }, separatorBuilder: (BuildContext context, int index) {
                 return SizedBox(height: 10,);
             },
             );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

