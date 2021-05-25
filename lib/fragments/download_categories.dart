import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_ics/empty_screen.dart';
import 'package:flutter_ics/fragments/resource_center_page.dart';
import 'package:flutter_ics/models/categories.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:flutter_ics/utils/custom_methods.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
                          return EmptyPage(icon: FontAwesomeIcons.sadTear, message: "No Category found at the moment. Try again later", height: 400.0,);
                      } else {
                        return ListView.builder(
                          padding: EdgeInsets.only(right: 20),
                          itemCount: eventsList.length,
                          itemBuilder: (BuildContext context, int index) {
                            DownloadsCategory category = DownloadsCategory.fromJson(eventsList[index]);
                            animationController.forward();
                            return ListTile(
                              leading: Container(
                                height: 60,
                                width: 60,
                                child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  child: GestureDetector(
                                      child: Hero(
                                        tag:"imageHero${category.id}",
                                        child: CachedNetworkImage(
                                          imageUrl: category.getCategoryImageLink(),
                                          placeholder: (context, url) =>
                                              Center(child: CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Center(child: Icon(Icons.error)),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) {
                                          return SingleImageScreen(
                                              tag: "imageHero${category.id}",
                                              imageUrl: category.getCategoryImageLink());
                                        }));
                                      }),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                ),
                              ),
                              title: Text(category.title),
                              subtitle: Text(''),
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


class SingleImageScreen extends StatelessWidget {
  final imageUrl, tag;

  const SingleImageScreen({Key key, @required this.imageUrl, this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Container(
          width: MediaQuery
              .of(context)
              .size
              .width,
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: Hero(
            tag: tag,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) =>
                  Center(child: Icon(Icons.error)),
            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

