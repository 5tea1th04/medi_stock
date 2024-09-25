import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget {
  static String id = 'bottom';
  const MyBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        unselectedLabelStyle: TextStyle(
          color: Colors.black,
        ),
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback_outlined),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Stock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call_split_rounded),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delivery_dining_rounded),
            label: 'Orders',
          ),
        ],

      ),
    );
  }
}
