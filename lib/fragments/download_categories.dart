import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_ics/fragments/resource_center_page.dart';
import 'package:flutter_ics/models/categories.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:flutter_ics/utils/custom_methods.dart';
import 'package:http/http.dart' as http;

class DownloadsCategoryPage extends StatefulWidget {
  const DownloadsCategoryPage({Key key}) : super(key: key);

  @override
  _DownloadsCategoryPageState createState() => _DownloadsCategoryPageState();
}

class _DownloadsCategoryPageState extends State<DownloadsCategoryPage> with TickerProviderStateMixin {

  Future<List<dynamic>> fetchDownloadCategories() async {
    String url = Constants.baseUrl + 'downloads/categories';
    var response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));

    if (response == null) {
      throw new Exception('Error fetching categories');
    }
    if (response.statusCode != 200) {
      throw new Exception('Error fetching categories');
    }

    List<dynamic> events = jsonDecode(response.body);
    return events;
  }

  AnimationController animationController;
  final ScrollController _scrollController = ScrollController();
  bool multiple = true;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteFaded,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Select Category"),
        elevation: 0,
      ),
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child:  Container(
                child: FutureBuilder(
                  future: fetchDownloadCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<dynamic> eventsList = snapshot.data;
                      if (eventsList.length == 0) {
                        return Text("No Category found at the moment.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red),
                        );
                      } else {
                        return ListView.builder(
                          padding: EdgeInsets.only(right: 20),
                          itemCount: eventsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            DownloadsCategory category = DownloadsCategory.fromJson(eventsList[index]);
                            animationController.forward();
                            return ListTile(
                              title: Text(category.title),
                              onTap: (){
                                navigateToPage(context, ResourceCenterPage(downloadCategory: category,));
                              },
                            );
                          },
                        );
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}


class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
      this.searchUI,
      );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}