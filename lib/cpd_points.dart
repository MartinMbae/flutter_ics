import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_ics/empty_screen.dart';
import 'package:flutter_ics/models/cpd_point_non_structured.dart';
import 'package:flutter_ics/models/cpd_point_structured.dart';
import 'package:flutter_ics/non_structured_points_holder.dart';
import 'package:flutter_ics/structured_points_holder.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:flutter_ics/utils/shared_pref.dart';
import 'package:http/http.dart' as http;

class CpdTabLayout extends StatefulWidget {
  @override
  _CpdTabLayoutState createState() => _CpdTabLayoutState();
}

class _CpdTabLayoutState extends State<CpdTabLayout> {
  Future<List<dynamic>> fetchNonStructuredPoints(int year) async {
    String s = await getUserId();
    String url = Constants.baseUrl + 'users/nonestructuredpoints/$s/$year';

    var response =
        await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));
    if (response.statusCode != 200) {
      throw new Exception('Error fetching Non-structured Points');
    }
    List<dynamic> points = json.decode(response.body);
    return points;
  }

  Future<List<dynamic>> fetchStructuredPoints(int year) async {
    String s = await getUserId();
    String url = Constants.baseUrl + 'users/structuredpoints/$s/$year';
    var response =
        await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));
    if (response.statusCode != 200) {
      throw new Exception('Error fetching Structured Points');
    }
    List<dynamic> points = json.decode(response.body);
    return points;
  }

  List<int> yearsInDroDown = [];
  int yearToSearch;

  @override
  void initState() {
    int currentYear = DateTime.now().year;
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
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: DropdownButton(
                    hint: Text('Please choose a location'),
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
                            if(snapshot.connectionState == ConnectionState.waiting){
                              return Center(child: CircularProgressIndicator());
                            }else

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
                                    return CpdPointsStructuredHolder(
                                      cpdPoint: CpdPointStructured.fromJson(
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
}
