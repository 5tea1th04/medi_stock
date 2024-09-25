import 'package:flutter/material.dart';
import 'package:medi_stock/Screens/notification_screen.dart';
import 'package:medi_stock/Screens/order_screen.dart';

import 'UserWidgets/bottom_navigation_bar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      initialRoute: MyBottomNavigationBar.id,
      routes: {
        OrderScreen.id : (context)=> OrderScreen(),
        NotificationScreen.id : (context) => OrderScreen(),
        MyBottomNavigationBar.id : (context) => MyBottomNavigationBar(),
      },
    );
  }
}