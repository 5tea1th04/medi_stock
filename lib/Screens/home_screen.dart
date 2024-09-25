import 'package:flutter/material.dart';
import 'package:medi_stock/UserWidgets/bottom_navigation_bar.dart';
import 'package:medi_stock/Utilities/constants.dart';
class HomeScreen extends StatelessWidget {
  static String id = "home_screen";
  static int num = nameNavigation.indexOf(HomeScreen.id);
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: PersistentBottomNavBar(selectedIndex: num, onItemTapped: (int value) { Navigator.popAndPushNamed(context, nameNavigation[value]); },),
    );
  }
}
