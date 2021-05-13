
import 'package:flutter/material.dart';

import 'api_helper.dart';
import 'coin.dart';

class PaginateTest extends StatefulWidget {
  @override
  _PaginateTestState createState() => _PaginateTestState();
}

class _PaginateTestState extends State<PaginateTest> {
  Coin coin;
  var scrollController = ScrollController();
  bool updating = false;

  @override
  void initState() {
    super.initState();
    getCoin();
  }

  getCoin() async {
    coin = await apiHelper.getCoins();
    setState(() {});
  }

  checkUpdate() async {
    setState(() {
      updating = true;
    });
    var scrollpositin = scrollController.position;
    if (scrollpositin.pixels == scrollpositin.maxScrollExtent) {
      var newapi = apiHelper.getApi(coin.data.length);
      var newcoin = await apiHelper.getCoins(newapi) as Coin;
      coin.data.addAll(newcoin.data);
    }
    setState(() {
      updating = false;
    });
  }

  getBody() {
    if (coin == null) return Center(child: CircularProgressIndicator());
    return NotificationListener<ScrollNotification>(
      onNotification: (noti) {
        if (noti is ScrollEndNotification) {
          checkUpdate();
        }
        return true;
      },
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              physics: BouncingScrollPhysics(),
              itemBuilder: (c, i) {
                return Card(
                  elevation: 2,
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    leading: Text('${i + 1}'),
                    title: Text(coin.data[i].name),
                    trailing: Text("\$" + coin.data[i].priceUsd),
                  ),
                );
              },
              itemCount: coin.data.length,
            ),
          ),
          if (updating) CircularProgressIndicator()
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('coin'),
        ),
        body: getBody());
  }
}