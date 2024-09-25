import 'package:flutter/material.dart';

import '../UserWidgets/bottom_navigation_bar.dart';
import '../Utilities/constants.dart';

class OrderScreen extends StatefulWidget {
  static String id = "order_screen";

  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  static int num = nameNavigation.indexOf(OrderScreen.id);

  String? selectedDistributor;
  List<Map<String, dynamic>> selectedMedicines = [{'medicine': null, 'count': 1}
  ]; // List to store selected medicines and their count

  List<String> distributors = [
    'Distributor A',
    'Distributor B',
    'Distributor C'
  ];
  List<String> medicines = ['Medicine A', 'Medicine B', 'Medicine C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: PersistentBottomNavBar(selectedIndex: num, onItemTapped: (int value) { Navigator.popAndPushNamed(context, nameNavigation[value]); },),

      appBar: AppBar(
        title: Text(
          "ORDER",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),body: Padding(
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

          // Medicine Dropdowns with Add/Remove Buttons and Count
          Expanded(
            child: ListView.builder(
              itemCount: selectedMedicines.length,
              itemBuilder: (context, index) {
                return Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                            labelText: 'Medicine ${index + 1}'),
                        value: selectedMedicines[index]['medicine'],
                        onChanged: (newValue){
                          setState(() {
                            selectedMedicines[index]['medicine'] = newValue;
                          });
                        },
                        items: medicines.map((medicine) {
                          return DropdownMenuItem(
                            value: medicine,
                            child: Text(medicine),
                          );
                        }).toList(),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.remove),
                          onPressed: () {
                            if (selectedMedicines[index]['count'] > 1) {
                              setState(() {
                                selectedMedicines[index]['count']--;
                              });
                            }
                          },
                        ),
                        Text('${selectedMedicines[index]['count']}'),
                        IconButton(
                          icon: Icon(Icons.add),
                          onPressed: () {
                            setState(() {
                              selectedMedicines[index]['count']++;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            if (selectedMedicines.length > 1) {
                              setState(() {
                                selectedMedicines.removeAt(index);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedMedicines.add({'medicine': null, 'count': 1});
                  });
                },
                child: Text('Add'),
              ),
            ],
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