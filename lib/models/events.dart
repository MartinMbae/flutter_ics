import 'package:flutter/foundation.dart';

class ICS_Event {
  final id,
      title,
      event_type,
      event_date,
      event_end_date,
      short_description,
      description,
      individual_price,
      event_capacity,
      created_by,
      registration_type,
      max_group_number,
      enable_cancel_registration,
      cancel_before_date;

  ICS_Event({
    @required this.id,
    @required this.title,
    @required this.event_type,
    @required this.event_date,
    @required this.event_end_date,
    @required this.short_description,
    @required this.description,
    @required this.individual_price,
    @required this.event_capacity,
    @required this.created_by,
    @required this.registration_type,
    @required this.max_group_number,
    @required this.enable_cancel_registration,
    @required this.cancel_before_date,
  });

  static ICS_Event fromJson(dynamic json) {
    return ICS_Event(
      id: json['id'],
      title: json['title'],
      event_type: json['event_type'],
      event_date: json['event_date'],
      event_end_date: json['event_end_date'],
      short_description: json['short_description'],
      description: json['description'],
      individual_price: json['individual_price'],
      event_capacity: json['event_capacity'],
      created_by: json['created_by'],
      registration_type: json['registration_type'],
      max_group_number: json['max_group_number'],
      enable_cancel_registration: json['enable_cancel_registration'],
      cancel_before_date: json['cancel_before_date'],
    );
  }
}
