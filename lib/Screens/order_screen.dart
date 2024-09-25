import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  static String id = "order_screen";const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? selectedDistributor;
  int medicineCount = 1;
  List<String?> selectedMedicines = [null]; // List to store selected medicines

  List<String> distributors = ['Distributor A', 'Distributor B', 'Distributor C'];
  List<String> medicines = ['Medicine A', 'Medicine B', 'Medicine C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ORDER",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Distributor Dropdown
            DropdownButtonFormField<String>(
              decoration: InputDecoration(labelText: 'Distributor'),
              value: selectedDistributor,
              onChanged: (newValue) {
                setState(() {
                  selectedDistributor = newValue;
                });
              },
              items: distributors.map((distributor) {
                return DropdownMenuItem(
                  value: distributor,
                  child: Text(distributor),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // Medicine Counter
            Row(
              children: [
                Text('Select Medicines:'),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (medicineCount > 1) {
                      setState(() {
                        medicineCount--;
                        selectedMedicines.removeLast();
                      });
                    }
                  },
                ),
                Text('$medicineCount'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      medicineCount++;
                      selectedMedicines.add(null);
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // Medicine Dropdowns
            Expanded(
              child: ListView.builder(
                itemCount: medicineCount,
                itemBuilder: (context, index) {
                  return DropdownButtonFormField<String>(
                    decoration:
                    InputDecoration(labelText: 'Medicine ${index + 1}'),
                    value: selectedMedicines[index],
                    onChanged: (newValue) {
                      setState(() {
                        selectedMedicines[index] = newValue;
                      });
                    },
                    items: medicines.map((medicine) {
                      return DropdownMenuItem(
                        value: medicine,
                        child: Text(medicine),
                      );
                    }).toList(),
                  );
                },
              ),
            ),

            // Order Now Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle order submission
                },
                child: Text('Order Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}