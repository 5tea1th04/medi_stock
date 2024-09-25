import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  static String id = "notification_screen";
  final List<Map<String, dynamic>> lowStockMedicines = [
    {'name': 'Medicine A', 'stock': 10},
    {'name': 'Medicine B', 'stock': 5},
    {'name': 'Medicine C', 'stock': 2},];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Low Stock Notifications'),
      ),
      body: ListView.builder(
        itemCount: lowStockMedicines.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(lowStockMedicines[index]['name']),
            subtitle: Text(
                'Low stock: ${lowStockMedicines[index]['stock']} remaining'),
            trailing: Icon(Icons.warning, color: Colors.red),);
        },
      ),
    );
  }
}