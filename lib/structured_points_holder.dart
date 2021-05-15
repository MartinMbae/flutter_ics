import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ics/models/cpd_point_non_structured.dart';
import 'package:flutter_ics/models/cpd_point_structured.dart';

class CpdPointsStructuredHolder extends StatefulWidget {
  final CpdPointStructured cpdPoint;

  const CpdPointsStructuredHolder({Key key, @required this.cpdPoint}) : super(key: key);

  @override
  _CpdPointsStructuredHolderState createState() => _CpdPointsStructuredHolderState();
}

class _CpdPointsStructuredHolderState extends State<CpdPointsStructuredHolder> {
  ArsProgressDialog progressDialog;

  @override
  Widget build(BuildContext context) {
    progressDialog = ArsProgressDialog(context,
        blur: 2,
        backgroundColor: Color(0x33000000),
        animationDuration: Duration(milliseconds: 500));

    return Card(
      margin: EdgeInsets.all(8),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.cpdPoint.COMMENTS}",
                            style: Theme.of(context)
                                .textTheme
                                .subtitle1
                                .apply(fontSizeFactor: 0.9)),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Container(
                  width: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Icon(
                        Icons.star,
                        size: 20,
                        color: Colors.yellow[700],
                      ),

                      Text("+${widget.cpdPoint.CREDITS}",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .apply(fontSizeFactor: 0.9, color: Colors.green,  fontWeightDelta: 1))
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 1,),
            Row(
              children: [
                Text("Date : ", style: Theme.of(context).textTheme.subtitle1.apply(fontSizeFactor: 0.8)),
                Text("${widget.cpdPoint.DATE}", style: Theme.of(context).textTheme.subtitle1.apply(fontSizeFactor: 0.8, color: Colors.green)),
              ],
            ),
            SizedBox(
              height: 5,
            ),

            Row(
              children: [
                Text("Ref : ", style: Theme.of(context).textTheme.subtitle1.apply(fontSizeFactor: 0.8)),
                Text("${widget.cpdPoint.REF}", style: Theme.of(context).textTheme.subtitle1.apply(fontSizeFactor: 0.8, color: Colors.green)),
              ],
            ),
            SizedBox(
              height: 5,
            ),

            Row(
              children: [
                Text("Type : ", style: Theme.of(context).textTheme.subtitle1.apply(fontSizeFactor: 0.8)),
                Text("${widget.cpdPoint.TYPE}", style: Theme.of(context).textTheme.subtitle1.apply(fontSizeFactor: 0.8, color: Colors.green)),
              ],
            ),
            SizedBox(
              height: 5,
            ),

            Row(
              children: [
                Text("Hours : ", style: Theme.of(context).textTheme.subtitle1.apply(fontSizeFactor: 0.8)),
                Text("${widget.cpdPoint.HOURS}", style: Theme.of(context).textTheme.subtitle1.apply(fontSizeFactor: 0.8, color: Colors.green)),
              ],
            ),
            SizedBox(
              height: 5,
            ),

          ],
        ),
      ),
    );
  }
}
