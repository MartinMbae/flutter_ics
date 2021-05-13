import 'package:flutter/material.dart';
import 'package:flutter_ics/models/news.dart';
import 'package:flutter_ics/single_news_page.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/custom_methods.dart';

class SingleNew extends StatelessWidget {
    final VoidCallback callback;
  final IcsNewsItem icsNewsItem;
  const SingleNew({Key key, @required this.callback, @required this.icsNewsItem}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          left: 24, right: 24, top: 8, bottom: 16),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          callback();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(4, 4),
                blurRadius: 16,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: Column(
              children: <Widget>[
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

                                RaisedButton.icon(
                                  onPressed: (){
                                    navigateToPage(context, SingleNewsPage(icsNewsItem: icsNewsItem));
                                  },
                                  icon: Icon(Icons.remove_red_eye, color: Colors.white,),
                                  label: Text("Read more", style: TextStyle(color: Colors.white),),
                                  color: primaryColor,
                                ),
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
          ),
        ),
      ),
    );
  }
}
