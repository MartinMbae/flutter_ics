import 'package:flutter/material.dart';
import 'package:flutter_ics/auth/login.dart';
import 'package:flutter_ics/load_news.dart';
import 'package:flutter_ics/utils/app_colors.dart';
import 'package:flutter_ics/utils/custom_methods.dart';

class GuestHome extends StatefulWidget {
  const GuestHome({Key key}) : super(key: key);

  @override
  _GuestHomeState createState() => _GuestHomeState();
}

class _GuestHomeState extends State<GuestHome> with TickerProviderStateMixin {

  AnimationController animationController;
  final ScrollController _scrollController = ScrollController();
  bool multiple = true;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 0));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteFaded,
      appBar: AppBar(
        centerTitle: true,
        title: Text("ICS"),
        elevation: 0,
      ),
      body: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: NestedScrollView(
                      controller: _scrollController,
                      headerSliverBuilder:
                          (BuildContext context, bool innerBoxIsScrolled) {
                        return <Widget>[
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                  return getLoginRequest();
                                }, childCount: 1),
                          ),
                          SliverPersistentHeader(
                            pinned: true,
                            floating: true,
                            delegate: ContestTabHeader(
                              Container(
                                color: Colors.white,
                                child: Padding(
                                  padding:
                                  EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 12),
                                  child:  Text(
                                    'Latest News',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 16,
                                      color: primaryColor
                                    ),
                                  )
                                ),
                              ),
                            ),
                          ),
                        ];
                      },
                      body: LoadIcsNews(),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }



  Widget getLoginRequest() {
    return Container(
      color: primaryColor,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child:  Image.asset("assets/images/logo.png", height: 80, width: 80,),
          ),
          Expanded(
            flex: 1,
            child:   GestureDetector(
              onTap: () async{
                await navigateToPage(context, LoginPage());
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Login/\nRegister'.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.account_box_outlined,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
      this.searchUI,
      );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}