import 'package:flutter/material.dart';
import 'package:flutter_ics/models/news.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/custom_methods.dart';

class SingleNewsPage extends StatelessWidget {

  final IcsNewsItem icsNewsItem;

  const SingleNewsPage({Key key, @required this.icsNewsItem}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("ICS News"), centerTitle: true,),
      body: ListView(
        padding: EdgeInsets.only(bottom: 50),
        children: [
          AspectRatio(
            aspectRatio: 2,
            child: Hero(
              tag: "news_image${icsNewsItem.id}",
              child: Image.asset(
                "assets/images/news.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 16, top: 8, bottom: 8),
                      child: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            mainAxisAlignment:
                            MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                formatDate(icsNewsItem.created),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey
                                        .withOpacity(0.8)),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Expanded(
                                child: Text(
                                  ' by ${icsNewsItem.name}',
                                  overflow:
                                  TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey
                                          .withOpacity(0.8)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Hero(
                            tag: "news_title${icsNewsItem.id}",
                            child: Text(
                              icsNewsItem.title,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(icsNewsItem.introtext),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
