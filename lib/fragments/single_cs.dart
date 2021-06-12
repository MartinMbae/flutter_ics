import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_ics/models/cs_directory.dart';
import 'package:flutter_ics/widgets/profile_row.dart';

class SingleCS extends StatelessWidget {

  final CsDirectory csDirectory;

  const SingleCS({Key key, this.csDirectory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 30),
        child: Container(
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
                          imageUrl: csDirectory.photo,
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
                    ProfileRow(title: "Name", content: csDirectory.NAME),
                    SizedBox(height: 10,),
                    ProfileRow(title: "Email", content: csDirectory.EMAIL),
                    SizedBox(height: 10,),
                    ProfileRow(title: "Gender", content: csDirectory.gender),
                    SizedBox(height: 10,),
                    ProfileRow(title: "Phone Number", content: csDirectory.TEL),
                    SizedBox(height: 10,),
                    ProfileRow(title: "CS(K) / FCS(K)", content: csDirectory.CPSK),
                    SizedBox(height: 10,),
                    ProfileRow(title: "Practice Sector", content: csDirectory.practice_sector),
                    SizedBox(height: 10,),
                    ProfileRow(title: "Company", content: csDirectory.COMPANY),
                    SizedBox(height: 10,),
                    ProfileRow(title: "Biography", content: csDirectory.biography),
                    SizedBox(height: 10,),
                    ProfileRow(title: "Branch", content: csDirectory.branch),
                    SizedBox(height: 10,),
                    ProfileRow(title: "Physical Location", content: csDirectory.PHYSICAL),
                    SizedBox(height: 10,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
