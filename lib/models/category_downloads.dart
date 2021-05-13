import 'package:flutter/foundation.dart';

class CategoryDownload {

  final file_id,
      file_title,
      file_alias,
      description,
      url_download,
      title;

  CategoryDownload({
    @required this.file_id,
    @required this.file_title,
    @required this.file_alias,
    @required this.description,
    @required this.url_download,
    @required this.title,
  });

  static CategoryDownload fromJson(dynamic json) {
    return CategoryDownload(
      file_id: json['file_id'],
      file_title: json['file_title'],
      file_alias: json['file_alias'],
      description: json['description'],
      url_download: json['url_download'],
      title: json['title'],
    );
  }
}
