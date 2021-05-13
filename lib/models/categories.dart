import 'package:flutter/foundation.dart';

class DownloadsCategory {
  final id,
      title;

  DownloadsCategory({
    @required this.id,
    @required this.title,
  });

  static DownloadsCategory fromJson(dynamic json) {
    return DownloadsCategory(
      id: json['id'],
      title: json['title'],
    );
  }
}
