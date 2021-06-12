
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ics/fragments/single_cs.dart';
import 'package:flutter_ics/models/cs_directory.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/widgets/profile_row.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CsListView extends StatelessWidget {
  const CsListView(
      {Key key,
      this.csData})
      : super(key: key);

  final CsDirectory csData;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(
                left: 8, top: 8, bottom: 8),
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      height: 80,
                      width: 80,
                      imageUrl: csData.photo,
                      errorWidget: (context, url, error) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/profile-placeholder.png'),
                            fit: BoxFit.cover,),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,),
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                      ),
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          CircularProgressIndicator(value: downloadProgress.progress),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                ProfileRow(title: "Name", content: csData.NAME),
                SizedBox(height: 10,),
                ProfileRow(title: "Email", content: csData.EMAIL),
                SizedBox(height: 10,),
                ProfileRow(title: "Gender", content: csData.gender),
                SizedBox(height: 10,),
                ProfileRow(title: "Phone Number", content: csData.TEL),
                SizedBox(height: 10,),
                ProfileRow(title: "CS(K) / FCS(K)", content: csData.CPSK),
                SizedBox(height: 10,),
                ProfileRow(title: "Firm", content: csData.COMPANY),
                SizedBox(height: 10,),
                ProfileRow(title: "Government Auditor", content: csData.auditor),
                SizedBox(height: 10,),
                ProfileRow(title: "Practice Sector", content: csData.practice_sector),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: RaisedButton(
                        onPressed: (){
                          showCupertinoModalBottomSheet(
                            expand: true,
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context){
                            return  SingleCS(
                              csDirectory: csData,
                            );
                            }
                          );
                        },
                        child: Text("View more"),
                        color: primaryColor,
                        textColor: Colors.white,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
