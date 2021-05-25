import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ics/load_cs_directories.dart';
import 'package:flutter_ics/fragments/load_sorted_cs_directory.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_radio_group/flutter_radio_group.dart';

class CsDirectoryPage extends StatefulWidget {
  const CsDirectoryPage({Key key}) : super(key: key);

  @override
  _CsDirectoryPageState createState() => _CsDirectoryPageState();
}
enum SortingCategory { ALL, MEMBERS, GOVERNANCE_AUDITOR }

class _CsDirectoryPageState extends State<CsDirectoryPage>
    with TickerProviderStateMixin {

  AnimationController animationController;
  bool multiple = true;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  int _key;

  _collapse() {
    int newKey;
    do {
      _key = new Random().nextInt(10000);
    } while(newKey == _key);
  }
  bool loadSorted = false;
  String sortTerm = "";

  TextEditingController searchEditingController = new TextEditingController();

  var selectedCategory = 0;
  List<String> categories = ["All", "Members", "Government Auditor"];

@override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: whiteFaded,
      appBar: AppBar(
        centerTitle: true,
        title: Text("CS Directory"),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 4.0, left: 6.0, right: 6.0, bottom: 6.0),
              child: ExpansionTile(
                initiallyExpanded: false,
                key: new Key(_key.toString()),
                title: Text("Tap here to sort CS by their, name, firm or category"),
                children:[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      child: TextFormField(
                        controller: searchEditingController,
                        onChanged: (String value) {},
                        cursorColor: primaryColorLight,
                        decoration: InputDecoration(
                            hintText: "Search Name/Firm",
                            prefixIcon: Material(
                              elevation: 0,
                              borderRadius: BorderRadius.all(Radius.circular(30)),
                              child: Icon(
                                Icons.search,
                                color: primaryColor,
                              ),
                            ),
                            border: InputBorder.none,
                            contentPadding:
                            EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
                      ),
                    ),
                  ),
                  FlutterRadioGroup(
                      titles: categories,
                      labelStyle: TextStyle(color: Colors.white38),
                      labelVisible: true,
                      label: "Select Category",
                      activeColor: Colors.blue,
                      titleStyle: TextStyle(fontSize: 14),
                      defaultSelected: selectedCategory,
                      orientation: RGOrientation.VERTICAL,
                      onChanged: (index) {
                        selectedCategory = index;
                      }),
                  ElevatedButton.icon(onPressed: (){
                    print("Selected Category is ${categories[selectedCategory]}");
                    print("Search Term is ${searchEditingController.text}");
                    setState(() {
                      sortTerm = searchEditingController.text;
                      _collapse();
                      loadSorted = true;
                    });
                  },
                    label: Text("Search"),
                    icon: Icon(Icons.search),
                  )
                ],
              ),
            ),
          ),
          loadSorted ?
          Container(height: MediaQuery.of(context).size.height,child: LoadSortedCsDirectories(searchTerm: sortTerm,))
          :
          Container(height: MediaQuery.of(context).size.height,child: LoadCsDirectories())
        ],
      ),
    );
  }


  // Widget getSortingIcons() {
  //   SortingCategory selectedCategory = SortingCategory.ALL;
  //   ExpandableController expandableController = ExpandableController();
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  //     child: Container(
  //         child: ExpandablePanel(
  //           controller: expandableController,
  //           header: Text(
  //             "Sort CS", style: TextStyle(fontWeight: FontWeight.w600),
  //             textAlign: TextAlign.center,),
  //           collapsed: Text(
  //             "Tap here to sort CS by their, name, firm or category",
  //             textAlign: TextAlign.center,
  //             softWrap: true,
  //             maxLines: 2,
  //             overflow: TextOverflow.ellipsis,),
  //           expanded: Column(
  //               children: [
  //           Padding(
  //           padding: const EdgeInsets.all(8.0),
  //           child: TextFormField(
  //             controller: searchEditingController,
  //             onChanged: (String value) {},
  //             cursorColor: primaryColorLight,
  //             decoration: InputDecoration(
  //                 hintText: "Search Name/Firm",
  //                 prefixIcon: Material(
  //                   elevation: 0,
  //                   borderRadius: BorderRadius.all(Radius.circular(30)),
  //                   child: Icon(
  //                     Icons.search,
  //                     color: primaryColor,
  //                   ),
  //                 ),
  //                 border: InputBorder.none,
  //                 contentPadding:
  //                 EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
  //           ),
  //         ),
  //         Column(
  //           children: <Widget>[
  //             ListTile(
  //               title: const Text('All'),
  //               leading: Radio(
  //                 value: SortingCategory.ALL,
  //                 groupValue: selectedCategory,
  //                 onChanged: (SortingCategory value) {
  //                   setState(() {
  //                     selectedCategory = value;
  //                   });
  //                 },
  //               ),
  //             ),
  //             ListTile(
  //               title: const Text('Member'),
  //               leading: Radio(
  //                 value: SortingCategory.MEMBERS,
  //                 groupValue: selectedCategory,
  //                 onChanged: (SortingCategory value) {
  //                   setState(() {
  //                     selectedCategory = value;
  //                   });
  //                 },
  //               ),
  //             ),
  //             ListTile(
  //               title: const Text('Governance Auditor'),
  //               leading: Radio(
  //                 value: SortingCategory.GOVERNANCE_AUDITOR,
  //                 groupValue: selectedCategory,
  //                 onChanged: (SortingCategory value) {
  //                   setState(() {
  //                     selectedCategory = value;
  //                   });
  //                 },
  //               ),
  //             ),
  //           ],
  //         ),
  //
  //   ElevatedButton.icon(onPressed: (){
  //   expandableController.expanded = false;
  //   },
  //   label: Text("Search"),
  //   icon: Icon(Icons.search),
  //   )
  //   ],
  //   ),
  //   ),
  //   ),
  //   );
  // }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(this.searchUI,);

  final Widget searchUI;

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
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