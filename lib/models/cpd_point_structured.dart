import 'package:flutter/foundation.dart';

class CpdPointStructured {

  //user_id: "2517",
  // DATE: "2014-05-27 00:00:00",
  // REF: "P/2014/9 ",
  // TR_TYPE: "23",
  // AMOUNT: "0",
  // DBCR: "+",
  // COMMENTS: "ICPSK AGM Institute Offices 27/05/2014 .00 20.00 3.00 : Institute Offices Beginning 5/27/2014 Period: 0",
  // PERIOD: "0",
  // TYPE: "PRG",
  // CREDITS: "3",
  // HOURS: "20",
  // TRNO: "0",
  // new: "17682"

  final user_id,
      DATE,
      REF,
      TR_TYPE,
      AMOUNT,
      COMMENTS,
      TYPE,
      CREDITS,
      HOURS;

  CpdPointStructured({
    @required this.user_id,
    @required this.DATE,
    @required this.REF,
    @required this.TR_TYPE,
    @required this.AMOUNT,
    @required this.COMMENTS,
    @required this.TYPE,
    @required this.CREDITS,
    @required this.HOURS,
  });

  static CpdPointStructured fromJson(dynamic json) {
    return CpdPointStructured(
      user_id: json['user_id'],
      DATE: json['DATE'],
      REF: json['REF'],
      TR_TYPE: json['TR_TYPE'],
      AMOUNT: json['AMOUNT'],
      COMMENTS: json['COMMENTS'],
      TYPE: json['TYPE'],
      CREDITS: json['CREDITS'],
      HOURS: json['HOURS'],
    );
  }
}
