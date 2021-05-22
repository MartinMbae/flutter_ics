import 'package:flutter/foundation.dart';
import 'package:flutter_ics/utils/constants.dart';

class CategoryDownload {

  final file_id,
      file_title,
      file_alias,
      description,
      url_download,
      cat_dir,
      file_pic,
      title;

  CategoryDownload({
    @required this.file_id,
    @required this.file_title,
    @required this.file_alias,
    @required this.description,
    @required this.url_download,
    @required this.title,
    @required this.cat_dir,
    @required this.file_pic,
  });

  static CategoryDownload fromJson(dynamic json) {
    return CategoryDownload(
      file_id: json['file_id'],
      file_title: json['file_title'],
      file_alias: json['file_alias'],
      description: json['description'],
      url_download: json['url_download'],
      title: json['title'],
      cat_dir: json['cat_dir'],
      file_pic: json['file_pic'],
    );
  }

  String getUrlLink(){
    return Constants.baseUrlForFiles+ 'jdownloads/$cat_dir/$url_download';
  }

  String getIconImageLink(){
    return Constants.baseUrlForFiles + 'images/jdownloads/fileimages/$file_pic';
  }
}
