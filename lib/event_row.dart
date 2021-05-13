import 'package:flutter/material.dart';
import 'package:flutter_ics/utils/app_colors.dart';

class EventRow extends StatelessWidget {


  final title, subtitle, subtitleColor;


  const EventRow({Key key, @required this.title, @required this.subtitle, this.subtitleColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: "$title : ", style: TextStyle(color: primaryColorDark, fontWeight: FontWeight.bold)),
            TextSpan(text: "$subtitle", style: TextStyle(color: subtitleColor == null ? primaryColor : subtitleColor)),
          ],
        ),
      ),
    );
  }
}
