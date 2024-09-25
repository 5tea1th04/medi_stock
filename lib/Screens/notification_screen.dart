import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import '../UserWidgets/bottom_navigation_bar.dart';
import '../Utilities/constants.dart';

class NotificationScreen extends StatefulWidget {
  static String id = "notification_screen";

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  List<Map<String, dynamic>> lowStockMedicines = [];
  static int num = nameNavigation.indexOf(NotificationScreen.id);


  @override
  void initState() {
    super.initState();
    fetchLowStockMedicines();
  }

  void fetchLowStockMedicines() async {
    DataSnapshot snapshot = await _databaseReference.child('medicine').get();
    Map<dynamic, dynamic> medicines = snapshot.value as Map<dynamic, dynamic>;

    List<Map<String, dynamic>> tempList = [];
    medicines.forEach((key, value) {
      if (value < 80) {
        tempList.add({'name': key, 'stock': value});
      }
    });

    setState(() {
      lowStockMedicines = tempList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: PersistentBottomNavBar(selectedIndex: num, onItemTapped: (int value) { Navigator.popAndPushNamed(context, nameNavigation[value]); },),

      appBar: AppBar(
        title: Text('Low Stock Notifications'),
      ),
      body: lowStockMedicines.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: lowStockMedicines.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(lowStockMedicines[index]['name']),
            subtitle:
            Text('Low stock: ${lowStockMedicines[index]['stock']} remaining'),
            trailing: Icon(Icons.warning, color: Colors.red),
          );
        },
      ),
    );
  }
}