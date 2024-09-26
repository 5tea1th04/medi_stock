import 'package:flutter/material.dart';
import 'package:medi_stock/Screens/Distributor/order_screen_distributer.dart';
import 'package:medi_stock/Screens/delivery_screen.dart';
import 'package:medi_stock/Screens/home_screen.dart';
import 'package:medi_stock/Screens/login_screen.dart';
//import 'package:medi_stock/Screens/new_profile_screen.dart';
import 'package:medi_stock/Screens/notification_screen.dart';
import 'package:medi_stock/Screens/order_screen.dart';
import 'package:medi_stock/Screens/stockAnalysis.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      initialRoute: NotificationScreen.id,
      routes: {
        OrderScreen.id : (context)=> OrderScreen(),
        NotificationScreen.id : (context) => NotificationScreen(),
        StockAnalysis.id : (context) => StockAnalysis(),
        LoginScreen.id : (context) => LoginScreen(),
        // NewProfileScreen.id : (context) => NewProfileScreen(),
        DeliveryScreen.id : (context) => DeliveryScreen(),
        HomeScreen.id : (context) => HomeScreen(),
        OrderScreenDistributer.id  :(context) => OrderScreenDistributer(),

      },
    );
  }
}

