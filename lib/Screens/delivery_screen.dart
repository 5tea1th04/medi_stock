import 'package:flutter/material.dart';

import '../UserWidgets/bottom_navigation_bar.dart';
import '../Utilities/constants.dart';

class DeliveryScreen extends StatelessWidget {
  static String id = "delivery_screen";
  static int num = nameNavigation.indexOf(DeliveryScreen.id);

  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: PersistentBottomNavBar(selectedIndex: num, onItemTapped: (int value) { Navigator.popAndPushNamed(context, nameNavigation[value]); },),

    );
  }
}
