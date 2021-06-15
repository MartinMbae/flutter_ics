import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ics/empty_screen.dart';
import 'package:flutter_ics/models/cpd_point_non_structured.dart';
import 'package:flutter_ics/models/cpd_point_structured.dart';
import 'package:flutter_ics/non_structured_points_holder.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:flutter_ics/utils/shared_pref.dart';
import 'package:http/http.dart' as http;
import 'package:table_sticky_headers/table_sticky_headers.dart';

class CpdTabLayout extends StatefulWidget {
  @override
  _CpdTabLayoutState createState() => _CpdTabLayoutState();
}

class _CpdTabLayoutState extends State<CpdTabLayout> {

  Future<List<dynamic>> fetchNonStructuredPoints(int year) async {
    String s = await getUserId();
    String url = Constants.baseUrl + 'users/nonestructuredpoints/$s/$year';

    var response =
    await http.get(Uri.parse(url)).timeout(
        Duration(seconds: 30), onTimeout: () {
      throw new Exception(
          'Action took so long. Check your internet connection and try again');
    });
    if (response.statusCode != 200) {
      throw new Exception('Error fetching Non-structured Points');
    }
    List<dynamic> points = json.decode(response.body);
    return points;
  }

  Future<List<dynamic>> fetchStructuredPoints(int year) async {
    String s = await getUserId();
    String url = Constants.baseUrl + 'users/structuredpoints/$s/$year';
    print(url);
    var response =
    await http.get(Uri.parse(url)).timeout(
        Duration(seconds: 30), onTimeout: () {
      throw new Exception(
          'Action took so long. Check your internet connection and try again');
    });
    if (response.statusCode != 200) {
      throw new Exception('Error fetching Structured Points');
    }
    List<dynamic> points = json.decode(response.body);
    return points;
  }

  List<int> yearsInDroDown = [];
  int yearToSearch;

  List<dynamic> incidents = [];

  @override
  void initState() {
    int currentYear = DateTime
        .now()
        .year;
    for (var i = 0; i < 20; i++) {
      yearsInDroDown.add(currentYear - i);
    }
    yearToSearch = yearsInDroDown[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Structured Points',
                ),
                Tab(
                  text: 'Non-Structured Points',
                ),
              ],
            ),
            title: Text('CPD Points History'),
          ),
          body: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            child: Column(
              children: [
                Container(
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: DropdownButton(
                    hint: Text('Select Year'),
                    // Not necessary for Option 1
                    value: yearToSearch.toString(),
                    onChanged: (newValue) {
                      setState(() {
                        yearToSearch = int.tryParse(newValue);
                      });
                    },
                    items: yearsInDroDown.map((year) {
                      return DropdownMenuItem(
                        child: new Text(year.toString()),
                        value: year.toString(),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Container(
                        color: Colors.grey[100],
                        child: FutureBuilder(
                          future: fetchStructuredPoints(yearToSearch),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else if (snapshot.hasData) {
                              incidents = snapshot.data;
                              bool hasData = incidents.length > 0;
                              if (!hasData) {
                                return EmptyPage(
                                  icon: Icons.error,
                                  message: "No cpd points history found for the selected year",
                                  height: 200.0,
                                );
                              }
                              List<String> titleColumn = [
                                "Event Name",
                                "Event Ref",
                                "Hours",
                                "Date",
                                "Points"
                              ];

                              int totalPoints = 0;
                              return StickyHeadersTable(
                                columnsLength: titleColumn.length,
                                rowsLength: incidents.length + 1,
                                columnsTitleBuilder: (i) =>
                                    Text(titleColumn[i]),
                                rowsTitleBuilder: (i) {
                                  if(i == incidents.length){
                                    return Text("Total");
                                  }
                                  return Text("${(i + 1)}");
                                },
                                contentCellBuilder: (i, j) {
                                  if (j == incidents.length) {
                                    if (i == 0) {
                                      return Text("-");
                                    } else if (i == 1) {
                                      return Text("-");
                                    } else if (i == 2) {
                                      return Text("-");
                                    } else if (i == 3) {
                                      return Text("-");
                                    } else {
                                      return Text("$totalPoints", style: TextStyle(fontWeight: FontWeight.bold),);
                                    }
                                  } else {
                                    CpdPointStructured cpdPointStructured = CpdPointStructured
                                        .fromJson(incidents[j]);
                                    if (i == 0) {
                                      return Text(
                                          "${cpdPointStructured.COMMENTS}");
                                    } else if (i == 1) {
                                      return Text("${cpdPointStructured.REF}");
                                    } else if (i== 2) {
                                      return Text(
                                          "${cpdPointStructured.HOURS}");
                                    } else if (i == 3) {
                                      return Text("${cpdPointStructured.DATE}");
                                    } else {
                                      var points = cpdPointStructured.CREDITS;
                                      if(points != null){
                                        try{
                                          int pp = int.parse(points);
                                          totalPoints += pp;
                                        }catch(e){

                                        }
                                      }
                                      return Text("${cpdPointStructured.CREDITS}");
                                    }
                                  }
                                },
                                legendCell: Text('#'),
                              );
                            } else if (snapshot.hasError) {
                              return EmptyPage(
                                icon: Icons.error,
                                message: snapshot.error.toString(),
                                height: 200.0,
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                      Container(
                        color: Colors.grey[100],
                        child: FutureBuilder(
                          future: fetchNonStructuredPoints(yearToSearch),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              List<dynamic> incidents = snapshot.data;
                              bool hasData = incidents.length > 0;
                              if (!hasData) {
                                return EmptyPage(
                                  icon: Icons.error,
                                  message: "No cpd points history found for the selected year",
                                  height: 200.0,
                                );
                              }
                              return ListView.builder(
                                  itemCount: incidents.length,
                                  itemBuilder: (context, index) {
                                    return CpdPointsNonStructuredHolder(
                                      cpdPoint: CpdPointNonStructured.fromJson(
                                          incidents[index]),
                                    );
                                  });
                            } else if (snapshot.hasError) {
                              return EmptyPage(
                                icon: Icons.error,
                                message: snapshot.error.toString(),
                                height: 200.0,
                              );
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _getTitleWidget() {
    return [
      _getTitleItemWidget("#", 30),
      _getTitleItemWidget("Event Name", 200),
      _getTitleItemWidget('Date', 100),
      _getTitleItemWidget('Host', 100),
      _getTitleItemWidget('Location', 100),
      _getTitleItemWidget('Points', 100),
    ];
  }

  Widget _getTitleItemWidget(String label, double width) {
    return Container(
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
      width: width,
      height: 56,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateFirstColumnRow(BuildContext context, int index) {
    return Container(
      child: Text((index + 1).toString()),
      width: 30,
      height: 52,
      padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
      alignment: Alignment.centerLeft,
    );
  }

  Widget _generateRightHandSideColumnRow(BuildContext context, int index) {
    CpdPointStructured cpdPointStructured = CpdPointStructured.fromJson(
        incidents[index]);

    return Row(
      children: [
        Container(
          child: Text("${cpdPointStructured.REF}"),
          width: 200,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text("${cpdPointStructured.CREDITS}"),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text("${cpdPointStructured.CREDITS}"),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text("${cpdPointStructured.CREDITS}"),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
        Container(
          child: Text("${cpdPointStructured.CREDITS}"),
          width: 100,
          height: 52,
          padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
          alignment: Alignment.centerLeft,
        ),
      ],
    );
  }
}
