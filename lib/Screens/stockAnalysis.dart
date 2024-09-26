import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../UserWidgets/bottom_navigation_bar.dart';
import '../Utilities/constants.dart';

class StockAnalysis extends StatefulWidget {
  static String id = "Stock_Screen";

  const StockAnalysis({super.key});

  @override
  State<StockAnalysis> createState() => _StockAnalysisState();
}

class _StockAnalysisState extends State<StockAnalysis> {
  final databaseRef = FirebaseDatabase.instance.ref().child('medicine');
  static int num = nameNavigation.indexOf(StockAnalysis.id);

  TextEditingController _searchController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _stockController = TextEditingController();

  List<Map<String, dynamic>> _items = [];
  List<Map<String, dynamic>> _filteredItems = [];
  Map<String, dynamic>? _selectedMedicine;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadItems();
    _searchController.addListener(_filterItems);
  }

  void _loadItems() {
    databaseRef.onValue.listen((event) {
      final data = event.snapshot.value;
      if (data != null) {
        final medicines = (data as Map<dynamic, dynamic>).entries.map((entry) => {
          'id': entry.key,
          'name': entry.key,
          'stock': entry.value,
        }).toList();
        setState(() {
          _items = medicines;
          _filteredItems = medicines;
        });
      } else {
        setState(() {
          _items = [];
          _filteredItems = [];
        });
      }
    });
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _items
          .where((item) => item['name'].toString().toLowerCase().contains(query))
          .toList();});
  }

  void _addItem(String name, int stock) {
    databaseRef.child(name).set(stock).then((_) {
      _loadItems(); // Reload items after adding
    });
  }

  void _updateItem(String id, int stock) {
    databaseRef.child(id).set(stock).then((_) {
      _loadItems(); // Reload items after updating
      _selectedMedicine = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: PersistentBottomNavBar(
        selectedIndex: num,
        onItemTapped: (int value) {
          Navigator.popAndPushNamed(context, nameNavigation[value]);
        },
      ),
      appBar: AppBar(
        title: Text('Stock Details'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const Row(
            children: [
              Expanded(
                child: Text(
                  "  Medicine",
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text(
                "Stock  ",
                style: TextStyle(fontSize: 18),
              )
            ],
          ),
          Expanded(
            child: _items.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _filteredItems.length,
              itemBuilder: (context, index) {
                final item = _filteredItems[index];
                final isLowStock = item['stock'] < 80;
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item['name'],
                          style: TextStyle(color: isLowStock ? Colors.red : null),
                        ),
                      ),
                      Text(
                        item['stock'].toString(),
                        style: TextStyle(color: isLowStock ? Colors.red : null),
                      ),
                    ],
                  ),onTap: () {
                  setState(() {
                    _selectedMedicine = item;
                  });
                },
                  selected: _selectedMedicine == item,
                  selectedTileColor: Colors.grey[300],
                );
              },
            ),
          ),
          if (_selectedMedicine != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Selected Medicine: ${_selectedMedicine!['name']}'),
                  Text('Current Stock: ${_selectedMedicine!['stock']}'),
                  ElevatedButton(
                    onPressed: () {
                      _showUpdateDialog(
                          _selectedMedicine!['id'], _selectedMedicine!['stock']);
                    },
                    child: Text('Edit Stock'),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  void _showUpdateDialog(String id, int stock) {
    _nameController.text = id;
    _stockController.text = stock.toString();
    _showFormDialog('Update Stock', () {
      if (_formKey.currentState!.validate()) {
        _updateItem(_nameController.text, int.parse(_stockController.text));
        Navigator.pop(context);
      }
    });
  }

  void _showAddDialog() {
    _nameController.clear();
    _stockController.clear();
    _showFormDialog('Add Item', () {
      if (_formKey.currentState!.validate()) {
        _addItem(_nameController.text, int.parse(_stockController.text));
        Navigator.pop(context);
      }
    });
  }

  void _showFormDialog(String title, VoidCallback onSubmit) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  controller: _nameController,validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Stock'),
                  controller: _stockController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a stock quantity';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: onSubmit,
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}