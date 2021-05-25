import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ics/empty_screen.dart';
import 'package:flutter_ics/homepage/cs_list_view.dart';
import 'package:flutter_ics/models/cs_directory.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;

class LoadSortedCsDirectories extends StatefulWidget {
  final searchTerm;

  const LoadSortedCsDirectories({Key key, @required this.searchTerm})
      : super(key: key);

  @override
  _LoadSortedCsDirectoriesState createState() =>
      _LoadSortedCsDirectoriesState();
}

class _LoadSortedCsDirectoriesState extends State<LoadSortedCsDirectories> {
  List<dynamic> initialCsList;

  fetchCsList(var searchTerm) async {
    var initialUrl = Constants.baseUrl + "users/search/$searchTerm";
    var response = await http.get(Uri.parse(initialUrl));
    if (response == null) {
      throw new Exception('Error fetching CS Directories');
    }
    if (response.statusCode != 200) {
      throw new Exception('Error fetching CS Directories');
    }
    List<dynamic> events = jsonDecode(response.body);
    setState(() {
      initialCsList = events;
    });
  }

  @override
  void initState() {
    super.initState();
    print("Loading Sorted");
    fetchCsList(widget.searchTerm);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: getCsDirectoryBody(),
      ),
    );
  }

  getCsDirectoryBody() {
    if (initialCsList == null)
      return Center(child: CircularProgressIndicator());

    if(initialCsList.length == 0)
      return EmptyPage(icon: FontAwesomeIcons.sadTear, message: "Oops! We could not find any Secretary with the search criteria provided", height: 300.0,);
    return Container(
      height: MediaQuery.of(context).size.height,
      color: Colors.grey[300],
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemBuilder: (c, i) {
                return CsListView(
                  csData: CsDirectory.fromJson(initialCsList[i]),
                );
              },
              itemCount: initialCsList.length,
              separatorBuilder: (BuildContext context, int index) {
                return SizedBox(
                  height: 10,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
