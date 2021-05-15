import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_ics/book_event_dialog.dart';
import 'package:flutter_ics/event_row.dart';
import 'package:flutter_ics/models/booked_event.dart';
import 'package:flutter_ics/models/events.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/constants.dart';
import 'package:flutter_ics/utils/custom_methods.dart';
import 'package:flutter_ics/utils/shared_pref.dart';
import 'package:http/http.dart' as http;
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

class _IcsEventsListViewState extends State<IcsEventsListView> {
  List<dynamic> initialEvents;
  var scrollController = ScrollController();
  bool updating = false;

  var containerHeight = 200.0;

  @override
  void initState() {
    super.initState();
    getEvents();
  }

  getEvents() async {
    initialEvents = await EventsApiHelper().fetchEvents();
    setState(() {});
  }

  checkUpdate() async {
    setState(() {
      updating = true;
    });
    var scrollpositin = scrollController.position;
    if (scrollpositin.pixels == scrollpositin.maxScrollExtent) {
      var newapi = EventsApiHelper().getApi(initialEvents.length);
      List<dynamic> newIcsNews = await EventsApiHelper().fetchEvents(newapi);
      initialEvents.addAll(newIcsNews);
    }
    setState(() {
      updating = false;
    });
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
  Widget build(BuildContext context) {
    if ((widget.myEvents)) {
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
                    "You have not booked any events. Events you Book will appear here.",
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
                      if (widget.myEvents) {
                        return IcsBookedEventHolder(
                          bookedEvent: BookedEvent.fromJson(eventsList[index]),
                          callback: () {
                            widget.callBack();
                          },
                        );
                      } else {
                        return IcsEventHolder(
                          icsEvent: ICS_Event.fromJson(eventsList[index]),
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
    } else {
      return getEventsBody();
    }
  }

  getEventsBody() {
    if (initialEvents == null)
      return Center(child: CircularProgressIndicator());
    return NotificationListener<ScrollNotification>(
      onNotification: (noti) {
        if (noti is ScrollEndNotification) {
          checkUpdate();
        }
        return true;
      },
      child: Container(
        height: 220,
        child: Row(
          children: [
            Expanded(
              child: ListView.separated(
                shrinkWrap: true,
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (c, i) {
                  return IcsEventHolder(
                    icsEvent: ICS_Event.fromJson(initialEvents[i]),
                    callback: () {
                      widget.callBack();
                    },
                  );
                },
                itemCount: initialEvents.length,
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 20,
                  );
                },
              ),
            ),
            if (updating) CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}

class IcsEventHolder extends StatelessWidget {
  const IcsEventHolder({Key key, this.icsEvent, this.callback})
      : super(key: key);

  final VoidCallback callback;
  final ICS_Event icsEvent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: Row(
                        children: <Widget>[
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: Container(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.only(top: 16),
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
                                      subtitle:
                                          formatDate(icsEvent.event_date)),
                                  EventRow(
                                      title: "End Date",
                                      subtitle:
                                          formatDate(icsEvent.event_date)),
                                  EventRow(
                                      title: "Capacity",
                                      subtitle: icsEvent.event_capacity),
                                  EventRow(
                                      title: "Charges",
                                      subtitle: formatCharges(
                                          icsEvent.individual_price)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RaisedButton.icon(
                                        onPressed: () {
                                          showCupertinoModalBottomSheet(
                                              context: context,
                                              builder: (context) => BookEvent(
                                                    eventId: icsEvent.id,
                                                    eventPrice: formatCharges(
                                                        icsEvent
                                                            .individual_price),
                                                    eventTitle: icsEvent.title,
                                                  ));
                                        },
                                        icon: Icon(
                                          Icons.bookmarks_outlined,
                                          color: Colors.white,
                                        ),
                                        label: Text(
                                          "Book this Event",
                                          style: TextStyle(color: Colors.white),
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
    );
  }
}

class IcsBookedEventHolder extends StatelessWidget {
  const IcsBookedEventHolder(
      {Key key,
      this.bookedEvent,
      this.callback})
      : super(key: key);

  final VoidCallback callback;
  final BookedEvent bookedEvent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
                                      subtitle:
                                      bookedEvent.organization),
                                  EventRow(
                                      title: "Event Date",
                                      subtitle: formatDate(
                                          bookedEvent.event_date)),
                                  EventRow(
                                      title: "Event End Date",
                                      subtitle: formatDate(
                                          bookedEvent.event_end_date)),
                                  EventRow(
                                      title: "Number of Registrants ",
                                      subtitle: bookedEvent
                                          .number_registrants),
                                  EventRow(
                                      title: "Payment Status",
                                      subtitle:
                                      bookedEvent.payment_status),
                                  EventRow(
                                      title: "Payment Date",
                                      subtitle:
                                      bookedEvent.payment_date),
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

class EventsApiHelper {
  Future<List<dynamic>> fetchEvents([String url]) async {
    var initialUrl = Constants.baseUrl + "events/5/0";
    var response = await http.get(Uri.parse(url ?? initialUrl));
    if (response == null) {
      throw new Exception('Error fetching events');
    }
    if (response.statusCode != 200) {
      throw new Exception('Error fetching events');
    }
    List<dynamic> events = jsonDecode(response.body);
    return events;
  }

  getApi(int start) {
    final mainUrl = Constants.baseUrl + "events/5/";
    return mainUrl + start.toString();
  }
}
