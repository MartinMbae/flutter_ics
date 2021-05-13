import 'dart:convert';

import 'package:flutter_ics/pagination/coin.dart';
import 'package:http/http.dart' as http;

class ApiHelper {
  getCoins([String url]) async {
    var data = await http.get(Uri.parse(url ?? 'https://api.coinlore.net/api/tickers/'));
    return Coin.fromMap(json.decode(data.body));
  }

  getApi(int start) {
    final mainUrl = "https://api.coinlore.net/api/tickers/?start=";
    return mainUrl + start.toString() + "&limit=20";
  }
}

final apiHelper = ApiHelper();