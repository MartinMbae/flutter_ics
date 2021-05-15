import 'package:flutter/foundation.dart';

class CpdPointNonStructured {

  final id,
      event,
      organizer,
      location,
      start,
      end,
      submitted,
      credits_requested,
      credits_awarded;

  CpdPointNonStructured({
    @required this.id,
    @required this.event,
    @required this.organizer,
    @required this.location,
    @required this.start,
    @required this.end,
    @required this.submitted,
    @required this.credits_requested,
    @required this.credits_awarded,
  });

  static CpdPointNonStructured fromJson(dynamic json) {
    return CpdPointNonStructured(
      id: json['id'],
      event: json['event'],
      organizer: json['organizer'],
      location: json['location'],
      start: json['start'],
      end: json['end'],
      submitted: json['submitted'],
      credits_requested: json['credits_requested'],
      credits_awarded: json['credits_awarded'],
    );
  }
}
