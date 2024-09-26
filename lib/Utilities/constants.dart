import 'package:flutter/material.dart';
import 'package:medi_stock/Screens/price_compare_screen.dart';
import 'package:medi_stock/Screens/home_screen.dart';
import 'package:medi_stock/Screens/notification_screen.dart';
import 'package:medi_stock/Screens/order_screen.dart';
import 'package:medi_stock/Screens/stockAnalysis.dart';

const kInputDecoration = InputDecoration(
  labelStyle: TextStyle(color: Colors.white),
  hintText: '',
  hintStyle: TextStyle(color : Colors.grey),
  fillColor: Colors.white,
  contentPadding:
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.white, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide:
    BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);

 List<String> nameNavigation = <String>[
  HomeScreen.id,
  NotificationScreen.id,
  StockAnalysis.id,
  OrderScreen.id,
  PriceComparisonScreen.id,
];