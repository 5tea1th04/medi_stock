import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pay/pay.dart';

import '../UserWidgets/bottom_navigation_bar.dart';
import '../Utilities/constants.dart';

final _paymentConfiguration = PaymentConfiguration.fromJsonString('''
{
  "provider": "google_pay",
  "data": {
    "environment": "TEST",
    "apiVersion": 2,
    "apiVersionMinor": 0,
    "allowedPaymentMethods": [{
      "type": "CARD",
      "parameters": {
        "allowedAuthMethods": ["PAN_ONLY", "CRYPTOGRAM_3DS"],
        "allowedCardNetworks": ["VISA", "MASTERCARD"]
      },
      "tokenizationSpecification": {
        "type": "PAYMENT_GATEWAY",
        "parameters": {
          "gateway": "example",
          "gatewayMerchantId": "exampleGatewayMerchantId"}
      }
    }]
  }
}
''');

const _paymentItems = [
  PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: PaymentItemStatus.final_price,
  )
];

class OrderScreen extends StatefulWidget {
  static String id = "order_screen";

  // Accept the cheapest distributor as a parameter
  final String? cheapestDistributor;

  const OrderScreen({super.key, this.cheapestDistributor});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  static int screenNum = nameNavigation.indexOf(OrderScreen.id);

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();
  String? selectedDistributor;
  List<Map<String, dynamic>> selectedMedicines = []; // Initialize an empty list

  List<String> distributors = [];
  Map<String, Map<String, dynamic>> distributorData = {};
  List<String> medicines = [];
  Map<String, int> lowStockMedicines = {};

  @override
  void initState() {
    super.initState();
    fetchDistributorsData();
    fetchLowStockMedicines();
  }

  void fetchDistributorsData() async {
    DataSnapshot snapshot =
        await _databaseReference.child('distributors').get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;
      Map<String, Map<String, dynamic>> distributorsMap = {};
      data.forEach((key, value) {
        distributorsMap[key as String] =
            Map<String, dynamic>.from(value as Map);
      });

      setState(() {
        distributors = distributorsMap.values
            .map<String>((distributor) => distributor['name'] as String)
            .toList();
        distributorData = distributorsMap;
        selectedDistributor = widget.cheapestDistributor ?? distributors.first;
        updateMedicinesList(selectedDistributor);

        // Add low stock medicines that are present with the distributor
        if (selectedDistributor != null) {
          addLowStockMedicinesToOrder(selectedDistributor);
        }

        // If no medicines were added, initialize with an empty entry
        if (selectedMedicines.isEmpty) {
          selectedMedicines.add({'medicine': null, 'count': 1});
        }
      });
    }
  }

  void fetchLowStockMedicines() async {
    DataSnapshot snapshot = await _databaseReference.child('medicine').get();
    if (snapshot.exists) {
      final medicines = snapshot.value as Map<dynamic, dynamic>;
      final Map<String, int> filteredMedicines = {};

      medicines.forEach((key, value) {
        if (value is int && value < 80) {
          filteredMedicines[key as String] = value;
        }
      });

      setState(() {
        lowStockMedicines = filteredMedicines;
      });
    }
  }

  void updateMedicinesList(String? distributorName) {
    if (distributorName != null) {
      final distributor = distributorData.values
          .firstWhere((d) => d['name'] == distributorName);
      setState(() {
        medicines = (distributor['medicines'] as Map)
            .keys
            .map<String>((medicine) => medicine as String)
            .toList();
      });
    }
  }

  void addLowStockMedicinesToOrder(String? distributorName) {
    if (distributorName != null) {
      final distributor = distributorData.values
          .firstWhere((d) => d['name'] == distributorName);
      final distributorMedicines =
          distributor['medicines'] as Map<dynamic, dynamic>;
      lowStockMedicines.forEach((medicine, count) {
        if (distributorMedicines.containsKey(medicine)) {
          selectedMedicines.add({'medicine': medicine, 'count': 1});
        }
      });
    }
  }

  void onGooglePayResult(paymentResult) {
    // Send the payment token to your server to process the payment.
    debugPrint(paymentResult.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: PersistentBottomNavBar(
        selectedIndex: screenNum,
        onItemTapped: (int value) {
          Navigator.popAndPushNamed(context, nameNavigation[value]);
        },
      ),
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
                  updateMedicinesList(selectedDistributor);
                  selectedMedicines = []; // Reset selected medicines
                  addLowStockMedicinesToOrder(selectedDistributor);
                  if (selectedMedicines.isEmpty) {
                    selectedMedicines.add({'medicine': null, 'count': 1});
                  }
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
                          onChanged: (newValue) {
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
              child: GooglePayButton(
                paymentConfiguration: _paymentConfiguration,
                paymentItems: _paymentItems,
                type: GooglePayButtonType.pay,
                margin: const EdgeInsets.only(top: 15.0),
                onPaymentResult: onGooglePayResult,
                loadingIndicator: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
