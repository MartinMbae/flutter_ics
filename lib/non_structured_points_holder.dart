import 'package:ars_progress_dialog/ars_progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_ics/models/cpd_point_non_structured.dart';

class CpdPointsNonStructuredHolder extends StatefulWidget {
  final CpdPointNonStructured cpdPoint;

  const CpdPointsNonStructuredHolder({Key key, @required this.cpdPoint}) : super(key: key);

  @override
  _CpdPointsNonStructuredHolderState createState() => _CpdPointsNonStructuredHolderState();
}

class _CpdPointsNonStructuredHolderState extends State<CpdPointsNonStructuredHolder> {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("${widget.cpdPoint.event}",
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
                      widget.cpdPoint.credits_requested == '0'?
                      Text("+${widget.cpdPoint.credits_awarded}",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .apply(fontSizeFactor: 0.9, color: Colors.green,  fontWeightDelta: 1)):
                      Text("-${widget.cpdPoint.credits_requested}",
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .apply(fontSizeFactor: 0.9, color: Colors.red, fontWeightDelta: 1))
                    ],
                  ),
                ),
              ],
            ),
            Divider(height: 1,),
            Row(
              children: [
                Text("Organizer : ", style: Theme.of(context).textTheme.subtitle1.apply(fontSizeFactor: 0.8)),
                Text("${widget.cpdPoint.organizer}", style: Theme.of(context).textTheme.subtitle1.apply(fontSizeFactor: 0.8, color: Colors.green)),
              ],
            ),
            SizedBox(
              height: 5,
            ),

            Row(
              children: [
                Text("Location : ", style: Theme.of(context).textTheme.subtitle1.apply(fontSizeFactor: 0.8)),
                Text("${widget.cpdPoint.location}", style: Theme.of(context).textTheme.subtitle1.apply(fontSizeFactor: 0.8, color: Colors.green)),
              ],
            ),
            SizedBox(
              height: 5,
            ),

            Row(
              children: [
                Text("Start Date : ", style: Theme.of(context).textTheme.subtitle1.apply(fontSizeFactor: 0.8)),
                Text("${widget.cpdPoint.start}", style: Theme.of(context).textTheme.subtitle1.apply(fontSizeFactor: 0.8, color: Colors.green)),
              ],
            ),
            SizedBox(
              height: 5,
            ),

            Row(
              children: [
                Text("End Date : ", style: Theme.of(context).textTheme.subtitle1.apply(fontSizeFactor: 0.8)),
                Text("${widget.cpdPoint.end}", style: Theme.of(context).textTheme.subtitle1.apply(fontSizeFactor: 0.8, color: Colors.green)),
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
