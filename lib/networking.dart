import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class Networking {
  final coin;
  final currency;
  Networking({@required this.coin, @required this.currency});

  Future getCurrencyValue() async {
    var url =
        'https://apiv2.bitcoinaverage.com/indices/global/ticker/$coin$currency';

    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print(jsonResponse);
      return jsonResponse;
    } else {
      print("Request failed with status: ${response.statusCode}.");
    }
  }
}
