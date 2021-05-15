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


  Future<List<dynamic>> fetchNonStructuredPoints() async {
    String s = await getUserId();
    String url = Constants.baseUrl + 'users/nonestructuredpoints/$s';
    var response = await http.get( Uri.parse(url)).timeout(Duration(seconds: 30));
    if (response.statusCode != 200) {
      throw new Exception('Error fetching available new Purchases');
    }
    List<dynamic> points = json.decode(response.body);
    return points;
  }

  Future<List<dynamic>> fetchStructuredPoints() async {
    String s = await getUserId();
    String url = Constants.baseUrl + 'users/structuredpoints/$s';
    var response = await http.get( Uri.parse(url)).timeout(Duration(seconds: 30));
    if (response.statusCode != 200) {
      throw new Exception('Error fetching available new Purchases');
    }
    List<dynamic> points = json.decode(response.body);
    return points;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(text: 'Structured Points',),
                Tab(text: 'Non-Structured Points',),
              ],
            ),
            title: Text('CPD Points History'),
          ),
          body: TabBarView(
            children: [
              Container(
                color: Colors.grey[100],
                child: FutureBuilder(
                  future: fetchStructuredPoints(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {

                      List<dynamic> incidents = snapshot.data ;
                      bool hasData = incidents.length > 0;
                      if (!hasData){
                        return EmptyPage(icon: Icons.error, message: "No cpd points history found",height: 200.0,);
                      }
                      return ListView.builder(
                          itemCount: incidents.length,
                          itemBuilder: (context, index) {
                            return CpdPointsStructuredHolder(
                              cpdPoint: CpdPointStructured.fromJson(incidents[index]),
                            );
                          });

                    } else if(snapshot.hasError){
                      return Text(snapshot.error.toString());
                    }else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Container(
                color: Colors.grey[100],
                child: FutureBuilder(
                  future: fetchNonStructuredPoints(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {

                      List<dynamic> incidents = snapshot.data ;
                      bool hasData = incidents.length > 0;
                      if (!hasData){
                        return EmptyPage(icon: Icons.error, message: "No cpd points history found",height: 200.0,);
                      }
                      return ListView.builder(
                          itemCount: incidents.length,
                          itemBuilder: (context, index) {
                            return CpdPointsNonStructuredHolder(
                              cpdPoint: CpdPointNonStructured.fromJson(incidents[index]),
                            );
                          });

                    } else if(snapshot.hasError){
                      return Text(snapshot.error.toString());
                    }else {
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
