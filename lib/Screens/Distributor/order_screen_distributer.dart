import 'package:flutter/material.dart';

class OrderScreenDistributer extends StatefulWidget {
  static String id = "order_screen_distributor";

  const OrderScreenDistributer({super.key});

  @override
  State<OrderScreenDistributer> createState() => _OrderScreenDistributerState();
}

class _OrderScreenDistributerState extends State<OrderScreenDistributer> {
  List<Map<String, dynamic>> orders = [
    // Sample order data
    {
      'id': 1,
      'pharmacyName': 'Pharmacy A','location': 'Location A',
      'medicines': [
        {'name': 'Medicine 1', 'quantity': 2, 'price': 10.0},
        {'name': 'Medicine 2', 'quantity': 5, 'price': 5.0},
      ],
      'status': 'Pending'
    },
    {
      'id': 2,
      'pharmacyName': 'Pharmacy B',
      'location': 'Location B',
      'medicines': [
        {'name': 'Medicine 3', 'quantity': 3, 'price': 15.0},
      ],
      'status': 'Pending'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ORDERS RECIEVED"),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "Orders Pending",
              style:TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text("Order #${orders[index]['id']}"),
                  subtitle: Text("Pharmacy: ${orders[index]['pharmacyName']}"),
                  trailing: Text("Status: ${orders[index]['status']}"),
                  onTap: () {
                    _showOrderDetails(index);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showOrderDetails(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Order Details"),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Location: ${orders[index]['location']}"),
                Text("Pharmacy Name: ${orders[index]['pharmacyName']}"),
                SizedBox(height: 10),
                Text(
                  "Medicines:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ...orders[index]['medicines']
                    .map((medicine) => _buildMedicineItem(
                    medicine['name'],
                    medicine['quantity'],
                    medicine['price']))
                    .toList(),
                Divider(),
                Text(
                    "Total Price: \$${_calculateTotalPrice(orders[index]['medicines'])}"),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
            TextButton(
              onPressed: () {
                _markOrderAsDelivered(index);
                Navigator.of(context).pop();
              },
              child: Text("Deliver"),
            ),
          ],
        );
      },
    );
  }

  void _markOrderAsDelivered(int index) {
    setState(() {
      orders[index]['status'] = 'Delivered';
      // Move the delivered order to the bottom of the list
      var deliveredOrder =orders.removeAt(index);
      orders.add(deliveredOrder);
    });
  }

  double _calculateTotalPrice(List<Map<String, dynamic>> medicines) {
    double totalPrice = 0;
    for (var medicine in medicines) {
      totalPrice += medicine['quantity'] * medicine['price'];
    }
    return totalPrice;
  }

  Widget _buildMedicineItem(String name, int quantity, double price) {
    return Text("$name x $quantity (\$${price.toStringAsFixed(2)} each)");
  }
}