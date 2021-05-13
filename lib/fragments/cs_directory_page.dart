import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:flutter_ics/homepage/cs_list_view.dart';
import 'package:flutter_ics/models/cs_directory.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:http/http.dart' as http;

class CsDirectoryPage extends StatefulWidget {
  const CsDirectoryPage({Key key}) : super(key: key);

  @override
  _CsDirectoryPageState createState() => _CsDirectoryPageState();
}

class _CsDirectoryPageState extends State<CsDirectoryPage> with TickerProviderStateMixin {

  Future<List<dynamic>> fetchDirectories() async {
    String url = Constants.baseUrl + 'users';
    var response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));

    if (response == null) {
      throw new Exception('Error fetching directories');
    }
    if (response.statusCode != 200) {
      throw new Exception('Error fetching directories');
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
        title: Text("CS Directory"),
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: NestedScrollView(
                      controller: _scrollController,
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return [
                          SliverPersistentHeader(
                            pinned: true,
                            floating: true,
                            delegate: ContestTabHeader(
                              Container(
                                color: Colors.white,
                                child: Padding(
                                  padding:
                                  EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 12),
                                  child:  Text(
                                    'CS Directory',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: primaryColor
                                    ),
                                  )
                                ),
                              ),
                            ),
                          ),
                        ];
                      },
                      body: Container(
                        child: FutureBuilder(
                          future: fetchDirectories(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<dynamic> eventsList = snapshot.data;
                              if (eventsList.length == 0) {
                                return Text("No CS Directories found at the moment.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.red),
                                );
                              } else {
                                return ListView.separated(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  itemCount: eventsList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    animationController.forward();
                                    return CsListView(
                                      csData: CsDirectory.fromJson(eventsList[index]),
                                    );
                                  },
                                  separatorBuilder: (BuildContext context, int index) {
                                    return SizedBox(height: 10,);
                                  },
                                );
                              }
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }



  Widget getSortingIcons() {
    ExpandableController expandableController = ExpandableController();
    return Padding(
      padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        child:    ExpandablePanel(
          controller: expandableController,
          header: Text("Sort CS", style: TextStyle(fontWeight: FontWeight.w600), textAlign: TextAlign.center,),
          collapsed: Text("Tap here to sort CS by their gender, practice sector or branch", textAlign: TextAlign.center, softWrap: true, maxLines: 2, overflow: TextOverflow.ellipsis,),
          expanded: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownSearch<String>(
                    mode: Mode.MENU,
                    showSelectedItem: true,
                    items: ["All", "Male", "Female"],
                    label: "Sort by gender",
                    onChanged: print,
                    selectedItem: "All"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownSearch<String>(
                    mode: Mode.MENU,
                    showSelectedItem: true,
                    items: ["All", "CS", "FCS"],
                    label: "Sort by CS/FCS",
                    onChanged: print,
                    selectedItem: "All"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownSearch<String>(
                    mode: Mode.MENU,
                    showSelectedItem: true,
                    items: ["All", "CS Firm", "Law Firm"],
                    label: "Sort by Practice Center",
                    onChanged: print,
                    selectedItem: "All"),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownSearch<String>(
                    mode: Mode.MENU,
                    showSelectedItem: true,
                    items: ["All", "Nairobi", "Mombasa"],
                    label: "Sort by branch",
                    onChanged: print,
                    selectedItem: "All"),
              ),
              RaisedButton(onPressed: (){
                expandableController.expanded = false;
              },
              color: primaryColor,
                textColor: Colors.white,
                child: Text("Sort"),
              )
            ],
          ),

        ),
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