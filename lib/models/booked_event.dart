import 'package:flutter/foundation.dart';

class BookedEvent {
  final id,
      event_id,
      user_id,
      first_name,
      last_name,
      organization,
      address,
      city,
      state,
      country,
      number_registrants,
      register_date,
      payment_status,
      payment_date,
      phone,
      email,
      title,
      event_date,
      event_end_date;

  BookedEvent({
    @required this.id,
    @required this.event_id,
    @required this.user_id,
    @required this.first_name,
    @required this.last_name,
    @required this.organization,
    @required this.address,
    @required this.city,
    @required this.state,
    @required this.number_registrants,
    @required this.register_date,
    @required this.payment_status,
    @required this.payment_date,
    @required this.country,
    @required this.phone,
    @required this.email,
    @required this.title,
    @required this.event_date,
    @required this.event_end_date,
  });

  static BookedEvent fromJson(dynamic json) {
    return BookedEvent(
      id: json['id'],
      event_id: json['event_id'],
      user_id: json['user_id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      organization: json['organization'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      phone: json['phone'],
      email: json['email'],
      number_registrants: json['number_registrants'],
      register_date: json['register_date'],
      payment_status: json['payment_status'],
      payment_date: json['payment_date'],
      title: json['title'],
      event_end_date: json['event_end_date'],
      event_date: json['event_date'],
    );
  }
}
