import 'package:flutter/foundation.dart';
import 'package:flutter_ics/utils/constants.dart';

class DownloadsCategory {
  final id,
      title,
  pic,cat_dir
  ;

  DownloadsCategory({
    @required this.id,
    @required this.title,
    @required this.pic,
    @required this.cat_dir,
  });

  static DownloadsCategory fromJson(dynamic json) {
    return DownloadsCategory(
      id: json['id'],
      title: json['title'],
      pic: json['pic'],
      cat_dir: json['cat_dir'],
    );
  }

  String getCategoryImageLink(){
    return Constants.baseUrlForFiles + 'images/jdownloads/catimages/$pic';
  }
}
