import 'package:flutter/material.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'book_event_dialog.dart';

class EventInfoScreen extends StatefulWidget {
  final eventId,eventTitle,eventPrice, startDate, endDate;
  const EventInfoScreen({Key key, @required this.eventId, @required this.eventTitle,
    @required this.eventPrice, @required  this.startDate, @required  this.endDate}) : super(key: key);

  @override
  _EventInfoScreenState createState() => _EventInfoScreenState();
}

class _EventInfoScreenState extends State<EventInfoScreen>
    with TickerProviderStateMixin {
  final double infoHeight = 364.0;
  AnimationController animationController;
  Animation<double> animation;
  double opacity1 = 0.0;
  double opacity2 = 0.0;
  double opacity3 = 0.0;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    animation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    setData();
    super.initState();
  }

  Future<void> setData() async {
    animationController.forward();
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity1 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity2 = 1.0;
    });
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    setState(() {
      opacity3 = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height : MediaQuery.of(context).size.height,
      child: Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 24),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      top: 32.0, left: 18, right: 16),
                  child: Text(
                    widget.eventTitle,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 22,
                      letterSpacing: 0.27,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 8, top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.eventPrice,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 22,
                          letterSpacing: 0.27,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: <Widget>[
                      Expanded(child: getTimeBoxUI(widget.startDate, 'Start Date')),
                      Expanded(child: getTimeBoxUI(widget.endDate, 'End Date')),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric( horizontal: 16, vertical : 8),
                  child: Text(
                    'You are invited to register for ${widget.eventTitle} on ${widget.startDate}',
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                      letterSpacing: 0.27,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric( horizontal: 16, vertical : 8),
                  child: Text(
                    "After registering, you will receive a confirmation email about joining the webinar. ",
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      fontWeight: FontWeight.w200,
                      fontSize: 14,
                      letterSpacing: 0.27,
                    ),
                  ),
                ),
                SizedBox(height: 80,),
                Padding(
                  padding: EdgeInsets.only(top: 24, right: 12, left: 12),
                  child: GestureDetector(
                    onTap: (){
                      showCupertinoModalBottomSheet(
                          context: context,
                          builder: (context) => BookEvent(
                                eventId: widget.eventId,
                                eventPrice: widget.eventPrice,
                                eventTitle: widget.eventTitle,
                              ));
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(12.0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Book This Event',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                            letterSpacing: 0.0,
                            color: Colors.white
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).padding.bottom,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getTimeBoxUI(String text1, String txt2) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
         color: Colors.grey[300],
          child: Padding(
            padding: const EdgeInsets.only(
                left: 18.0, right: 18.0, top: 12.0, bottom: 12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  text1,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    letterSpacing: 0.27,
                    color: primaryColor,
                  ),
                ),
                Text(
                  txt2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    fontSize: 14,
                    letterSpacing: 0.27,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
