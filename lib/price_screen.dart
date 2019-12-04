import 'networking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;
import 'reusable_card.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  var bitCoinValue;
  var liteCoinValue;
  var ethereumValue;

  @override
  void initState() {
    super.initState();
    getCurrenciesValue(selectedCurrency);
  }

  void getCurrenciesValue(String selectedCurrency) async {
    setState(() {
      bitCoinValue = 'loading...';
      liteCoinValue = 'loading...';
      ethereumValue = 'loading...';
    });
    var jsonBTC = await Networking(coin: 'BTC', currency: selectedCurrency)
        .getCurrencyValue();
    var jsonETC = await Networking(coin: 'ETH', currency: selectedCurrency)
        .getCurrencyValue();
    var jsonLTC = await Networking(coin: 'LTC', currency: selectedCurrency)
        .getCurrencyValue();
    setState(() {
      bitCoinValue = jsonBTC['last'];
      liteCoinValue = jsonLTC['last'];
      ethereumValue = jsonETC['last'];
    });
  }

  Widget getDropDownItem() {
    List<DropdownMenuItem<String>> allItems = [];
    for (String currency in currenciesList) {
      var item = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      allItems.add(item);
    }

    return DropdownButton(
        value: selectedCurrency,
        items: allItems,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value;
            getCurrenciesValue(selectedCurrency);
          });
        });
  }

  Widget getPickerItem() {
    List<Widget> allItems = [];
    for (String item in currenciesList) {
      allItems.add(Text(item));
    }
    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getCurrenciesValue(selectedCurrency);
        });
      },
      children: allItems,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            children: <Widget>[
              ReusableCard(
                coin: 'BTC',
                currency: selectedCurrency,
                currencyValue: bitCoinValue,
              ),
              ReusableCard(
                coin: 'ETH',
                currency: selectedCurrency,
                currencyValue: ethereumValue,
              ),
              ReusableCard(
                coin: 'LTC',
                currency: selectedCurrency,
                currencyValue: liteCoinValue,
              ),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? getPickerItem() : getDropDownItem(),
          ),
        ],
      ),
    );
  }
}
