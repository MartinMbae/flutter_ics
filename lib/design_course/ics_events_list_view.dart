import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_awesome_alert_box/flutter_awesome_alert_box.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_ics/book_event_dialog.dart';
import 'package:flutter_ics/event_row.dart';
import 'package:flutter_ics/models/booked_event.dart';
import 'package:flutter_ics/models/events.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:flutter_ics/utils/custom_methods.dart';
import 'package:flutter_ics/utils/shared_pref.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class IcsEventsListView extends StatefulWidget {
  const IcsEventsListView({Key key, this.callBack, @required this.myEvents})
      : super(key: key);
  final Function callBack;
  final bool myEvents;

  @override
  _IcsEventsListViewState createState() => _IcsEventsListViewState();
}

class _IcsEventsListViewState extends State<IcsEventsListView>
    with TickerProviderStateMixin {
  AnimationController animationController;

  var containerHeight = 200.0;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<List<dynamic>> fetchEvents() async {
    String url;
    if (widget.myEvents) {
      String id = await getUserId();
      url = Constants.baseUrl + "events/bookedevents/$id";
    } else {
      url = Constants.baseUrl + 'events';
    }
    var response =
        await http.get(Uri.parse(url)).timeout(Duration(seconds: 30));

    if (response == null) {
      throw new Exception('Error fetching events');
    }
    if (response.statusCode != 200) {
      throw new Exception('Error fetching events');
    }

    List<dynamic> events = jsonDecode(response.body);
    return events;
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 16),
      child: Container(
        height: containerHeight,
        width: double.infinity,
        child: FutureBuilder(
          future: fetchEvents(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<dynamic> eventsList = snapshot.data;
              if (eventsList.length == 0) {
                Future.delayed(Duration.zero, () async {
                  setState(() {
                    containerHeight = 50;
                  });
                });
                return Text(
                  (widget.myEvents)
                      ? "You have not booked any events. Events you Book will appear here."
                      : "No events found at the moment.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                );
              } else {
                return ListView.builder(
                  padding: EdgeInsets.only(right: 20),
                  itemCount: eventsList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final int count = eventsList.length;
                    final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                    animationController.forward();
                    if (widget.myEvents) {
                      return IcsBookedEventHolder(
                        bookedEvent: BookedEvent.fromJson(eventsList[index]),
                        animation: animation,
                        animationController: animationController,
                        callback: () {
                          widget.callBack();
                        },
                      );
                    } else {
                      return IcsEventHolder(
                        icsEvent: ICS_Event.fromJson(eventsList[index]),
                        animation: animation,
                        animationController: animationController,
                        callback: () {
                          widget.callBack();
                        },
                      );
                    }
                  },
                );
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class IcsEventHolder extends StatelessWidget {
  const IcsEventHolder(
      {Key key,
      this.icsEvent,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final ICS_Event icsEvent;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                callback();
              },
              child: SizedBox(
                width: 280,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: primaryColorLight),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: Text(
                                              icsEvent.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.27,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                          const Expanded(
                                            child: SizedBox(),
                                          ),
                                          EventRow(
                                              title: "Start Date",
                                              subtitle: formatDate(
                                                  icsEvent.event_date)),
                                          EventRow(
                                              title: "End Date",
                                              subtitle: formatDate(
                                                  icsEvent.event_date)),
                                          EventRow(
                                              title: "Capacity",
                                              subtitle:
                                                  icsEvent.event_capacity),
                                          EventRow(
                                              title: "Charges",
                                              subtitle: formatCharges(
                                                  icsEvent.individual_price)),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              RaisedButton.icon(
                                                onPressed: () {
                                                  showCupertinoModalBottomSheet(
                                                      context: context,
                                                      builder: (context) =>
                                                          BookEvent(
                                                            eventId:
                                                                icsEvent.id,
                                                            eventPrice:
                                                                formatCharges(
                                                                    icsEvent
                                                                        .individual_price),
                                                            eventTitle:
                                                                icsEvent
                                                                    .title,
                                                          ));
                                                },
                                                icon: Icon(
                                                  Icons.bookmarks_outlined,
                                                  color: Colors.white,
                                                ),
                                                label: Text(
                                                  "Book this Event",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                color: primaryColor,
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }


}

class IcsBookedEventHolder extends StatelessWidget {
  const IcsBookedEventHolder(
      {Key key,
      this.bookedEvent,
      this.animationController,
      this.animation,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final BookedEvent bookedEvent;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                callback();
              },
              child: SizedBox(
                width: 280,
                child: Stack(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: primaryColorLight),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(16.0)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    child: Container(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: Text(
                                              bookedEvent.title,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                                letterSpacing: 0.27,
                                                color: primaryColor,
                                              ),
                                            ),
                                          ),
                                          const Expanded(
                                            child: SizedBox(),
                                          ),
                                          EventRow(
                                              title: "Organization",
                                              subtitle: bookedEvent.organization),
                                          EventRow(
                                              title: "Event Date",
                                              subtitle: formatDate(bookedEvent.event_date)),
                                          EventRow(
                                              title: "Event End Date",
                                              subtitle: formatDate(bookedEvent.event_end_date)),
                                          EventRow(
                                              title: "Number of Registrants ",
                                              subtitle:
                                              bookedEvent.number_registrants),
                                          EventRow(
                                              title: "Payment Status",
                                              subtitle:   bookedEvent.payment_status),
                                          EventRow(
                                              title: "Payment Date",
                                              subtitle:   bookedEvent.payment_date),

                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  String formatDate(String date) {
    DateTime dateTime = DateTime.parse(date);
    DateFormat format = DateFormat('dd MMM yyyy');
    String formattedDate = format.format(dateTime);
    return formattedDate;
  }

  String formatCharges(String amount) {
    double am = double.parse(amount);
    return am == 0 ? "Free" : "$am";
  }
}
