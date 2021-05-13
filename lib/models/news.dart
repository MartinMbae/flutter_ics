import 'package:flutter/foundation.dart';

class IcsNewsItem {
  final id,
      title,
      alias,
      introtext,
      fulltext,
      created,
      created_by,
      created_by_alias,
      name;

  IcsNewsItem({
    @required this.id,
    @required this.title,
    @required this.alias,
    @required this.introtext,
    @required this.fulltext,
    @required this.created,
    @required this.created_by,
    @required this.created_by_alias,
    @required this.name,
  });

  static IcsNewsItem fromJson(dynamic json) {
    return IcsNewsItem(
      id: json['id'],
      title: json['title'],
      alias: json['alias'],
      introtext: json['introtext'],
      fulltext: json['fulltext'],
      created: json['created'],
      created_by: json['created_by'],
      created_by_alias: json['created_by_alias'],
      name: json['name'],
    );
  }
}
